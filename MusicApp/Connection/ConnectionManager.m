//
//  ConnectionManager.m
//  iWaiterRepo
//
//  Created by Sodtseren Enkhee on 2/10/14.
//  Copyright (c) 2014 Sodtseren. All rights reserved.
//

#import "ConnectionManager.h"
#import "ConnectionURLs.h"
#import "Parser.h"
#import "TimeoutAFHTTPRequestSerializer.h"

@implementation ConnectionManager

+ (ConnectionManager *)getConnectionManager {
    static dispatch_once_t once;
    static ConnectionManager *sharedObject;
    dispatch_once(&once, ^{
        sharedObject = [[ConnectionManager alloc] init];
    });
    return sharedObject;
}

#pragma mark -
#pragma mark Main Methods
//All Connection
- (AFHTTPRequestOperationManager *)getRequestOperationManager {
    AFHTTPRequestOperationManager *mymanager = [AFHTTPRequestOperationManager manager];
    mymanager.responseSerializer = [AFHTTPResponseSerializer serializer];
    mymanager.requestSerializer = [[TimeoutAFHTTPRequestSerializer alloc] initWithTimeout:CONNECTION_TIMEOUT];
    return mymanager;
}
//Log Response
- (void)printResponseString:(id)responseObject methodName:(NSString *)methodName {
    
    if ([responseObject isKindOfClass:[NSData class]])
        DDLogDebug(@"%@ RESPONSE SUCCESS:%@", methodName, [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
    else
        DDLogDebug(@"%@ RESPONSE SUCCESS:%@", methodName, responseObject);
}
//NSData => (NSArray | NSDictionary)
- (id)parseResponseObject:(id)responseObject
                  failure:(void(^)(NSString *errorMessage, NSError *error))failure {
    
    responseObject = [SEUtils getObjectFromJsonData:responseObject];
    if (responseObject == nil) {
        if (failure) {
            failure(nil, nil);
        }
    }
    return responseObject;
}
//Check Response
- (BOOL)failureOrSessionExpired:(NSDictionary *)responseDictionary FAILURE_SESSION_EXPIRED_BLOCK {
    
    NSString *successString = [responseDictionary valueForKey:@"success"];
    if (successString && [successString isKindOfClass:[NSString class]]) {
        if ([[successString lowercaseString] isEqualToString:[SESSION_EXPIRED_STRING lowercaseString]]) {
            if (sessionExpired) {
                sessionExpired();
                return YES;
            }
        }
    }
    
    NSString *failureString = [responseDictionary valueForKey:@"failure"];
    if (failureString && [failureString isKindOfClass:[NSString class]]) {
        if ([[failureString lowercaseString] isEqualToString:[SESSION_EXPIRED_STRING lowercaseString]]) {
            if (sessionExpired) {
                sessionExpired();
                return YES;
            }
        }
        if (failure) {
            failure(failureString, nil);
            return YES;
        }
    }
    
    return NO;
}

#pragma mark -
#pragma mark Album
- (void)getAlbumsSuccess:(void(^)(NSArray *))success FAILURE_SESSION_EXPIRED_BLOCK {
    
    NSString *urlString = [NSString stringWithFormat:URL_GET_ALBUMS, HOST];
    DDLogWarn(@"URLSTRING:%@", urlString);
    
    AFHTTPRequestOperationManager *manager = [self getRequestOperationManager];
    
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        CHECK_CONNECTION;
        
        NSArray *resultArray = [responseObject valueForKey:@"albums"];
        if (resultArray) {
            if (success)
                success([PARSER parseAlbums:resultArray]);
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        FAILURE_CONNECTION;
    }];
}

- (void)getVideosSuccess:(void(^)(NSArray *))success FAILURE_SESSION_EXPIRED_BLOCK{
    NSString *urlString = [NSString stringWithFormat:URL_GET_Videos, HOST];
    DDLogWarn(@"URLSTRING:%@", urlString);
    
    AFHTTPRequestOperationManager *manager = [self getRequestOperationManager];
    
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        CHECK_CONNECTION;
                
        NSArray *resultArray = (NSArray *)responseObject;
        if (resultArray) {
            if (success)
                success([PARSER parseVideo:resultArray]);
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        FAILURE_CONNECTION;
    }];
}

- (void)getImageFromURLString:(NSString *)urlString
                      success:(void(^)(UIImage *))success FAILURE_SESSION_EXPIRED_BLOCK {
    
    DDLogWarn(@"URLSTRING:%@", urlString);
    
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
    requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        FAILURE_CONNECTION;
    }];
    [requestOperation start];
}

@end
