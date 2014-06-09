//
//  Album.h
//  BoldRepo
//
//  Created by Sodtseren Enkhee on 5/19/14.
//  Copyright (c) 2014 Sodtseren Enkhee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Album : NSObject

@property (nonatomic, strong) NSString          *itemid;
@property (nonatomic, strong) NSString          *title;
@property (nonatomic, strong) NSString          *description_;
@property (nonatomic, strong) NSString          *image;
@property (nonatomic, strong) NSString          *cover;
@property (nonatomic, strong) NSString          *executive_producer;
@property (nonatomic, strong) NSString          *album_producer;
@property (nonatomic, strong) NSString          *singer;
@property (nonatomic, strong) NSString          *created_at;
@property (nonatomic, strong) NSArray           *songsArray;
@property (nonatomic, strong) NSString          *shareImage;

@end
