//
//  MediaPlayerView.m
//  BoldRepo
//
//  Created by Sodtseren Enkhee on 5/22/14.
//  Copyright (c) 2014 Sodtseren Enkhee. All rights reserved.
//

#import "MediaPlayerView.h"
#import <UICircularSlider/UICircularSlider.h>
#import "MediaPlayerManager.h"
#import <Social/Social.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AudioToolbox/AudioToolbox.h>

#define MY_SIZE     CGSizeMake(MY_BOUNDS.width, 180)

@interface MediaPlayerView()<AudioPlayerUISource, AudioPlayerManagerDelegate> {
    
    float currentAlbumImageViewRotation;
    NSTimer *albumImageViewRotationTimer;
}

@property (nonatomic, strong) UIView        *bottomToolbarView;
@property (nonatomic, strong) UIButton      *fbButton;
@property (nonatomic, strong) UIButton      *twButton;
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;
@property (nonatomic, strong) UIImageView   *bottomImageView;
@property (nonatomic, strong) UIImageView   *albumImageView;
@property (nonatomic, strong) UILabel       *statusLabel1;
@property (nonatomic, strong) UILabel       *statusLabel2;
@property (nonatomic, strong) UIButton      *previousButton;
@property (nonatomic, strong) UIButton      *playButton;
@property (nonatomic, strong) UIButton      *stopButton;
@property (nonatomic, strong) UIButton      *nextButton;
@property (nonatomic, strong) UIButton      *repeatButton;
@property (nonatomic, strong) UIButton      *shuffleButton;
@property (nonatomic, strong) UIButton      *itunesButton;
@property (nonatomic, strong) UICircularSlider  *circularSliderControl;

@property (nonatomic, strong) NSMutableArray *playedIndexArray;

@end

@implementation MediaPlayerView
@synthesize rootViewController;
@synthesize bottomToolbarView;
@synthesize fbButton;
@synthesize twButton;
@synthesize indicatorView;
@synthesize bottomImageView;
@synthesize albumImageView;
@synthesize statusLabel1;
@synthesize statusLabel2;
@synthesize previousButton;
@synthesize playButton;
@synthesize stopButton;
@synthesize nextButton;
@synthesize repeatButton;
@synthesize shuffleButton;
@synthesize itunesButton;
@synthesize circularSliderControl;
@synthesize playedIndexArray;
@synthesize songChanged;
@synthesize currentAlbum;
@synthesize currentSongIndex;

+ (MediaPlayerView *)getMediaPlayerView
{
    static dispatch_once_t once;
    static MediaPlayerView *manager;
    dispatch_once(&once, ^{
        manager = [[MediaPlayerView alloc] initWithFrame:CGRectMake(0, 0, MY_SIZE.width, MY_SIZE.height)];
    });
    return manager;
}

- (void)playSong:(Song *)song {
    DDLogError(@"SONG-INDEX:%d", song.songIndex);
    self.currentSongIndex = song.songIndex;
    self.currentAlbum = song.album;
    
    self.playedIndexArray = [NSMutableArray array];
    
    DDLogError(@"IMAGE:%@", currentAlbum.cover);
    [self.albumImageView setImageWithURL:[NSURL URLWithString:currentAlbum.image] placeholderImage:nil];
    
    //Play
    [self playSongWithIndex:currentSongIndex];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self addSubview:self.bottomToolbarView];
        [self addSubview:self.bottomImageView];
        [self addSubview:self.fbButton];
        [self addSubview:self.twButton];
        [self addSubview:self.indicatorView];
        [self.bottomImageView addSubview:self.albumImageView];
        [self.bottomImageView addSubview:self.circularSliderControl];
        [self.bottomImageView addSubview:self.previousButton];
        [self.bottomImageView addSubview:self.playButton];
        [self.bottomImageView addSubview:self.stopButton];
        [self.bottomImageView addSubview:self.nextButton];
        [self.bottomImageView addSubview:self.statusLabel1];
        [self.bottomImageView addSubview:self.statusLabel2];
        [self.bottomImageView addSubview:self.repeatButton];
        [self.bottomImageView addSubview:self.shuffleButton];
        [self.bottomImageView addSubview:self.itunesButton];
        
        [self addObservers];
    }
    return self;
}

