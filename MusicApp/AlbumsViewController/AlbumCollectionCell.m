//
//  AlbumCollectionCell.m
//  BoldRepo
//
//  Created by Sodtseren Enkhee on 5/19/14.
//  Copyright (c) 2014 Sodtseren Enkhee. All rights reserved.
//

#import "AlbumCollectionCell.h"

#define MY_SIZE     CGSizeMake(150, 180)

@implementation AlbumCollectionCell
@synthesize album;
@synthesize albumImageView;
@synthesize nameLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.contentView.backgroundColor = CLEAR_COLOR;
        
        [self addSubview:self.albumImageView];
        [self addSubview:self.nameLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.album.title.length > 0)
        self.nameLabel.text = self.album.title;
    else
        self.nameLabel.text = @"...";
}

#pragma mark -
#pragma mark Getters
- (MyCircleImageView *)albumImageView {
    if (albumImageView == nil) {
        albumImageView = [[MyCircleImageView alloc] initWithFrame:CGRectMake(10, 0, MY_SIZE.width-20, MY_SIZE.width-20)];
        albumImageView.userInteractionEnabled = NO;
        albumImageView.backgroundColor = [UIColor grayColor];
        albumImageView.isSmallBorder = YES;
    }
    return albumImageView;
}
- (UILabel *)nameLabel {
    if (nameLabel == nil) {
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, MY_SIZE.height-50, MY_SIZE.width-20, 50)];
        nameLabel.backgroundColor = CLEAR_COLOR;
        nameLabel.textColor = BLACK_COLOR;
        [nameLabel setFont:[UIFont fontWithName:@"AGAvantGardeMon" size:17.0f]];
      //  nameLabel.font = [UIFont fontWithName:@"AGAvantGardeMon" size:17.0f] ;
      //  nameLabel.font = FONT_SMALL;
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.numberOfLines = 0;
    }
    return nameLabel;
}

@end
