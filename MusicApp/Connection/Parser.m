//
//  Parser.m
//  iRestaurantRepo
//
//  Created by Sodtseren Enkhee on 2/25/14.
//  Copyright (c) 2014 Sodtseren Enkhee. All rights reserved.
//

#import "Parser.h"
#import "Album.h"
#import "Song.h"
#import "Video.h"

@implementation Parser

+ (Parser *)getParser {
    static dispatch_once_t once;
    static Parser *sharedObject;
    dispatch_once(&once, ^{
        sharedObject = [[Parser alloc] init];
    });
    return sharedObject;
}

- (NSString *)getStringValue:(NSDictionary *)dictionary Key:(NSString *)key {
    NSObject *temp = [dictionary valueForKey:key];
    NSString *string = [NSString stringWithFormat:@"%@", temp];
    if ([string isEqualToString:@"(null)"] || [string isEqualToString:@"<null>"] || [string isEqualToString:@"null"])
        return @"";
    return [NSString stringWithFormat:@"%@", temp];
}

#pragma mark -
#pragma mark Albums
- (NSArray *)parseAlbums:(NSArray *)dicArray {
    NSMutableArray *resultArray= [NSMutableArray array];
    
    if ([dicArray isKindOfClass:[NSArray class]]) {
        for (NSDictionary *dict in dicArray) {
            Album *album = [[Album alloc] init];
            album.itemid = [self getStringValue:dict Key:@"id"];
            album.title = [self getStringValue:dict Key:@"title"];
            album.description_ = [self getStringValue:dict Key:@"description"];
            {
                album.image = [self getStringValue:dict Key:@"image"];
                album.image = [NSString stringWithFormat:@"http://%@/images/albums/%@", HOST, album.image];
            }
            {
                album.shareImage = [self getStringValue:dict Key:@"image"];
                album.shareImage = [NSString stringWithFormat:@"http://%@/images/share/%@", HOST, album.shareImage];
            }
            {
                album.cover = [self getStringValue:dict Key:@"cover"];
                album.cover = [NSString stringWithFormat:@"http://%@/images/cdcovers/%@", HOST, album.cover];
            }
            album.executive_producer = [self getStringValue:dict Key:@"executive_producer"];
            album.album_producer = [self getStringValue:dict Key:@"album_producer"];
            album.singer = [self getStringValue:dict Key:@"singer"];
            album.created_at = [self getStringValue:dict Key:@"created_at"];
            album.songsArray = [self parseSongs:[dict valueForKey:@"song"] album:album];
            [resultArray addObject:album];
        }
    }
    
    return resultArray;
}

#pragma mark -
#pragma mark Song
- (NSArray *)parseSongs:(NSArray *)dicArray album:(Album *)album {
    NSMutableArray *resultArray= [NSMutableArray array];
    
    int i = 0;
    
    if ([dicArray isKindOfClass:[NSArray class]]) {
        for (NSDictionary *dict in dicArray) {
            Song *song = [[Song alloc] init];
            song.itemid = [self getStringValue:dict Key:@"id"];
            song.album_id = [self getStringValue:dict Key:@"album_id"];
            song.title = [self getStringValue:dict Key:@"title"];
            song.itunes = [self getStringValue:dict Key:@"itunes"];
            song.amazon = [self getStringValue:dict Key:@"amazon"];
            song.google = [self getStringValue:dict Key:@"google"];
            song.created_at = [self getStringValue:dict Key:@"created_at"];
            {
                song.path = [self getStringValue:dict Key:@"path"];
                song.path = [NSString stringWithFormat:@"http://%@/songs/%@", HOST, song.path];
            }
            song.album = album;
            song.songIndex = i++;
            [resultArray addObject:song];
        }
    }
    
    return resultArray;
}

#pragma mark - 
#pragma mark video

- (NSArray *)parseVideo:(NSArray *)dicArray {
    NSMutableArray *resultArray= [NSMutableArray array];
    if ([dicArray isKindOfClass:[NSArray class]]) {
        for (NSDictionary *dict in dicArray) {
            Video *video = [[Video alloc] init];
            video.published = [self getStringValue:dict Key:@"published"];
            video.updated = [self getStringValue:dict Key:@"updated"];
            video.title = [self getStringValue:dict Key:@"title"];
            video.content = [self getStringValue:dict Key:@"content"];
            video.content_2 = [self getStringValue:dict Key:@"content_2"];
            video.link = [self getStringValue:dict Key:@"link"];
            video.link_xml = [self getStringValue:dict Key:@"link_xml"];
            video.youtube_id = [self getStringValue:dict Key:@"id"];
            video.url_embed = [self getStringValue:dict Key:@"url_embed"];
            video.views = [self getStringValue:dict Key:@"views"];
            video.likes = [self getStringValue:dict Key:@"likes"];
            NSArray *coverArray = [dict valueForKey:@"cover"];
            video.cover = coverArray;
            [resultArray addObject:video];
        }
    }
    
    return resultArray;
}

@end
