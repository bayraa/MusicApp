//
//  ConnectionManager.h
//  iWaiterRepo
//
//  Created by Sodtseren Enkhee on 2/10/14.
//  Copyright (c) 2014 Sodtseren. All rights reserved.
//

#import <Foundation/Foundation.h>

#define FAILURE_SESSION_EXPIRED_BLOCK   failure:(void(^)(NSString *errorMessage, NSError *error))failure \
                                        sessionExpired:(void(^)())sessionExpired

#define FAILURE_CONNECTION              DDLogError(@"RESPONSE FAILED:%@", error); \
                                        if (failure) \
                                            failure(nil, error);

#define CHECK_CONNECTION                [self printResponseString:responseObject methodName:[NSString stringWithFormat:@"%s", __PRETTY_FUNCTION__]]; \
                                        responseObject = [self parseResponseObject:responseObject failure:failure]; \
                                        if ([self failureOrSessionExpired:responseObject failure:failure sessionExpired:sessionExpired]) { \
                                            return; \
                                        }

@interface ConnectionManager : NSObject

+ (ConnectionManager *)getConnectionManager;

#pragma mark -
#pragma mark Album
- (void)getAlbumsSuccess:(void(^)(NSArray *))success FAILURE_SESSION_EXPIRED_BLOCK;
- (void)getVideosSuccess:(void(^)(NSArray *))success FAILURE_SESSION_EXPIRED_BLOCK;

- (void)getImageFromURLString:(NSString *)urlString
                      success:(void(^)(UIImage *))success FAILURE_SESSION_EXPIRED_BLOCK;

@end
