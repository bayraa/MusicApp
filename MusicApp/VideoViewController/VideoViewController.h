//
//  VideoViewController.h
//  MusicApp
//
//  Created by Bayraa on 6/9/14.
//  Copyright (c) 2014 Kaizen Mongolia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Video.h"
#import "MainAbstractViewController.h"

@interface VideoViewController : MainAbstractViewController<UITableViewDataSource , UITableViewDelegate>

@property (nonatomic , strong) UITableView *videoTableView;

@property (nonatomic ,strong) Video *video;
@property (nonatomic , strong) UIView *videoView;
@property (nonatomic , strong) UILabel *titlelabel;
@property (nonatomic , strong) UILabel *ViewsLabel;
@property (nonatomic , strong) UILabel *LikesLabel;
@property (nonatomic , strong) UILabel *publishLabel;
@property (nonatomic , strong) UIWebView *webview;
@property (nonatomic ,strong) UIImageView *videoBG;

@property (nonatomic , strong) UIButton *backbtn;
@property (nonatomic , strong) UILabel *headerLabel;
@property (nonatomic , strong) UIImageView *headerimg;

@end
