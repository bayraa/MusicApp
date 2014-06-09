//
//  MyLabel.m
//  iRestaurantRepo
//
//  Created by Sodtseren Enkhee on 4/11/14.
//  Copyright (c) 2014 Sodtseren Enkhee. All rights reserved.
//

#import "MyLabel.h"

@implementation MyLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = CLEAR_COLOR;
        self.textColor = BLACK_COLOR;
        self.font = FONT_NORMAL;
    }
    return self;
}

@end
