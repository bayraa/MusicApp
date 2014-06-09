//
//  TimeoutAFHTTPRequestSerializer.h
//  iRestaurantRepo
//
//  Created by Sodtseren Enkhee on 4/8/14.
//  Copyright (c) 2014 Sodtseren Enkhee. All rights reserved.
//

#import "AFURLRequestSerialization.h"

@interface TimeoutAFHTTPRequestSerializer : AFHTTPRequestSerializer

@property (nonatomic, assign) NSTimeInterval timeout;

- (id)initWithTimeout:(NSTimeInterval)timeout;

@end
