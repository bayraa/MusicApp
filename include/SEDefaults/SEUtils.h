//
//  SEUtils.h
//  SEDefaults
//
//  Created by Developer on 10/17/13.
//  Copyright (c) 2013 SE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SEUtils : NSObject

+ (NSInteger)OSVersion;

+ (void)showAlert:(NSString *)message delegate:(id<UIAlertViewDelegate>)delegate;
+ (void)showAlert:(NSString *)message;

+ (CGSize)getBounds;

+ (NSString *)getJsonFromObject:(NSObject *)object;
+ (NSObject *)getObjectFromJson:(NSString *)jsonString;
+ (NSObject *)getObjectFromJsonData:(NSData *)jsonData;

@end
