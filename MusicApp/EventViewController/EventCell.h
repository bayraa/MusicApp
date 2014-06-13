//
//  EventCell.h
//  MusicApp
//
//  Created by Bayraa on 6/10/14.
//  Copyright (c) 2014 Kaizen Mongolia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventCell : UITableViewCell

@property (nonatomic , strong) UIImageView *imgView;
@property (nonatomic , strong) UIView *blackview;
@property (nonatomic , strong) UIButton *likeBtn;
@property (nonatomic , strong) UILabel *titlelabel;
@property (nonatomic , strong) UILabel *dateLabel;
@end