- (void)dealloc {
    [self removeObservers];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self initSongWithIndex:0 completed:^(NSError *error) {
        if (error) {
            [self disablePlayer];
        } else {
            [self enablePlayer];
        }
    }];
    
    if ([[MediaPlayerManager getAudioPlayerManager] isPlaying]) {
        
        self.playButton.hidden = YES;
        self.stopButton.hidden = NO;
        
    } else {
       
        self.playButton.hidden = NO;
        self.stopButton.hidden = YES;
    }
}

#pragma mark -
#pragma mark Remote Audio Control
//Make sure we can recieve remote control events
- (BOOL)canBecomeFirstResponder {
    return YES;
}
- (void)remoteControlReceivedWithEvent:(UIEvent *)event {
    //if it is a remote control event handle it correctly
    if (event.type == UIEventTypeRemoteControl) {
        if (event.subtype == UIEventSubtypeRemoteControlPlay) {
            [[MediaPlayerManager getAudioPlayerManager] play];
        } else if (event.subtype == UIEventSubtypeRemoteControlPause) {
            [[MediaPlayerManager getAudioPlayerManager] pause];
        } else if (event.subtype == UIEventSubtypeRemoteControlTogglePlayPause) {
            if ([[MediaPlayerManager getAudioPlayerManager] isPlaying])
                [[MediaPlayerManager getAudioPlayerManager] pause];
            else
                [[MediaPlayerManager getAudioPlayerManager] play];
        } else if (event.subtype == UIEventSubtypeRemoteControlPreviousTrack) {
            [[MediaPlayerManager getAudioPlayerManager] previous];
        } else if (event.subtype == UIEventSubtypeRemoteControlNextTrack) {
            [[MediaPlayerManager getAudioPlayerManager] next:nil];
        }
    }
}
- (void)syncRemote {
    
    if (currentSongIndex >= 0 && currentSongIndex < currentAlbum.songsArray.count) {
        Song *song = [currentAlbum.songsArray objectAtIndex:currentSongIndex];
        
        //Make sure the system follows our playback status
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
        [[AVAudioSession sharedInstance] setActive: YES error: nil];
        
        Class playingInfoCenter = NSClassFromString(@"MPNowPlayingInfoCenter");
        
        if (playingInfoCenter)
        {
            MPMediaItemArtwork *albumArt = [[MPMediaItemArtwork alloc] initWithImage:self.albumImageView.image];
            NSMutableDictionary *songInfo = [[NSMutableDictionary alloc] init];
            [songInfo setObject:song.title forKey:MPMediaItemPropertyTitle];
            [songInfo setObject:currentAlbum.title forKey:MPMediaItemPropertyAlbumTitle];
            [songInfo setObject:currentAlbum.singer forKey:MPMediaItemPropertyArtist];
            [songInfo setObject:albumArt forKey:MPMediaItemPropertyArtwork];
            [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:songInfo];
        }
    }
}

