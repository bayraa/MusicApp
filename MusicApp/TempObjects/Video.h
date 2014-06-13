//
//  Video.h
//  MusicApp
//
//  Created by Bayraa on 6/9/14.
//  Copyright (c) 2014 Kaizen Mongolia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Video : NSObject

@property (nonatomic, strong) NSString          *published;
@property (nonatomic, strong) NSString          *updated;
@property (nonatomic, strong) NSString          *title;
@property (nonatomic, strong) NSString          *content;
@property (nonatomic, strong) NSString          *content_2;
@property (nonatomic, strong) NSString          *link;
@property (nonatomic, strong) NSString          *link_xml;
@property (nonatomic, strong) NSString          *youtube_id;
@property (nonatomic, strong) NSString          *url_embed;
@property (nonatomic, strong) NSArray           *cover;
@property (nonatomic, strong) NSString          *views;
@property (nonatomic, strong) NSString          *likes;

@end
