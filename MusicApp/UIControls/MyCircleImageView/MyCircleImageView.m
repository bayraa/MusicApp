//
//  MyCircleImageView.m
//  iRestaurantRepo
//
//  Created by Sodtseren Enkhee on 2/11/14.
//  Copyright (c) 2014 Sodtseren Enkhee. All rights reserved.
//

#import "MyCircleImageView.h"

@implementation MyCircleImageView
@synthesize imageView;
@synthesize oneTapped;
@synthesize longPressed;
@synthesize isSmallBorder;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.userInteractionEnabled = YES;
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5f];
        self.clipsToBounds = YES;
        
        [self addSubview:self.imageView];
        
        //One Tap
        {
            UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
            [self addGestureRecognizer:tapGesture];
        }
        //Long Press
        {
            UILongPressGestureRecognizer* longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
            [self addGestureRecognizer:longPressGesture];
        }
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (!isSmallBorder)
        [self setMyFrame:self.frame];
    else
        [self setMyFrameSmallBorder:self.frame];
}

- (void)setMyFrame:(CGRect)frame {
    self.frame = frame;
    self.layer.cornerRadius = self.bounds.size.width / 2;
    self.imageView.frame = CGRectMake(10, 10, self.frame.size.width-20, self.frame.size.height-20);
    
    self.imageView.layer.cornerRadius = (self.bounds.size.width-20)/2;
}

- (void)setMyFrameSmallBorder:(CGRect)frame {
    self.frame = frame;
    self.layer.cornerRadius = self.bounds.size.width / 2;
    self.imageView.frame = CGRectMake(3, 3, self.frame.size.width-6, self.frame.size.height-6);
    
    self.imageView.layer.cornerRadius = (self.bounds.size.width-6)/2;
}

#pragma mark -
#pragma mark UIActions
- (void)handleTap:(UITapGestureRecognizer *)tapGesture {
    if (self.oneTapped)
        self.oneTapped();
}
- (void)handleLongPress:(UILongPressGestureRecognizer *)gesture {
    if(gesture.state == UIGestureRecognizerStateBegan) {
        if (self.longPressed)
            self.longPressed();
    }
}

#pragma mark -
#pragma mark Getters
- (UIImageView *)imageView {
    if (imageView == nil) {
        imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        imageView.userInteractionEnabled = YES;
        imageView.clipsToBounds = YES;
        imageView.autoresizesSubviews = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.backgroundColor = LIGHT_YELLOW_COLOR;
    }
    return imageView;
}

@end
