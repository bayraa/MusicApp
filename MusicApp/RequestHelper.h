//
//  UploadHelper.h
//  UserMod
//
//  Created by App Developer on 4/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

@protocol RequestHelperDelegate;

@interface RequestHelper : NSObject<NSURLConnectionDataDelegate,NSURLConnectionDataDelegate>

@property long dataSize;

@property (nonatomic,retain) id<RequestHelperDelegate> delegate;
@property (nonatomic,retain) NSMutableData *receivedData;

- (void)sendASyncRequestWithHost:(NSString *)host Data:(NSData *)data withValues:(NSDictionary *)values;

- (NSString *)sendSyncRequestWithHost:(NSString *)host Data:(NSData *)data withValues:(NSDictionary *)values;

@end

@protocol RequestHelperDelegate<NSObject>

@optional

- (void)upload:(RequestHelper *)downloadBar didFinishWithData:(NSData *)fileData;
- (void)upload:(RequestHelper *)downloadBar didFailWithError:(NSError *)error;
- (void)uploadUpdated:(RequestHelper *)downloadBar withTotal:(NSInteger)total withCurrent:(NSInteger)current;

@end
