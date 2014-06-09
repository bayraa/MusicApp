//
//  MyUtils.m
//  iRestaurantRepo
//
//  Created by Sodtseren Enkhee on 2/11/14.
//  Copyright (c) 2014 Sodtseren Enkhee. All rights reserved.
//

#import "MyUtils.h"
#import <AudioToolbox/AudioToolbox.h>

@implementation MyUtils

+ (UIImage *)getCircleImage: (UIImage *)originalImage frame: (CGRect)rect {
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 1.0);
    
    [[UIBezierPath bezierPathWithRoundedRect:rect
                                cornerRadius:rect.size.width/2] addClip];
    [originalImage drawInRect:rect];
    
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resultImage;
}

//NSDateFormatter
+ (NSDateFormatter *)YYYY_MM_DD {
    static dispatch_once_t once;
    static NSDateFormatter *dateFormatter;
    dispatch_once(&once, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
    });
    return dateFormatter;
}
+ (NSDateFormatter *)YYYY_MM_DD_HH_MM {
    static dispatch_once_t once;
    static NSDateFormatter *dateFormatter;
    dispatch_once(&once, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
    });
    return dateFormatter;
}
+ (NSDateFormatter *)YYYY_MM_DD_HH_MM_SS {
    static dispatch_once_t once;
    static NSDateFormatter *dateFormatter;
    dispatch_once(&once, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    });
    return dateFormatter;
}

static inline double radians (double degrees) {return degrees * M_PI/180;}
+ (UIImage *)forceRotate:(UIImage *)image Orientation:(UIImageOrientation)orient {
    
    UIGraphicsBeginImageContext(image.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orient == UIImageOrientationRight) {
        CGContextRotateCTM (context, radians(90));
    } else if (orient == UIImageOrientationLeft) {
        CGContextRotateCTM (context, radians(-90));
    } else if (orient == UIImageOrientationDown) {
        // NOTHING
    } else if (orient == UIImageOrientationUp) {
        CGContextRotateCTM (context, radians(90));
    }
    
    [image drawAtPoint:CGPointMake(0, 0)];
    
    return UIGraphicsGetImageFromCurrentImageContext();
}

+ (void)playNotificationSound {
    SystemSoundID soundID;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"desk_bell" ofType:@"caf"];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &soundID);
    AudioServicesPlaySystemSound (soundID);
}

+ (void)showToastView:(NSString *)text {
//    [CRToastManager dismissNotification:YES];
//    
//    static BOOL completed = YES;
//    if (completed == NO)
//        return;
//    
//    completed = NO;
//    [CRToastManager showNotificationWithOptions:[[self class] options:text]
//                                completionBlock:^(void) {
//                                    completed = YES;
//                                }];
}

//+ (NSDictionary*)options:(NSString *)text {
//    NSMutableDictionary *options = [@{kCRToastNotificationTypeKey               : @(CRToastTypeStatusBar),
//                                      kCRToastNotificationPresentationTypeKey   : @(CRToastPresentationTypePush),
//                                      kCRToastUnderStatusBarKey                 : @(NO),
//                                      kCRToastTextKey                           : text,
//                                      kCRToastTextAlignmentKey                  : @(NSTextAlignmentCenter),
//                                      kCRToastTimeIntervalKey                   : @(2.0f),
//                                      kCRToastAnimationInTypeKey                : @(CRToastAnimationTypeLinear),
//                                      kCRToastAnimationOutTypeKey               : @(CRToastAnimationTypeLinear),
//                                      kCRToastAnimationInDirectionKey           : @(0),
//                                      kCRToastAnimationOutDirectionKey          : @(0),
//                                      kCRToastBackgroundColorKey                : ORANGE_COLOR} mutableCopy];
//    
//    return [NSDictionary dictionaryWithDictionary:options];
//}

@end
