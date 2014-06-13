//
//  EventViewController.h
//  MusicApp
//
//  Created by Bayraa on 6/10/14.
//  Copyright (c) 2014 Kaizen Mongolia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainAbstractViewController.h"
@interface EventViewController : MainAbstractViewController<UITableViewDataSource , UITableViewDelegate>

@property (nonatomic , strong) UITableView *eventTableview;
@property (nonatomic , strong) UIView *subView;
@property (nonatomic , strong) UIImageView *eventImg;
@property (nonatomic , strong) UIView *blackview;
@property (nonatomic , strong) UILabel *eventTitlelabel;
@property (nonatomic , strong) UILabel *eventdatelabel;
@property (nonatomic , strong) UITextView *textView;

@property (nonatomic , strong) UIImageView *headerImgview;
@property (nonatomic , strong) UILabel *headerTitleLabel;
@property (nonatomic , strong) UIButton *backBtn;

@end
