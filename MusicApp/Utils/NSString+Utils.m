//
//  NSString+Utils.m
//  iSalonRepo
//
//  Created by Sodtseren Enkhee on 4/23/14.
//  Copyright (c) 2014 Sodtseren Enkhee. All rights reserved.
//

#import "NSString+Utils.h"

@implementation NSString (Utils)

- (NSString *)orEmptyString {
    if (self.length > 0) {
        return self;
    }
    return @"-";
}

@end
