//
//  MyCircleImageView.h
//  iRestaurantRepo
//
//  Created by Sodtseren Enkhee on 2/11/14.
//  Copyright (c) 2014 Sodtseren Enkhee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCircleImageView : UIImageView

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, copy) void (^oneTapped)();
@property (nonatomic, copy) void (^longPressed)();

@property (nonatomic, assign) BOOL isSmallBorder;

@end
