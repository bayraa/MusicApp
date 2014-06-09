//
//  MyButton.m
//  iSalonRepo
//
//  Created by Sodtseren Enkhee on 4/24/14.
//  Copyright (c) 2014 Sodtseren Enkhee. All rights reserved.
//

#import "MyButton.h"

@implementation MyButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self setBackgroundColor:[UIColor whiteColor]];
        
        [self setTitleColor:BLACK_COLOR forState:UIControlStateNormal];
        [self.titleLabel setFont:FONT_NORMAL];
        [self.titleLabel setNumberOfLines:2];
        [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
        
        self.layer.borderColor = ORANGE_COLOR.CGColor;
        self.layer.borderWidth = 1.0f;
        self.layer.cornerRadius = 5.0f;
        self.clipsToBounds = YES;
        
        {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.size.width-25, 5, 17, 32)];
            imageView.backgroundColor = CLEAR_COLOR;
            imageView.image = [UIImage imageNamed:@"sum"];
            [self addSubview:imageView];
        }
    }
    return self;
}

@end
