//
//  AlbumsViewController.m
//  BoldRepo
//
//  Created by Sodtseren Enkhee on 5/19/14.
//  Copyright (c) 2014 Sodtseren Enkhee. All rights reserved.
//

#import "AlbumsViewController.h"
#import "AlbumCollectionCell.h"
#import "PlayerViewController.h"
#import "MediaPlayerView.h"
#import "MediaPlayerManager.h"
#import "CheckConnect.h"
@interface AlbumsViewController ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView  *myCollectionView;
@property (nonatomic, strong) NSArray           *albumsArray;
@property (nonatomic, strong) UIButton          *nowPlayingButton;

@end

@implementation AlbumsViewController
@synthesize myCollectionView;
@synthesize albumsArray;
@synthesize nowPlayingButton;

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
    
//    if (![CheckConnect connectedToNetwork]) {
//        NSLog(@"hiii");
//        // [SEUtils showAlert:@"connection failed"];
//        UIAlertView *alert = [[UIAlertView alloc]
//							  initWithTitle:@"Network Error"
//							  message:@"Not connected"
//							  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//		[alert show];
//    }else{
//        NSLog(@"hi");
//    }

    // Do any additional setup after loading the view.
    [self.titleLabel setFont:[UIFont fontWithName:@"AGAvantGardeMon" size:18.0]];
    self.titleLabel.text = NSLocalizedString(@"Цомгууд", nil);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.albumsArray.count == 0) {
        [self.myCollectionView setContentOffset:CGPointMake(0, -self.refreshControl.frame.size.height) animated:YES];
        [self performSelector:@selector(getAlbums) withObject:nil afterDelay:0.5f];
    }
    
    [self syncNowPlayingButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioPlaying) name:kAudioPlayingObserver object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioStopping) name:kAudioStopingObserver object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)audioPlaying {
    [self syncNowPlayingButton];
}
- (void)audioStopping {
    [self syncNowPlayingButton];
}

- (void)configureView {
    [super configureView];
    [self.view addSubview:self.myCollectionView];
    [self.myCollectionView addSubview:self.refreshControl];
    [self.headerView addSubview:self.nowPlayingButton];
}

#pragma mark -
#pragma mark Connection
- (void)getAlbums {
    [self.refreshControl beginRefreshing];
    [CONNECTION_MANAGER getAlbumsSuccess:^(NSArray *resultArray) {
        [self.refreshControl endRefreshing];
        
        self.albumsArray = resultArray;
        [self.myCollectionView reloadData];
        
    } failure:^(NSString *errorMessage, NSError *error) {
        [self.refreshControl endRefreshing];
        if (error) {
            [SEUtils showAlert:NO_CONNECTION_ALERT];
        }else if(errorMessage){
            [SEUtils showAlert:errorMessage];
        }
    } sessionExpired:nil];
}

#pragma mark -
#pragma mark User
- (void)syncNowPlayingButton {
    if ([[MediaPlayerManager getAudioPlayerManager] isPlaying]) {
        self.nowPlayingButton.hidden = NO;
    } else {
        self.nowPlayingButton.hidden = YES;
    }
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
#pragma mark UIActions
-(void)handleRefresh:(UIRefreshControl *)refresh {
    [self getAlbums];
}
- (void)nowPlayingButtonClicked:(UIButton *)button {
    PlayerViewController *controller = [[PlayerViewController alloc] initWithNibName:nil bundle:nil];
    controller.album = [MediaPlayerView getMediaPlayerView].currentAlbum;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.albumsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AlbumCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AlbumCollectionCell" forIndexPath:indexPath];
    
    [self configureCell:cell forItemAtIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(AlbumCollectionCell *)cell
   forItemAtIndexPath:(NSIndexPath *)indexPath
{
    cell.album = [self.albumsArray objectAtIndex:indexPath.row];
    
    DDLogError(@"IMAGE:%@", cell.album.image);
    [cell.albumImageView.imageView setImageWithURL:[NSURL URLWithString:cell.album.image]
                                   placeholderImage:[[UIImage imageNamed:@"no_pic.jpg"] imageByNoScalingForSize:CGSizeMake(130, 130)]];
    
    [cell layoutSubviews];
}

#pragma mark -
#pragma mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    PlayerViewController *controller = [[PlayerViewController alloc] initWithNibName:nil bundle:nil];
    controller.album = [self.albumsArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark -
#pragma mark Getters
- (UICollectionView *)myCollectionView {
    
    if (myCollectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        
        myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.headerView.bounds.size.height, MY_BOUNDS.width, MY_BOUNDS.height-self.headerView.bounds.size.height) collectionViewLayout:layout];
        myCollectionView.backgroundColor =  CLEAR_COLOR;
        myCollectionView.dataSource = self;
        myCollectionView.delegate = self;
        myCollectionView.alwaysBounceVertical = YES;
        
        layout.itemSize = CGSizeMake(150, 180);
        layout.minimumInteritemSpacing = 10;
        layout.minimumLineSpacing = 10;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.sectionInset = UIEdgeInsetsMake(10, 0, 0, 0);
        
        [myCollectionView registerClass:[AlbumCollectionCell class] forCellWithReuseIdentifier:@"AlbumCollectionCell"];
    }
    return myCollectionView;
}
- (UIButton *)nowPlayingButton {
    if (nowPlayingButton == nil) {
        
        int y = 0;
        if ([SEUtils OSVersion] >= 7)
            y += 20;
        
        nowPlayingButton = [[UIButton alloc] initWithFrame:CGRectMake(MY_BOUNDS.width-44, y, 44, 44)];
        nowPlayingButton.backgroundColor = CLEAR_COLOR;
        [nowPlayingButton setImage:[UIImage imageNamed:@"button_back1"] forState:UIControlStateNormal];
        [nowPlayingButton addTarget:self action:@selector(nowPlayingButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return nowPlayingButton;
}

@end
