//
//  VideoCell.m
//  MusicApp
//
//  Created by Bayraa on 6/9/14.
//  Copyright (c) 2014 Kaizen Mongolia. All rights reserved.
//

#import "VideoCell.h"

@implementation VideoCell

@synthesize videoTitleLabel;
@synthesize coverIMG;
@synthesize video;
@synthesize blackview;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.clipsToBounds = YES;
        
        [self.contentView addSubview:self.coverIMG];
        [self.contentView addSubview:self.blackview];
        [self.contentView addSubview:self.videoTitleLabel];
        
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // self.numberLabel.text = [NSString stringWithFormat:@"%d.", self.song.indexPath.row+1];
    self.videoTitleLabel.text = self.video.title;
}

-(UILabel *)videoTitleLabel{
    if(videoTitleLabel == nil) {
        videoTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(9 , 150, 302, 21)];
        videoTitleLabel.backgroundColor = CLEAR_COLOR;
        videoTitleLabel . textColor = [UIColor whiteColor];
        [videoTitleLabel setFont:[UIFont fontWithName:@"AGAvantGardeMon" size:15]];
        videoTitleLabel.numberOfLines = 2;
    }
    return videoTitleLabel;
}

-(UIImageView *)coverIMG{
    if(coverIMG == nil){
        coverIMG = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 182)];
        coverIMG.backgroundColor = CLEAR_COLOR;
        coverIMG.contentMode = UIViewContentModeScaleAspectFill;
    }
    return coverIMG;
}

-(UIView *)blackview {
    if(blackview == nil){
        blackview = [[UIView alloc] initWithFrame:CGRectMake(0, 141, 320, 40)];
        blackview.backgroundColor = [UIColor blackColor];
        blackview.alpha = 0.6f;
    }
    return blackview;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
