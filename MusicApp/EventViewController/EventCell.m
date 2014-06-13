//
//  EventCell.m
//  MusicApp
//
//  Created by Bayraa on 6/10/14.
//  Copyright (c) 2014 Kaizen Mongolia. All rights reserved.
//

#import "EventCell.h"

@implementation EventCell
@synthesize titlelabel;
@synthesize dateLabel;
@synthesize imgView;
@synthesize likeBtn;
@synthesize blackview;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        [self.contentView addSubview:self.imgView];
        [self.contentView addSubview:self.blackview];
        [self.contentView addSubview:self.titlelabel];
        [self.contentView addSubview:self.dateLabel];
        [self.contentView addSubview:self.likeBtn];
        
    }
    
    
    return self;
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

-(UIView *)blackview {
    if(blackview == nil){
        blackview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MY_BOUNDS.width, 50)];
        blackview.backgroundColor = [UIColor blackColor];
        blackview.alpha = 0.6f;
    }
    return blackview;
}


-(UILabel *)titlelabel{
    if(titlelabel == nil){
        titlelabel = [[UILabel alloc] initWithFrame: CGRectMake(0, 4, 300, 29)];
        titlelabel.backgroundColor = CLEAR_COLOR;
        titlelabel.textColor = [UIColor whiteColor];
        [titlelabel setFont:[UIFont fontWithName:@"AGAvantGardeMon" size:14]];
        titlelabel.numberOfLines = 2;
        titlelabel.adjustsFontSizeToFitWidth = YES;
    }
    return titlelabel;
}

-(UILabel *)dateLabel{
    if(dateLabel == nil){
        dateLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, 29, 320, 21)];
        dateLabel.backgroundColor = CLEAR_COLOR;
        dateLabel.textColor = [UIColor grayColor];
        [dateLabel setFont:[UIFont fontWithName:@"AGAvantGardeMon" size:14]];
    }
    return dateLabel;
}

-(UIImageView *)imgView {
    if(imgView == nil) {
        imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 174)];
    }
    return imgView;
}

-(UIButton *)likeBtn {
    if(likeBtn == nil){
        likeBtn = [[UIButton alloc]initWithFrame:CGRectMake(272, 3, 44, 44)];
        [likeBtn setImage:[UIImage imageNamed:@"favorite_button.png"] forState:UIControlStateNormal];
    }
    return likeBtn;
}


@end
