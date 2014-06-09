//
//  AlbumCollectionCell.h
//  BoldRepo
//
//  Created by Sodtseren Enkhee on 5/19/14.
//  Copyright (c) 2014 Sodtseren Enkhee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Album.h"
#import "MyCircleImageView.h"

@interface AlbumCollectionCell : UICollectionViewCell

@property (nonatomic, strong) Album *album;

@property (nonatomic, strong) MyCircleImageView *albumImageView;
@property (nonatomic, strong) UILabel *nameLabel;

@end
