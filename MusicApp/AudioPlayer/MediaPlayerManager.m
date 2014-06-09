//
//  AudioPlayerManager.m
//  HunnuAir
//
//  Created by Sodtseren Enkhee on 2/6/14.
//  Copyright (c) 2014 Egi. All rights reserved.
//

#import "MediaPlayerManager.h"

static void *MyStreamingMovieViewControllerTimedMetadataObserverContext = &MyStreamingMovieViewControllerTimedMetadataObserverContext;
static void *MyStreamingMovieViewControllerRateObservationContext = &MyStreamingMovieViewControllerRateObservationContext;
static void *MyStreamingMovieViewControllerCurrentItemObservationContext = &MyStreamingMovieViewControllerCurrentItemObservationContext;
static void *MyStreamingMovieViewControllerPlayerItemStatusObserverContext = &MyStreamingMovieViewControllerPlayerItemStatusObserverContext;

NSString *kTracksKey		= @"tracks";
NSString *kStatusKey		= @"status";
NSString *kRateKey			= @"rate";
NSString *kPlayableKey		= @"playable";
NSString *kCurrentItemKey	= @"currentItem";
NSString *kTimedMetadataKey	= @"currentItem.timedMetadata";

@interface MediaPlayerManager() {
    //Temps
    BOOL seekToZeroBeforePlay;
	float restoreAfterScrubbingRate;
//for CirclularSlider
    BOOL calledBeginScrub;
}

@property (nonatomic, strong) id timeObserver;

@end

@implementation MediaPlayerManager
@synthesize player;
@synthesize playerItem;
@synthesize timeObserver;
@synthesize UISource;
@synthesize myDelegate;

+ (MediaPlayerManager *)getAudioPlayerManager
{
    static dispatch_once_t once;
    static MediaPlayerManager *manager;
    dispatch_once(&once, ^{
        manager = [[MediaPlayerManager alloc] init];
    });
    return manager;
}

+ (void)resetAudioPlayerManager {
    [MediaPlayerManager getAudioPlayerManager].UISource = nil;
    [MediaPlayerManager getAudioPlayerManager].myDelegate = nil;
    
    [[MediaPlayerManager getAudioPlayerManager] destroyStream];
    
    MediaPlayerManager *manager = [MediaPlayerManager getAudioPlayerManager];
    manager = [[MediaPlayerManager alloc] init];
}

- (void)setUISource:(NSObject<AudioPlayerUISource> *)_UISource {
    UISource = _UISource;
    [self initializeUIActions];
}

