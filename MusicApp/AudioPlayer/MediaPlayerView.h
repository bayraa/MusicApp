//
//  MediaPlayerView.h
//  BoldRepo
//
//  Created by Sodtseren Enkhee on 5/22/14.
//  Copyright (c) 2014 Sodtseren Enkhee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Album.h"
#import "Song.h"

@interface MediaPlayerView : UIView

+ (MediaPlayerView *)getMediaPlayerView;

@property (nonatomic, strong) UIViewController *rootViewController;
@property (nonatomic, copy) void (^songChanged)();

//Current
@property (nonatomic, strong) Album *currentAlbum;
@property (nonatomic, assign) int currentSongIndex;

- (void)playSong:(Song *)song;

@end