#pragma mark -
#pragma mark AudioPlayer
- (void)disablePlayer {
    self.playButton.enabled
    = self.stopButton.enabled
    = self.previousButton.enabled
    = self.nextButton.enabled
    = self.repeatButton.enabled
    = self.shuffleButton.enabled
    = self.itunesButton.enabled
    = self.circularSliderControl.enabled
    = NO;
}
- (void)enablePlayer {
    self.playButton.enabled
    = self.stopButton.enabled
    = self.previousButton.enabled
    = self.nextButton.enabled
    = self.repeatButton.enabled
    = self.shuffleButton.enabled
    = self.itunesButton.enabled
    = self.circularSliderControl.enabled
    = YES;
    
    [self syncItunesButton];
}
- (void)addObservers {
    [MediaPlayerManager getAudioPlayerManager].UISource = self;
    [MediaPlayerManager getAudioPlayerManager].myDelegate = self;
    
    [self syncShuffle];
    [self syncRepeat];
    
    //Once the view has loaded then we can register to begin recieving controls and we can become the first responder
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
}
- (void)removeObservers {
    [MediaPlayerManager resetAudioPlayerManager];
    
    //End recieving events
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [self resignFirstResponder];
}
- (void)playSongWithIndex:(int)index {
    
    [self initSongWithIndex:index completed:^(NSError *error) {
        if (!error) {
            [self enablePlayer];
            [[MediaPlayerManager getAudioPlayerManager] play];
            
            //Played list
            [self.playedIndexArray addObject:[NSNumber numberWithInt:currentSongIndex]];
        } else {
            [[MediaPlayerManager getAudioPlayerManager] pause];
        }
    }];
}
- (void)initSongWithIndex:(int)index completed:(void (^)(NSError *error))completed {
    if (index >= 0 && index < currentAlbum.songsArray.count) {
        
        currentSongIndex = index;
        
        Song *song = [currentAlbum.songsArray objectAtIndex:currentSongIndex];
        
        DDLogError(@"SONG:%@", song.path);
        [[MediaPlayerManager getAudioPlayerManager] initAudioFromURL:[NSURL URLWithString:song.path] completed:^(NSError *error) {
            
            if (completed) {
                completed(error);
            }
        }];
        
    } else {
        if (completed)
            completed([[NSError alloc] init]);
    }
}

#pragma mark -
#pragma mark AudioPlayerUISource
- (UIActivityIndicatorView *)playerIndicator {
    return self.indicatorView;
}
- (UICircularSlider *)playerSlider {
    return self.circularSliderControl;
}
- (UISlider *)playerVolumeSlider {
    return nil;
}
- (UILabel *)playerStatusLabel1 {
    return self.statusLabel1;
}
- (UILabel *)playerStatusLabel2 {
    return self.statusLabel2;
}
- (MyPlayerLayerView *)playerVideoView {
    return nil;
}
- (UIButton *)playerPlayButton {
    return self.playButton;
}
- (UIButton *)playerStopButton {
    return self.stopButton;
}
- (UIButton *)playerNextButton {
    return self.nextButton;
}
- (UIButton *)playerPrevButton {
    return self.previousButton;
}

