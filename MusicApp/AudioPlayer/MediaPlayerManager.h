//
//  AudioPlayerManager.h
//  HunnuAir
//
//  Created by Sodtseren Enkhee on 2/6/14.
//  Copyright (c) 2014 Egi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyPlayerLayerView.h"
#import <UICircularSlider/UICircularSlider.h>
#import <AVFoundation/AVFoundation.h>

#define kAudioPlayerVolume      @"kAudioPlayerVolume"
#define kAudioPlayerShuffled    @"kAudioPlayerShuffled"
#define kAudioPlayerRepeated    @"kAudioPlayerRepeated"

#define kAudioPlayingObserver   @"kAudioPlayingObserver"
#define kAudioStopingObserver   @"kAudioStopingObserver"

@class MediaPlayerManager;

@protocol AudioPlayerUISource <NSObject>

- (UIActivityIndicatorView *)playerIndicator;
- (UICircularSlider *)playerSlider;
- (UISlider *)playerVolumeSlider;
- (UILabel *)playerStatusLabel1;
- (UILabel *)playerStatusLabel2;
- (MyPlayerLayerView *)playerVideoView;
- (UIButton *)playerPlayButton;
- (UIButton *)playerStopButton;
- (UIButton *)playerNextButton;
- (UIButton *)playerPrevButton;

@end

@protocol AudioPlayerManagerDataSource <NSObject>
@end

@protocol AudioPlayerManagerDelegate <NSObject>

- (void)audioWillGoNext:(BOOL)finish;
- (void)audioWillGoPrevious;
- (void)audioPlaying;
- (void)audioNotPlaying;
- (void)volumeEndScrub;

@end

@interface MediaPlayerManager : NSObject

@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerItem *playerItem;

+ (MediaPlayerManager *)getAudioPlayerManager;
+ (void)resetAudioPlayerManager;

@property (nonatomic, strong) NSObject<AudioPlayerUISource> *UISource;
@property (nonatomic, strong) NSObject<AudioPlayerManagerDelegate> *myDelegate;

- (void)initAudioFromURL:(NSURL *)mediaUrl completed:(void (^)(NSError *error))completed;

- (void)play;
- (BOOL)isPlaying;
- (void)pause;
- (void)next:(id)sender;
- (void)previous;

- (void)destroyStream;

@end
