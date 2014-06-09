//
//  UIImage+SEUtils.h
//  SEDefaults
//
//  Created by Developer on 11/21/13.
//  Copyright (c) 2013 SE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (SEUtils)

- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize;
- (UIImage*)imageByNoScalingForSize:(CGSize)targetSize;

@end