- (void)initializeUIActions {
    
    [[self.UISource playerPrevButton] removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
    [[self.UISource playerPlayButton] removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
    [[self.UISource playerStopButton] removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
    [[self.UISource playerNextButton] removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
    [[self.UISource playerSlider] removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
    [[self.UISource playerVolumeSlider] removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
    
    [[self.UISource playerPrevButton] addTarget:self action:@selector(previous) forControlEvents:UIControlEventTouchUpInside];
    [[self.UISource playerPlayButton] addTarget:self action:@selector(play) forControlEvents:UIControlEventTouchUpInside];
    [[self.UISource playerStopButton] addTarget:self action:@selector(pause) forControlEvents:UIControlEventTouchUpInside];
    [[self.UISource playerNextButton] addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
    [[self.UISource playerSlider] addTarget:self action:@selector(beginScrubbing:) forControlEvents:UIControlEventTouchDown];
    [[self.UISource playerSlider] addTarget:self action:@selector(scrub:) forControlEvents:UIControlEventTouchDragInside];
    [[self.UISource playerSlider] addTarget:self action:@selector(endScrubbing:) forControlEvents:UIControlEventTouchUpInside];
    [[self.UISource playerSlider] addTarget:self action:@selector(endScrubbing:) forControlEvents:UIControlEventTouchUpOutside];
    [[self.UISource playerSlider] addTarget:self action:@selector(scrub:) forControlEvents:UIControlEventValueChanged];
    //playerVolumeSlider
    [[self.UISource playerVolumeSlider] addTarget:self action:@selector(beginScrubbing:) forControlEvents:UIControlEventTouchDown];
    [[self.UISource playerVolumeSlider] addTarget:self action:@selector(scrub:) forControlEvents:UIControlEventTouchDragInside];
    [[self.UISource playerVolumeSlider] addTarget:self action:@selector(endScrubbing:) forControlEvents:UIControlEventTouchUpInside];
    [[self.UISource playerVolumeSlider] addTarget:self action:@selector(endScrubbing:) forControlEvents:UIControlEventTouchUpOutside];
    [[self.UISource playerVolumeSlider] addTarget:self action:@selector(scrub:) forControlEvents:UIControlEventValueChanged];
}

#pragma mark -
#pragma mark Public
- (void)initAudioFromURL:(NSURL *)mediaUrl completed:(void (^)(NSError *error))completed {
    //Initialize
    
    if ([mediaUrl scheme])	/* Sanity check on the URL. */
    {
        [[self.UISource playerIndicator] startAnimating];
        /*
         Create an asset for inspection of a resource referenced by a given URL.
         Load the values for the asset keys "tracks", "playable".
         */
        AVURLAsset *asset = [AVURLAsset URLAssetWithURL:mediaUrl options:nil];
        
        NSArray *requestedKeys = [NSArray arrayWithObjects:kTracksKey, kPlayableKey, nil];
        
        /* Tells the asset to load the values of any of the specified keys that are not already loaded. */
        [asset loadValuesAsynchronouslyForKeys:requestedKeys completionHandler:
         ^{
             dispatch_async( dispatch_get_main_queue(),
                            ^{
                                [[self.UISource playerIndicator] stopAnimating];
                                /* IMPORTANT: Must dispatch to main queue in order to operate on the AVPlayer and AVPlayerItem. */
                                BOOL playable = [self prepareToPlayAsset:asset withKeys:requestedKeys];
                                
                                if (playable) {
                                    if (completed) {
                                        completed(nil);
                                    }
                                } else {
                                    if (completed) {
                                        completed([[NSError alloc] init]);
                                    }
                                }
                            });
         }];
    }

}

#pragma mark -
#pragma mark Play, Stop Buttons
#pragma mark -
/* Show the stop button in the movie player controller. */
-(void)showStopButton
{
    [self.UISource playerPlayButton].hidden = YES;
    [self.UISource playerStopButton].hidden = NO;
    
    if (self.myDelegate) {
        [self.myDelegate audioPlaying];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kAudioPlayingObserver object:nil userInfo:nil];
    }
}

/* Show the play button in the movie player controller. */
-(void)showPlayButton
{
    [self.UISource playerPlayButton].hidden = NO;
    [self.UISource playerStopButton].hidden = YES;
    
    if (self.myDelegate) {
        [self.myDelegate audioNotPlaying];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kAudioStopingObserver object:nil userInfo:nil];
    }
}

/* If the media is playing, show the stop button; otherwise, show the play button. */
- (void)syncPlayPauseButtons
{
	if ([self isPlaying])
	{
        [self showStopButton];
	}
	else
	{
        [self showPlayButton];
	}
}

-(void)enablePlayerButtons
{
    [self.UISource playerPlayButton].enabled = YES;
    [self.UISource playerStopButton].enabled = YES;
}

-(void)disablePlayerButtons
{
    [self.UISource playerPlayButton].enabled = NO;
    [self.UISource playerStopButton].enabled = NO;
}

#pragma mark -
#pragma mark Scrubber control
#pragma mark -
/* Set the scrubber based on the player current time. */
- (void)syncScrubber
{
	CMTime playerDuration = [self playerItemDuration];
	if (CMTIME_IS_INVALID(playerDuration))
	{
		[self.UISource playerSlider].minimumValue = 0.0;
		return;
	}
	
	double duration = CMTimeGetSeconds(playerDuration);
	if (isfinite(duration) && (duration > 0))
	{
		float minValue = [[self.UISource playerSlider] minimumValue];
		float maxValue = [[self.UISource playerSlider] maximumValue];
		double time = CMTimeGetSeconds([player currentTime]);
        
        [UIView animateWithDuration:0.1f animations:^{
            [[self.UISource playerSlider] setValue:(maxValue - minValue) * time / duration + minValue];
        }];
        
        //[NSString stringWithFormat:@"%02i:%02i / %02i:%02i", (int)time/60, (int)time%60, (int)duration/60, (int)duration % 60];
        
        [self.UISource playerStatusLabel1].text = [NSString stringWithFormat:@"%02i:%02i", (int)time/60, (int)time%60];
        [self.UISource playerStatusLabel2].text = [NSString stringWithFormat:@"%02i:%02i", (int)duration/60, (int)duration % 60];
	}
}

/* Requests invocation of a given block during media playback to update the
 movie scrubber control. */
-(void)initScrubberTimer
{
	double interval = .1f;
	
	CMTime playerDuration = [self playerItemDuration];
	if (CMTIME_IS_INVALID(playerDuration))
	{
		return;
	}
	double duration = CMTimeGetSeconds(playerDuration);
    
	if (isfinite(duration))
	{
		CGFloat width = CGRectGetWidth([[self.UISource playerSlider] bounds]);
        if (width <= 0)
            width = 10;
            
        interval = 0.5f * duration / width;
	}

    __weak typeof(self) weakSelf = self;
    
	/* Update the scrubber during normal playback. */
	self.timeObserver = [player addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(interval, NSEC_PER_SEC)
                                                             queue:NULL
                                                        usingBlock:
                         ^(CMTime time)
                         {
                             [weakSelf syncScrubber];
                         }];
}

/* Cancels the previously registered time observer. */
-(void)removePlayerTimeObserver
{
	if (timeObserver)
	{
		[player removeTimeObserver:timeObserver];
		self.timeObserver = nil;
	}
}

/* The user is dragging the movie controller thumb to scrub through the movie. */
- (void)beginScrubbing:(id)sender
{
    if (sender == [self.UISource playerVolumeSlider]) {
        
        self.player.volume = [self.UISource playerVolumeSlider].value;
        
    } else {
        /*
//for CirclularSlider
        if (!calledBeginScrub) {
//for CirclularSlider
            calledBeginScrub = YES;
        
            restoreAfterScrubbingRate = [player rate];
            [player setRate:0.f];
            
            //Remove previous timer.
            [self removePlayerTimeObserver];
//for CirclularSlider
        
        }*/
    }
}

/* The user has released the movie thumb control to stop scrubbing through the movie. */
- (void)endScrubbing:(id)sender
{
    if (sender == [self.UISource playerVolumeSlider]) {
        
        self.player.volume = [self.UISource playerVolumeSlider].value;
        if (self.myDelegate) {
            [self.myDelegate volumeEndScrub];
        }
        
    } else {
        
//for CirclularSlider
        calledBeginScrub = NO;
        
        if (!timeObserver)
        {
            CMTime playerDuration = [self playerItemDuration];
            if (CMTIME_IS_INVALID(playerDuration))
            {
                return;
            }
            
            double duration = CMTimeGetSeconds(playerDuration);
            if (isfinite(duration))
            {
                
//for UISlider
                
//			CGFloat width = CGRectGetWidth([[self.UISource playerSlider] bounds]);
//			double tolerance = 0.5f * duration / width;
                
//for CirclularSlider
                
                CGFloat width = [self sliderLength];
                double tolerance = 0.5f * duration / width;
                
                __weak typeof(self) weakSelf = self;
                
                self.timeObserver = [player addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(tolerance, NSEC_PER_SEC) queue:dispatch_get_main_queue() usingBlock:
                                     ^(CMTime time)
                                     {
                                         [weakSelf syncScrubber];
                                     }];
            }
        }
        
        if (restoreAfterScrubbingRate)
        {
            [player setRate:restoreAfterScrubbingRate];
            restoreAfterScrubbingRate = 0.f;
        }
    }
}

/* Set the player current time to match the scrubber position. */
- (void)scrub:(id)sender
{
    if (sender == [self.UISource playerVolumeSlider]) {
        
        self.player.volume = [self.UISource playerVolumeSlider].value;
        
    } else {
        
        if ([sender isKindOfClass:[UICircularSlider class]])
        {
            //for CirclularSlider
            if (!calledBeginScrub) {
                //for CirclularSlider
                calledBeginScrub = YES;
                
                restoreAfterScrubbingRate = [player rate];
                [player setRate:0.f];
                
                /* Remove previous timer. */
                [self removePlayerTimeObserver];
                //for CirclularSlider
            }

            
            UICircularSlider* slider = sender;
            
            CMTime playerDuration = [self playerItemDuration];
            if (CMTIME_IS_INVALID(playerDuration)) {
                return;
            }
            
            double duration = CMTimeGetSeconds(playerDuration);
            if (isfinite(duration))
            {
                float minValue = [slider minimumValue];
                float maxValue = [slider maximumValue];
                float value = [slider value];
                
                double time = duration * (value - minValue) / (maxValue - minValue);
                
                [player seekToTime:CMTimeMakeWithSeconds(time, NSEC_PER_SEC)];
            }
        }
    }
}

- (BOOL)isScrubbing
{
	return restoreAfterScrubbingRate != 0.f;
}

-(void)enableScrubber
{
    [self.UISource playerSlider].enabled = YES;
    [self.UISource playerVolumeSlider].enabled = YES;
}

-(void)disableScrubber
{
    [self.UISource playerSlider].enabled = NO;
    [self.UISource playerVolumeSlider].enabled = NO;
}

/* Prevent the slider from seeking during Ad playback. */
- (void)sliderSyncToPlayerSeekableTimeRanges
{
	NSArray *seekableTimeRanges = [[player currentItem] seekableTimeRanges];
	if ([seekableTimeRanges count] > 0)
	{
		NSValue *range = [seekableTimeRanges objectAtIndex:0];
		CMTimeRange timeRange = [range CMTimeRangeValue];
		float startSeconds = CMTimeGetSeconds(timeRange.start);
		float durationSeconds = CMTimeGetSeconds(timeRange.duration);
		
		/* Set the minimum and maximum values of the time slider to match the seekable time range. */
		[self.UISource playerSlider].minimumValue = startSeconds;
		[self.UISource playerSlider].maximumValue = startSeconds + durationSeconds;
	}
}

#pragma mark -
#pragma mark Button Action Methods
#pragma mark -
- (void)play {
	/* If we are at the end of the movie, we must seek to the beginning first
     before starting playback. */
	if (YES == seekToZeroBeforePlay)
	{
		seekToZeroBeforePlay = NO;
		[player seekToTime:kCMTimeZero];
	}
    
    //Make sure the system follows our playback status
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive: YES error: nil];
	[player play];
	
    [self showStopButton];
}

- (void)pause {
	[player pause];
    
    [self showPlayButton];
}

- (void)next:(id)sender {
    
    if (self.myDelegate) {
        [self.myDelegate audioWillGoNext:sender == nil];
    }
}

- (void) previous {
    
    if (self.myDelegate) {
        [self.myDelegate audioWillGoPrevious];
    }
}


#pragma mark -
#pragma mark Private
#pragma mark -
- (CMTime)playerItemDuration
{
	AVPlayerItem *thePlayerItem = [player currentItem];
	if (thePlayerItem.status == AVPlayerItemStatusReadyToPlay)
	{
        /*
         NOTE:
         Because of the dynamic nature of HTTP Live Streaming Media, the best practice
         for obtaining the duration of an AVPlayerItem object has changed in iOS 4.3.
         Prior to iOS 4.3, you would obtain the duration of a player item by fetching
         the value of the duration property of its associated AVAsset object. However,
         note that for HTTP Live Streaming Media the duration of a player item during
         any particular playback session may differ from the duration of its asset. For
         this reason a new key-value observable duration property has been defined on
         AVPlayerItem.
         
         See the AV Foundation Release Notes for iOS 4.3 for more information.
         */
        
		return([playerItem duration]);
	}
    
	return(kCMTimeInvalid);
}

- (BOOL)isPlaying
{
	return restoreAfterScrubbingRate != 0.f || [player rate] != 0.f;
}



#pragma mark -
#pragma mark Player Notifications
#pragma mark -
/* Called when the player item has played to its end time. */
- (void) playerItemDidReachEnd:(NSNotification*) aNotification
{
	/* Hide the 'Pause' button, show the 'Play' button in the slider control */
    [self showPlayButton];
    
	/* After the movie has played to its end time, seek back to time zero
     to play it again */
	seekToZeroBeforePlay = YES;
    
    [self next:nil];
}




#pragma mark -
#pragma mark Timed metadata
#pragma mark -
- (void)handleTimedMetadata:(AVMetadataItem*)timedMetadata
{
	/* We expect the content to contain plists encoded as timed metadata. AVPlayer turns these into NSDictionaries. */
	if ([(NSString *)[timedMetadata key] isEqualToString:AVMetadataID3MetadataKeyGeneralEncapsulatedObject])
	{
		if ([[timedMetadata value] isKindOfClass:[NSDictionary class]])
		{
			NSDictionary *propertyList = (NSDictionary *)[timedMetadata value];
            
			/* Metadata payload could be the list of ads. */
			NSArray *newAdList = [propertyList objectForKey:@"ad-list"];
			if (newAdList != nil)
			{
				[self updateAdList:newAdList];
				NSLog(@"ad-list is %@", newAdList);
			}
            
			/* Or it might be an ad record. */
			NSString *adURL = [propertyList objectForKey:@"url"];
			if (adURL != nil)
			{
				if ([adURL isEqualToString:@""])
				{
					/* Ad is not playing, so clear text. */
                    //					isPlayingAdText.text = @"";
                    
                    [self enablePlayerButtons];
                    [self enableScrubber]; /* Enable seeking for main content. */
                    
					NSLog(@"enabling seek at %g", CMTimeGetSeconds([player currentTime]));
				}
				else
				{
					/* Display text indicating that an Ad is now playing. */
                    //					isPlayingAdText.text = @"< Ad now playing, seeking is disabled on the movie controller... >";
					
                    [self disablePlayerButtons];
                    [self disableScrubber]; 	/* Disable seeking for ad content. */
                    
					NSLog(@"disabling seek at %g", CMTimeGetSeconds([player currentTime]));
				}
			}
		}
	}
}

#pragma mark -
#pragma mark Ad list
#pragma mark -
/* Update current ad list, set slider to match current player item seekable time ranges */
- (void)updateAdList:(NSArray *)newAdList
{
//	if (!adListArray || ![adListArray isEqualToArray:newAdList])
//	{
//		self.adListArray = newAdList;
//        
		[self sliderSyncToPlayerSeekableTimeRanges];
//	}
}

#pragma mark -
#pragma mark Loading the Asset Keys Asynchronously

#pragma mark -
#pragma mark Error Handling - Preparing Assets for Playback Failed

/* --------------------------------------------------------------
 **  Called when an asset fails to prepare for playback for any of
 **  the following reasons:
 **
 **  1) values of asset keys did not load successfully,
 **  2) the asset keys did load successfully, but the asset is not
 **     playable
 **  3) the item did not become ready to play.
 ** ----------------------------------------------------------- */

-(void)assetFailedToPrepareForPlayback:(NSError *)error
{
    [self removePlayerTimeObserver];
    [self syncScrubber];
    [self disableScrubber];
    [self disablePlayerButtons];
    
    /* Display the error. */
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[error localizedDescription]
														message:[error localizedFailureReason]
													   delegate:nil
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil];
	[alertView show];
}

#pragma mark -
#pragma mark Prepare to play asset
#pragma mark -
/*
 Invoked at the completion of the loading of the values for all keys on the asset that we require.
 Checks whether loading was successfull and whether the asset is playable.
 If so, sets up an AVPlayerItem and an AVPlayer to play the asset.
 */
- (BOOL)prepareToPlayAsset:(AVURLAsset *)asset withKeys:(NSArray *)requestedKeys
{
    /* Make sure that the value of each key has loaded successfully. */
	for (NSString *thisKey in requestedKeys)
	{
		NSError *error = nil;
		AVKeyValueStatus keyStatus = [asset statusOfValueForKey:thisKey error:&error];
		if (keyStatus == AVKeyValueStatusFailed)
		{
			[self assetFailedToPrepareForPlayback:error];
			return NO;
		}
		/* If you are also implementing the use of -[AVAsset cancelLoading], add your code here to bail
         out properly in the case of cancellation. */
	}
    
    /* Use the AVAsset playable property to detect whether the asset can be played. */
    if (!asset.playable)
    {
        /* Generate an error describing the failure. */
		NSString *localizedDescription = NSLocalizedString(@"Item cannot be played", @"Item cannot be played description");
		NSString *localizedFailureReason = NSLocalizedString(@"The assets tracks were loaded, but could not be made playable.", @"Item cannot be played failure reason");
		NSDictionary *errorDict = [NSDictionary dictionaryWithObjectsAndKeys:
								   localizedDescription, NSLocalizedDescriptionKey,
								   localizedFailureReason, NSLocalizedFailureReasonErrorKey,
								   nil];
		NSError *assetCannotBePlayedError = [NSError errorWithDomain:@"StitchedStreamPlayer" code:0 userInfo:errorDict];
        
        /* Display the error to the user. */
        [self assetFailedToPrepareForPlayback:assetCannotBePlayedError];
        
        return NO;
    }
	
	/* At this point we're ready to set up for playback of the asset. */
    
	[self initScrubberTimer];
	[self enableScrubber];
	[self enablePlayerButtons];
	
    /* Stop observing our prior AVPlayerItem, if we have one. */
    if (self.playerItem)
    {
        /* Remove existing player item key value observers and notifications. */
        
        [self.playerItem removeObserver:self forKeyPath:kStatusKey];
		
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:AVPlayerItemDidPlayToEndTimeNotification
                                                      object:self.playerItem];
    }
	
    /* Create a new instance of AVPlayerItem from the now successfully loaded AVAsset. */
    self.playerItem = [AVPlayerItem playerItemWithAsset:asset];
    
    /* Observe the player item "status" key to determine when it is ready to play. */
    [self.playerItem addObserver:self
                      forKeyPath:kStatusKey
                         options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                         context:MyStreamingMovieViewControllerPlayerItemStatusObserverContext];
	
    /* When the player item has played to its end time we'll toggle
     the movie controller Pause button to be the Play button */
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:self.playerItem];
	
    seekToZeroBeforePlay = NO;
	
    /* Create new player, if we don't already have one. */
    if (![self player])
    {
        /* Get a new AVPlayer initialized to play the specified player item. */
        [self setPlayer:[AVPlayer playerWithPlayerItem:self.playerItem]];
		
        /* Observe the AVPlayer "currentItem" property to find out when any
         AVPlayer replaceCurrentItemWithPlayerItem: replacement will/did
         occur.*/
        [self.player addObserver:self
                      forKeyPath:kCurrentItemKey
                         options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                         context:MyStreamingMovieViewControllerCurrentItemObservationContext];
        
        /* A 'currentItem.timedMetadata' property observer to parse the media stream timed metadata. */
        [self.player addObserver:self
                      forKeyPath:kTimedMetadataKey
                         options:0
                         context:MyStreamingMovieViewControllerTimedMetadataObserverContext];
        
        /* Observe the AVPlayer "rate" property to update the scrubber control. */
        [self.player addObserver:self
                      forKeyPath:kRateKey
                         options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                         context:MyStreamingMovieViewControllerRateObservationContext];
    }
    
    /* Make our new AVPlayerItem the AVPlayer's current item. */
    if (self.player.currentItem != self.playerItem)
    {
        /* Replace the player item with a new player item. The item replacement occurs
         asynchronously; observe the currentItem property to find out when the
         replacement will/did occur*/
        [[self player] replaceCurrentItemWithPlayerItem:self.playerItem];
        
        [self syncPlayPauseButtons];
    }
	
    [UIView animateWithDuration:0.1f animations:^{
        [[self.UISource playerSlider] setValue:0.0];
    }];
    [self.UISource playerStatusLabel1].text = @"";
    [self.UISource playerStatusLabel2].text = @"";
    
    return YES;
}

#pragma mark -
#pragma mark Asset Key Value Observing
#pragma mark

#pragma mark Key Value Observer for player rate, currentItem, player item status

/* ---------------------------------------------------------
 **  Called when the value at the specified key path relative
 **  to the given object has changed.
 **  Adjust the movie play and pause button controls when the
 **  player item "status" value changes. Update the movie
 **  scrubber control when the player item is ready to play.
 **  Adjust the movie scrubber control when the player item
 **  "rate" value changes. For updates of the player
 **  "currentItem" property, set the AVPlayer for which the
 **  player layer displays visual output.
 **  NOTE: this method is invoked on the main queue.
 ** ------------------------------------------------------- */

- (void)observeValueForKeyPath:(NSString*) path
                      ofObject:(id)object
                        change:(NSDictionary*)change
                       context:(void*)context
{
	/* AVPlayerItem "status" property value observer. */
	if (context == MyStreamingMovieViewControllerPlayerItemStatusObserverContext)
	{
		[self syncPlayPauseButtons];
        
        AVPlayerStatus status = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
        switch (status)
        {
                /* Indicates that the status of the player is not yet known because
                 it has not tried to load new media resources for playback */
            case AVPlayerStatusUnknown:
            {
                [[self.UISource playerIndicator] startAnimating];
                
                [self removePlayerTimeObserver];
                [self syncScrubber];
                
                [self disableScrubber];
                [self disablePlayerButtons];
            }
                break;
                
            case AVPlayerStatusReadyToPlay:
            {
                [[self.UISource playerIndicator] stopAnimating];
                
                /* Once the AVPlayerItem becomes ready to play, i.e.
                 [playerItem status] == AVPlayerItemStatusReadyToPlay,
                 its duration can be fetched from the item. */
                
                [self.UISource playerVideoView].playerLayer.hidden = NO;
                
                /* Show the movie slider control since the movie is now ready to play. */
                [self.UISource playerSlider].hidden = NO;
                
                [self enableScrubber];
                [self enablePlayerButtons];
                
                [self.UISource playerVideoView].playerLayer.backgroundColor = [[UIColor blackColor] CGColor];
                
                /* Set the AVPlayerLayer on the view to allow the AVPlayer object to display
                 its content. */
                [[self.UISource playerVideoView].playerLayer setPlayer:player];
                
                [self initScrubberTimer];
            }
                break;
                
            case AVPlayerStatusFailed:
            {
                [[self.UISource playerIndicator] stopAnimating];
                
                AVPlayerItem *thePlayerItem = (AVPlayerItem *)object;
                [self assetFailedToPrepareForPlayback:thePlayerItem.error];
            }
                break;
        }
	}
	/* AVPlayer "rate" property value observer. */
	else if (context == MyStreamingMovieViewControllerRateObservationContext)
	{
        [self syncPlayPauseButtons];
	}
	/* AVPlayer "currentItem" property observer.
     Called when the AVPlayer replaceCurrentItemWithPlayerItem:
     replacement will/did occur. */
	else if (context == MyStreamingMovieViewControllerCurrentItemObservationContext)
	{
        AVPlayerItem *newPlayerItem = [change objectForKey:NSKeyValueChangeNewKey];
        
        /* New player item null? */
        if (newPlayerItem == (id)[NSNull null])
        {
            [self disablePlayerButtons];
            [self disableScrubber];
            
            //            isPlayingAdText.text = @"";
        }
        else /* Replacement of player currentItem has occurred */
        {
            /* Set the AVPlayer for which the player layer displays visual output. */
            [[self.UISource playerVideoView].playerLayer setPlayer:self.player];
            
            /* Specifies that the player should preserve the video’s aspect ratio and
             fit the video within the layer’s bounds. */
            [[self.UISource playerVideoView] setVideoFillMode:AVLayerVideoGravityResizeAspect];
            
            [self syncPlayPauseButtons];
        }
	}
	/* Observe the AVPlayer "currentItem.timedMetadata" property to parse the media stream
     timed metadata. */
	else if (context == MyStreamingMovieViewControllerTimedMetadataObserverContext)
	{
		NSArray* array = [[player currentItem] timedMetadata];
		for (AVMetadataItem *metadataItem in array)
		{
			[self handleTimedMetadata:metadataItem];
		}
	}
	else
	{
		[super observeValueForKeyPath:path ofObject:object change:change context:context];
	}
    
    return;
}


#pragma mark -
#pragma mark User
#pragma mark -
- (void) destroyStream {
    
    [self pause];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:AVPlayerItemDidPlayToEndTimeNotification
                                                  object:nil];
    
    [self.player removeObserver:self forKeyPath:kCurrentItemKey];
    [self.player removeObserver:self forKeyPath:kTimedMetadataKey];
    [self.player removeObserver:self forKeyPath:kRateKey];
    [self setPlayer:nil];
    
    [self.playerItem addObserver:self
                      forKeyPath:kStatusKey
                         options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                         context:MyStreamingMovieViewControllerPlayerItemStatusObserverContext];
    [self.playerItem removeObserver:self forKeyPath:kStatusKey];
    [self setPlayerItem:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Drawing methods
#define kLineWidth 5.0
#define kThumbRadius 12.0
- (CGFloat)sliderLength {
	CGFloat radius = MIN([self.UISource playerSlider].bounds.size.width/2, [self.UISource playerSlider].bounds.size.height/2);
	radius -= MAX(kLineWidth, kThumbRadius);
    
	return radius*2*M_PI;
}

@end
