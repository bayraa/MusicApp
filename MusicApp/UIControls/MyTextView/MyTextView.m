//
//  MyTextView.m
//  iRestaurantRepo
//
//  Created by Sodtseren Enkhee on 4/12/14.
//  Copyright (c) 2014 Sodtseren Enkhee. All rights reserved.
//

#import "MyTextView.h"

@implementation MyTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //UITextField - BG
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderColor = ORANGE_COLOR.CGColor;
        self.layer.borderWidth = 1.0f;
        self.layer.cornerRadius = 5.0f;
        
        self.font = FONT_NORMAL;
        self.textColor = BLACK_COLOR;
        self.keyboardType = UIKeyboardTypeDefault;
        self.autocorrectionType = UITextAutocorrectionTypeNo;
        self.autocapitalizationType = UITextAutocapitalizationTypeNone;
        self.showsVerticalScrollIndicator = NO;
        self.alwaysBounceVertical = YES;
        
        self.contentInset = UIEdgeInsetsMake(5, 5, 5, 5);
    }
    return self;
}

@end