#pragma mark -
#pragma mark AudioPlayerManagerDelegate
- (void)volumeEndScrub {

}
- (void)audioWillGoNext:(BOOL)finished {
    
    BOOL shuffle = [USERDEF boolForKey:kAudioPlayerShuffled];
    int repeat = (int)[USERDEF integerForKey:kAudioPlayerRepeated];
    
    if (currentSongIndex + 1 < currentAlbum.songsArray.count) {
        
        //no [one song repeat]
        if ((repeat == 0 || repeat == 1) || !finished) {
            currentSongIndex++;
            
            if (shuffle) {
                
                int k = 0;
                int random = currentSongIndex;
                
                do {
                    random = arc4random() % currentAlbum.songsArray.count;
                    
                    k++;
                    if (k == 10) { //Хамгийн ихдээ 10 удаа давтана
                        break;
                    }
                    
                } while (random == currentSongIndex);
                
                currentSongIndex = random;
            }
        }
        
        [self playSongWithIndex:currentSongIndex];
        
    } else {
        
        //repeat all songs
        if (repeat == 1) {
            currentSongIndex = 0;
            [self playSongWithIndex:currentSongIndex];
        }
    }
}
- (void)audioWillGoPrevious {
    if (currentSongIndex - 1 >= 0 && currentSongIndex < currentAlbum.songsArray.count) {
        currentSongIndex--;
        [self playSongWithIndex:currentSongIndex];
    }
}
- (void)audioPlaying {
    if (self.songChanged) {
        self.songChanged();
    }
    [self startAlbumImageViewRotation];
    
    [self syncRemote];
}
- (void)audioNotPlaying {
    [self stopAlbumImageViewRotation];
}
- (void)startAlbumImageViewRotation {
    [albumImageViewRotationTimer invalidate];
    albumImageViewRotationTimer = [NSTimer scheduledTimerWithTimeInterval:0.01f target:self selector:@selector(realStartAlbumImageViewRotation) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:albumImageViewRotationTimer forMode:NSRunLoopCommonModes];
}
- (void)realStartAlbumImageViewRotation {
    [UIView animateWithDuration:0.1f animations:^{
        currentAlbumImageViewRotation += M_PI_2/1000;
        self.albumImageView.transform = CGAffineTransformMakeRotation(currentAlbumImageViewRotation);
    }];
}
- (void)stopAlbumImageViewRotation {
    [albumImageViewRotationTimer invalidate];
}
- (void) runSpinAnimationOnView:(UIView*)view duration:(CGFloat)duration rotations:(CGFloat)rotations repeat:(int)repeatCount;
{
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * (2.0) /* full rotation*/ * rotations * duration ];
    rotationAnimation.duration = duration;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = repeatCount;
    rotationAnimation.removedOnCompletion = NO;
    
    [view.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

#pragma mark -
#pragma mark User
- (void)syncRepeat {
    
    int repeat = (int)[USERDEF integerForKey:kAudioPlayerRepeated];
    
    if (repeat == 0) {
        [repeatButton setImage:[UIImage imageNamed:@"refresh_button"] forState:UIControlStateNormal];
    } else if (repeat == 1) {
        [repeatButton setImage:[UIImage imageNamed:@"refresh_1_button"] forState:UIControlStateNormal];
    } else if (repeat == 2) {
        [repeatButton setImage:[UIImage imageNamed:@"refresh_2_button"] forState:UIControlStateNormal];
    }
}
- (void)syncShuffle {
    
    BOOL shuffle = [USERDEF boolForKey:kAudioPlayerShuffled];
    
    if (shuffle) {
        [shuffleButton setImage:[UIImage imageNamed:@"shuffle_selection_button"] forState:UIControlStateNormal];
    } else {
        [shuffleButton setImage:[UIImage imageNamed:@"shuffle_button"] forState:UIControlStateNormal];
    }
}
- (void)syncItunesButton {
    if (currentSongIndex >= 0 && currentSongIndex < currentAlbum.songsArray.count) {
        Song *song = [currentAlbum.songsArray objectAtIndex:currentSongIndex];
        if (song.itunes.length > 0) {
            self.itunesButton.enabled = YES;
        } else {
            self.itunesButton.enabled = NO;
        }
    } else {
        self.itunesButton.enabled = NO;
    }
}

#pragma mark -
#pragma mark UIActions
- (void)repeatButtonClicked:(UIButton *)button {
    
    int repeat = (int)[USERDEF integerForKey:kAudioPlayerRepeated];
    
    repeat++;
    if (repeat > 2) {
        repeat = 0;
    }
    
    [USERDEF setInteger:repeat forKey:kAudioPlayerRepeated];
    [USERDEF synchronize];
    
    [self syncRepeat];
}
- (void)shuffleButtonClicked:(UIButton *)button {
    
    BOOL shuffle = [USERDEF boolForKey:kAudioPlayerShuffled];
    
    shuffle = !shuffle;
    
    [USERDEF setBool:shuffle forKey:kAudioPlayerShuffled];
    [USERDEF synchronize];
    
    [self syncShuffle];
}
- (void)itunesButtonClicked:(UIButton *)button {
    Song *song = [currentAlbum.songsArray objectAtIndex:currentSongIndex];
    
    DDLogError(@"ITUNES:%@", song.itunes);
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:song.itunes]])
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:song.itunes]];
}
- (void)fbButtonClicked:(UIButton *)button {
    
    if (currentSongIndex >= 0 && currentSongIndex < currentAlbum.songsArray.count) {
        Song *song = [currentAlbum.songsArray objectAtIndex:currentSongIndex];
        
        if(NSClassFromString(@"SLComposeViewController") != nil)
        {
            if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
            {
                
                [self.indicatorView startAnimating];
                [CONNECTION_MANAGER getImageFromURLString:self.currentAlbum.shareImage success:^(UIImage *shareImage) {
                    [self.indicatorView stopAnimating];
                    
                    [self shareToSocial:SLServiceTypeFacebook image:shareImage albumTitle:self.currentAlbum.title songTitle:song.title itunesUrlString:song.itunes];
                    
                } failure:^(NSString *errorMessage, NSError *error) {
                    [self.indicatorView stopAnimating];
                    
                    [self shareToSocial:SLServiceTypeFacebook image:nil albumTitle:self.currentAlbum.title songTitle:song.title itunesUrlString:song.itunes];
                    
                } sessionExpired:nil];
                
                
            } else {
                UIAlertView *alertView = [[UIAlertView alloc]
                                          initWithTitle:@"Sorry"
                                          message:@"You can't send a post right now, make sure your device has an internet connection and you have at least one Facebook account setup"
                                          delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
                [alertView show];
            }
        }
    }
}
- (void)twButtonClicked:(UIButton *)button {
    if (currentSongIndex >= 0 && currentSongIndex < currentAlbum.songsArray.count) {
        Song *song = [currentAlbum.songsArray objectAtIndex:currentSongIndex];
        
        if(NSClassFromString(@"SLComposeViewController") != nil)
        {
            if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
            {
                [self.indicatorView startAnimating];
                [CONNECTION_MANAGER getImageFromURLString:self.currentAlbum.shareImage success:^(UIImage *shareImage) {
                    [self.indicatorView stopAnimating];
                    
                    [self shareToSocial:SLServiceTypeTwitter image:shareImage albumTitle:self.currentAlbum.title songTitle:song.title itunesUrlString:song.itunes];
                    
                } failure:^(NSString *errorMessage, NSError *error) {
                    [self.indicatorView stopAnimating];
                    
                    [self shareToSocial:SLServiceTypeTwitter image:nil albumTitle:self.currentAlbum.title songTitle:song.title itunesUrlString:song.itunes];
                    
                } sessionExpired:nil];
                
            } else {
                
                UIAlertView *alertView = [[UIAlertView alloc]
                                          initWithTitle:@"Sorry"
                                          message:@"You can't send a tweet right now, make sure your device has an internet connection and you have at least one Twitter account setup"
                                          delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
                [alertView show];
            }
        }
    }
}

- (void)shareToSocial:(NSString *)service
                image:(UIImage *)shareImage
           albumTitle:(NSString *)albumTitle
            songTitle:(NSString *)songTitle
      itunesUrlString:(NSString *)itunesUrlString {
    
    SLComposeViewController *mySLComposerSheet = [[SLComposeViewController alloc] init];
    mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:service];
    
    if ([service isEqualToString:SLServiceTypeTwitter]) {
        [mySLComposerSheet setInitialText:[NSString stringWithFormat:@"Listening... \"Дуучин Болд - %@ - %@\"", albumTitle, songTitle]];
        [mySLComposerSheet addURL:[NSURL URLWithString:itunesUrlString]];
    } else {
        [mySLComposerSheet setInitialText:[NSString stringWithFormat:@"Listening... \"Дуучин Болд - %@ - %@\" %@", albumTitle, songTitle, itunesUrlString]];
    }
        
    if (shareImage)
        [mySLComposerSheet addImage:shareImage];
    
    [mySLComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
        [self.rootViewController dismissViewControllerAnimated:YES completion:nil];
        
        switch (result) {
            case SLComposeViewControllerResultCancelled:
                
                break;
            case SLComposeViewControllerResultDone:
                
                break;
            default:
                break;
        }
    }];
    [self.rootViewController presentViewController:mySLComposerSheet animated:YES completion:nil];
}

