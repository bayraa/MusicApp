//
//  Song.h
//  BoldRepo
//
//  Created by Sodtseren Enkhee on 5/19/14.
//  Copyright (c) 2014 Sodtseren Enkhee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Album.h"

@interface Song : NSObject

@property (nonatomic, strong) NSString          *itemid;
@property (nonatomic, strong) NSString          *album_id;
@property (nonatomic, strong) NSString          *title;
@property (nonatomic, strong) NSString          *itunes;
@property (nonatomic, strong) NSString          *amazon;
@property (nonatomic, strong) NSString          *google;
@property (nonatomic, strong) NSString          *created_at;
@property (nonatomic, strong) NSString          *path;

//Temp
@property (nonatomic, strong) NSIndexPath       *indexPath;
@property (nonatomic, strong) Album             *album;
@property (nonatomic, assign) int               songIndex;

@end
