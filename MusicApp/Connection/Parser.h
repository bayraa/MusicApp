//
//  Parser.h
//  iRestaurantRepo
//
//  Created by Sodtseren Enkhee on 2/25/14.
//  Copyright (c) 2014 Sodtseren Enkhee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Parser : NSObject

+ (Parser *)getParser;

- (NSString *)getStringValue:(NSDictionary *)dictionary Key:(NSString *)key;

#pragma mark -
#pragma mark Albums
- (NSArray *)parseAlbums:(NSArray *)dicArray;

- (NSArray *)parseVideo:(NSArray *)dicArray;


@end