#pragma mark -
#pragma mark Getters
- (UIView *)bottomToolbarView {
    if (bottomToolbarView == nil) {
        bottomToolbarView = [[UIView alloc] initWithFrame:CGRectMake(0, MY_SIZE.height-165, MY_SIZE.width, 44)];
        bottomToolbarView.backgroundColor = [BLACK_COLOR colorWithAlphaComponent:0.5f];
    }
    return bottomToolbarView;
}
- (UIButton *)fbButton {
    if (fbButton == nil) {
        fbButton = [UIButton buttonWithType:UIButtonTypeCustom];
        fbButton.frame = CGRectMake(0, MY_SIZE.height-165, 44, 44);
        [fbButton setImage:[UIImage imageNamed:@"fb_button"] forState:UIControlStateNormal];
        [fbButton addTarget:self action:@selector(fbButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return fbButton;
}
- (UIButton *)twButton {
    if (twButton == nil) {
        twButton = [UIButton buttonWithType:UIButtonTypeCustom];
        twButton.frame = CGRectMake(44, MY_SIZE.height-165, 44, 44);
        [twButton setImage:[UIImage imageNamed:@"tw_button"] forState:UIControlStateNormal];
        [twButton addTarget:self action:@selector(twButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return twButton;
}
- (UIActivityIndicatorView *)indicatorView {
    if (indicatorView == nil) {
        indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        indicatorView.frame = CGRectMake(MY_SIZE.width-44, MY_SIZE.height-165, 44, 44);
    }
    return indicatorView;
}
- (UIImageView *)bottomImageView {
    if (bottomImageView == nil) {
        bottomImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MY_SIZE.width, MY_SIZE.height)];
        bottomImageView.backgroundColor = CLEAR_COLOR;
        bottomImageView.userInteractionEnabled = YES;
        [bottomImageView setImage:[UIImage imageNamed:@"play_bg"]];
        
    }
    return bottomImageView;
}
- (UIButton *)previousButton {
    if (previousButton == nil) {
        previousButton = [UIButton buttonWithType:UIButtonTypeCustom];
        previousButton.frame = CGRectMake(20, (bottomImageView.bounds.size.height-44)/2+10, 44, 44);
        [previousButton setImage:[UIImage imageNamed:@"prev_button"] forState:UIControlStateNormal];
        [previousButton setImage:[UIImage imageNamed:@"prev_button_selection"] forState:UIControlStateHighlighted];
        [previousButton setImage:[UIImage imageNamed:@"prev_button_selection"] forState:UIControlStateSelected];
    }
    return previousButton;
}
- (UIButton *)playButton {
    if (playButton == nil) {
        playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        playButton.frame = CGRectMake((bottomImageView.bounds.size.width-55)/2, (bottomImageView.bounds.size.height-55)/2-5, 55, 55);
        [playButton setImage:[UIImage imageNamed:@"play_button"] forState:UIControlStateNormal];
        [playButton setImage:[UIImage imageNamed:@"play_button_selection"] forState:UIControlStateHighlighted];
        [playButton setImage:[UIImage imageNamed:@"play_button_selection"] forState:UIControlStateSelected];
    }
    return playButton;
}
- (UIButton *)stopButton {
    if (stopButton == nil) {
        stopButton = [UIButton buttonWithType:UIButtonTypeCustom];
        stopButton.frame = CGRectMake((bottomImageView.bounds.size.width-55)/2, (bottomImageView.bounds.size.height-55)/2-5, 55, 55);
        [stopButton setImage:[UIImage imageNamed:@"pause_button"] forState:UIControlStateNormal];
        [stopButton setImage:[UIImage imageNamed:@"pause_button_selection"] forState:UIControlStateHighlighted];
        [stopButton setImage:[UIImage imageNamed:@"pause_button_selection"] forState:UIControlStateSelected];
        
        stopButton.hidden = YES;
    }
    return stopButton;
}
- (UILabel *)statusLabel1 {
    if (statusLabel1 == nil) {
        statusLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 60, 70, 20)];
        statusLabel1.font = [UIFont fontWithName:@"Helvetica" size:12.0f];
        statusLabel1.backgroundColor = CLEAR_COLOR;
        statusLabel1.textAlignment = NSTextAlignmentRight;
        statusLabel1.textColor = BLACK_COLOR;
    }
    return statusLabel1;
}
- (UILabel *)statusLabel2 {
    if (statusLabel2 == nil) {
        statusLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(bottomImageView.bounds.size.width-80, 60, 70, 20)];
        statusLabel2.font = [UIFont fontWithName:@"Helvetica" size:12.0f];
        statusLabel2.backgroundColor = CLEAR_COLOR;
        statusLabel2.textAlignment = NSTextAlignmentLeft;
        statusLabel2.textColor = BLACK_COLOR;
    }
    return statusLabel2;
}
- (UIButton *)nextButton {
    if (nextButton == nil) {
        nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        nextButton.frame = CGRectMake(bottomImageView.bounds.size.width-20-44, (bottomImageView.bounds.size.height-44)/2+10, 44, 44);
        [nextButton setImage:[UIImage imageNamed:@"next_button"] forState:UIControlStateNormal];
        [nextButton setImage:[UIImage imageNamed:@"next_button_selection"] forState:UIControlStateHighlighted];
        [nextButton setImage:[UIImage imageNamed:@"next_button_selection"] forState:UIControlStateSelected];
    }
    return nextButton;
}
- (UIButton *)repeatButton {
    if (repeatButton == nil) {
        repeatButton = [UIButton buttonWithType:UIButtonTypeCustom];
        repeatButton.frame = CGRectMake(10, bottomImageView.bounds.size.height-54, 44, 44);
        [repeatButton setImage:[UIImage imageNamed:@"refresh_button"] forState:UIControlStateNormal];
        [repeatButton addTarget:self action:@selector(repeatButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return repeatButton;
}
- (UIButton *)shuffleButton {
    if (shuffleButton == nil) {
        shuffleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        shuffleButton.frame = CGRectMake(54, bottomImageView.bounds.size.height-54, 44, 44);
        [shuffleButton setImage:[UIImage imageNamed:@"shuffle_button"] forState:UIControlStateNormal];
        [shuffleButton addTarget:self action:@selector(shuffleButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return shuffleButton;
}
- (UIButton *)itunesButton {
    if (itunesButton == nil) {
        itunesButton = [UIButton buttonWithType:UIButtonTypeCustom];
        itunesButton.frame = CGRectMake(bottomImageView.bounds.size.width-85, bottomImageView.bounds.size.height-44, 65, 23);
        [itunesButton setImage:[UIImage imageNamed:@"itunes_button"] forState:UIControlStateNormal];
        [itunesButton setImage:[UIImage imageNamed:@"itunes_button_selection"] forState:UIControlStateHighlighted];
        [itunesButton setImage:[UIImage imageNamed:@"itunes_button_selection"] forState:UIControlStateSelected];
        [itunesButton addTarget:self action:@selector(itunesButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return itunesButton;
}
- (UIImageView *)albumImageView {
    if (albumImageView == nil) {
        albumImageView = [[UIImageView alloc] initWithFrame:CGRectMake((bottomImageView.bounds.size.width-150)/2, (bottomImageView.bounds.size.height-150)/2-3, 150, 150)];
        albumImageView.layer.cornerRadius = albumImageView.bounds.size.width/2;
        albumImageView.clipsToBounds = YES;
        albumImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return albumImageView;
}
- (UICircularSlider *)circularSliderControl {
    if (circularSliderControl == nil) {
        circularSliderControl = [[UICircularSlider alloc] initWithFrame:CGRectMake((bottomImageView.bounds.size.width-170)/2, (bottomImageView.bounds.size.height-170)/2-3, 170, 170)];
        circularSliderControl.backgroundColor = CLEAR_COLOR;
        circularSliderControl.continuous = NO;
        circularSliderControl.maximumTrackTintColor = GRAY_COLOR;
        circularSliderControl.minimumTrackTintColor = ORANGE_COLOR;
        circularSliderControl.thumbTintColor = CLEAR_COLOR;
    }
    return circularSliderControl;
}

@end
