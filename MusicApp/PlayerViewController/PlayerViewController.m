//
//  PlayerViewController.m
//  BoldRepo
//
//  Created by Sodtseren Enkhee on 5/19/14.
//  Copyright (c) 2014 Sodtseren Enkhee. All rights reserved.
//

#import "PlayerViewController.h"
#import "PlayerCell.h"
#import "MediaPlayerManager.h"
#import "MediaPlayerView.h"
#import <FXBlurView/FXBlurView.h>

@interface PlayerViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIImageView   *bgImageView;
@property (nonatomic, strong) FXBlurView    *blurView;
@property (nonatomic, strong) UITableView   *myTableView;

@end

@implementation PlayerViewController
@synthesize album;
@synthesize bgImageView;
@synthesize blurView;
@synthesize myTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.titleLabel setFont:[UIFont fontWithName:@"AGAvantGardeMon" size:18.0]];
    self.titleLabel.text = self.album.title;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)configureView {
    [super configureView];
    
    [self.view addSubview:self.bgImageView];
    [self.view addSubview:self.blurView];
    [self.view bringSubviewToFront:self.headerView];
    [self.view addSubview:self.myTableView];
    {
        [MediaPlayerView getMediaPlayerView].rootViewController = self;
        [MediaPlayerView getMediaPlayerView].songChanged = ^ {
            
            if ([[MediaPlayerManager getAudioPlayerManager] isPlaying]
                && [self.album.itemid isEqualToString:[MediaPlayerView getMediaPlayerView].currentAlbum.itemid]) {
                
                [self.myTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:[MediaPlayerView getMediaPlayerView].currentSongIndex inSection:0] animated:YES
                                        scrollPosition:UITableViewScrollPositionMiddle];
            }
        };
        
        [MediaPlayerView getMediaPlayerView].songChanged();
        
        [MediaPlayerView getMediaPlayerView].frame
        = CGRectMake(0,
                     MY_BOUNDS.height-[MediaPlayerView getMediaPlayerView].frame.size.height,
                     [MediaPlayerView getMediaPlayerView].frame.size.width,
                     [MediaPlayerView getMediaPlayerView].frame.size.height
                     );
        
        [self.view addSubview:[MediaPlayerView getMediaPlayerView]];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.album.songsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PlayerCell";
    PlayerCell *cell = (PlayerCell *)[self.myTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[PlayerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.song = [self.album.songsArray objectAtIndex:indexPath.row];
    cell.song.indexPath = indexPath;
    
    [cell layoutSubviews];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    cell.backgroundColor = CLEAR_COLOR;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //Play
    [[MediaPlayerView getMediaPlayerView] playSong:[self.album.songsArray objectAtIndex:indexPath.row]];
}

#pragma mark -
#pragma mark Remote Audio Control
//Make sure we can recieve remote control events
- (BOOL)canBecomeFirstResponder {
    return YES;
}
- (void)remoteControlReceivedWithEvent:(UIEvent *)event {
    [[MediaPlayerView getMediaPlayerView] remoteControlReceivedWithEvent:event];
}

#pragma mark -
#pragma mark Getters
- (UIImageView *)bgImageView {
    if (bgImageView == nil) {
        
        int y = 44;
        if ([SEUtils OSVersion] >= 7)
            y += 20;
        
        bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, y, MY_BOUNDS.width, MY_BOUNDS.height)];
        bgImageView.backgroundColor = CLEAR_COLOR;
        bgImageView.image = [UIImage imageNamed:@"8.jpg"];
    }
    return bgImageView;
}
- (FXBlurView *)blurView {
    if (blurView == nil) {
        blurView = [[FXBlurView alloc] initWithFrame:bgImageView.frame];
        blurView.blurRadius = 30.0f;
        blurView.tintColor = BLACK_COLOR;
        blurView.iterations = 10.0f;
        blurView.dynamic = NO;
    }
    return blurView;
}
- (UITableView *)myTableView {
    if (myTableView == nil) {
        
        int y = 44;
        if ([SEUtils OSVersion] >= 7)
            y += 20;
        
        myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, y, MY_BOUNDS.width, MY_BOUNDS.height-y-125) style:UITableViewStylePlain];
        myTableView.backgroundColor = CLEAR_COLOR;
        myTableView.delegate = self;
        myTableView.dataSource = self;
        myTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        myTableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
    }
    return myTableView;
}

@end
