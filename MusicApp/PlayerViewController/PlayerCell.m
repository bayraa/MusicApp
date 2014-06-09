//
//  PlayerCell.m
//  BoldRepo
//
//  Created by Sodtseren Enkhee on 5/19/14.
//  Copyright (c) 2014 Sodtseren Enkhee. All rights reserved.
//

#import "PlayerCell.h"

@interface PlayerCell()

@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation PlayerCell
@synthesize song;
@synthesize numberLabel;
@synthesize titleLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        {
            UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
            view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5f];
            [self setSelectedBackgroundView:view];
        }
        
        [self.contentView addSubview:self.numberLabel];
        [self.contentView addSubview:self.titleLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.numberLabel.text = [NSString stringWithFormat:@"%d.", self.song.indexPath.row+1];
    self.titleLabel.text = self.song.title;
}

#pragma mark -
#pragma mark Getters
- (UILabel *)numberLabel {
    if (numberLabel == nil) {
        numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 30, 34)];
        numberLabel.backgroundColor = CLEAR_COLOR;
        numberLabel.textColor = [UIColor whiteColor];
        numberLabel.highlightedTextColor = BLACK_COLOR;
        //numberLabel.font = FONT_NORMAL;
        numberLabel.font = [UIFont fontWithName:@"AGAvantGardeMon" size:16.0];
    }
    return numberLabel;
}
- (UILabel *)titleLabel {
    if (titleLabel == nil) {
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 260, 44)];
        titleLabel.backgroundColor = CLEAR_COLOR;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.highlightedTextColor = BLACK_COLOR;
        titleLabel.font = [UIFont fontWithName:@"AGAvantGardeMon" size:16.0];
       // titleLabel.font = FONT_NORMAL;
        titleLabel.numberOfLines = 2;
    }
    return titleLabel;
}

@end
