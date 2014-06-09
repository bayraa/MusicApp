//
//  NSDateFormatter+SEUtils.h
//  SEDefaults
//
//  Created by Sodtseren Enkhee on 1/18/14.
//  Copyright (c) 2014 SE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDateFormatter (SEUtils)

+ (NSDateFormatter *)YYYY_MM_DD;
+ (NSDateFormatter *)YYYY_MM_DD_HH_MM;
+ (NSDateFormatter *)YYYY_MM_DD_HH_MM_SS;

@end
