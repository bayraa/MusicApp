//
//  VideoCell.h
//  MusicApp
//
//  Created by Bayraa on 6/9/14.
//  Copyright (c) 2014 Kaizen Mongolia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Video.h"
@interface VideoCell : UITableViewCell
@property (nonatomic , strong) UIImageView *coverIMG;
@property (nonatomic , strong) UILabel *videoTitleLabel;
@property (nonatomic , strong) Video *video;
@property (nonatomic ,strong) UIView *blackview;
@end
