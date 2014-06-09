//
//  MyUtils.h
//  iRestaurantRepo
//
//  Created by Sodtseren Enkhee on 2/11/14.
//  Copyright (c) 2014 Sodtseren Enkhee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyUtils : NSObject

+ (UIImage *)getCircleImage: (UIImage *)originalImage frame: (CGRect)rect;

//NSDateFormatter
+ (NSDateFormatter *)YYYY_MM_DD;
+ (NSDateFormatter *)YYYY_MM_DD_HH_MM;
+ (NSDateFormatter *)YYYY_MM_DD_HH_MM_SS;

+ (UIImage *)forceRotate:(UIImage *)image Orientation:(UIImageOrientation)orient;

+ (void)playNotificationSound;

//+ (void)showToastView:(NSString *)text;

@end
