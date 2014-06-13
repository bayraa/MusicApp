//
//  UploadHelper.m
//  UserMod
//
//  Created by App Developer on 4/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RequestHelper.h"

@implementation RequestHelper

@synthesize dataSize;
@synthesize delegate;
@synthesize receivedData;

- (id)init
{
    
    self.receivedData = [[NSMutableData alloc] init];
    return [super init];
}

-(NSURLRequest *)createRequestWithPath:(NSString *)path withKeys:(NSDictionary *)postKeys withData:(NSData *)data
{
	//create the URL POST Request to tumblr
   // NSString *urlStr = [NSString stringWithFormat:@"http://tsag-agaar.gov.mn/3big/weather/index.php?/%@",path];
    NSString *urlStr = [NSString stringWithFormat:@"http://apps.gadget.mn/music_api/index.php?/%@",path];

	NSURL *tumblrURL = [NSURL URLWithString:urlStr];
	NSMutableURLRequest *tumblrPost = [NSMutableURLRequest requestWithURL:tumblrURL];
	[tumblrPost setHTTPMethod:@"POST"];
	
	//Add the header info
	NSString *stringBoundary = @"0xKhTmLbOuNdArY";
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",stringBoundary];
	[tumblrPost addValue:contentType forHTTPHeaderField: @"Content-Type"];
	
	//create the body
	NSMutableData *postBody = [NSMutableData data];
	[postBody appendData:[[NSString stringWithFormat:@"--%@\r\n",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	//add key values from the NSDictionary object
    
    if (![postKeys isEqual:nil]) 
    {
        NSEnumerator *keys = [postKeys keyEnumerator];
        int i;
        for (i = 0; i < [postKeys count]; i++) {
            NSString *tempKey = [keys nextObject];
            [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",tempKey] dataUsingEncoding:NSUTF8StringEncoding]];
            [postBody appendData:[[NSString stringWithFormat:@"%@",[postKeys objectForKey:tempKey]] dataUsingEncoding:NSUTF8StringEncoding]];
            [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        }
    }

	if (![data isEqual:nil])
    {
        NSLog(@"data size : %i",[data length]);
        //add data field and file data
        [postBody appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"image\"; filename=\"ipodfile.jpg\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithString:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[NSData dataWithData:data]];
        [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    }

    self.dataSize = [postBody length];
	//add the body to the post
	[tumblrPost setHTTPBody:postBody];
	return tumblrPost;

}

- (void)sendASyncRequestWithHost:(NSString *)host Data:(NSData *)data withValues:(NSDictionary *)values
{
	NSURLRequest *request = [self createRequestWithPath:host withKeys:values withData:data];
    [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
}

- (NSString *)sendSyncRequestWithHost:(NSString *)host Data:(NSData *)data withValues:(NSDictionary *)values
{
	NSURLRequest *request = [self createRequestWithPath:host withKeys:values withData:data];
    NSURLResponse *response;
    NSError *err = NULL;
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    NSString *responseStr = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",responseStr);
    
    return responseStr;
}

- (void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
    NSLog(@"%i/%i",totalBytesWritten,totalBytesExpectedToWrite);
    
    [self.delegate uploadUpdated:self withTotal:totalBytesExpectedToWrite withCurrent:totalBytesWritten];
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    
    [self.delegate upload:self didFailWithError:error];
    
    NSLog(@"%@",[error localizedDescription]);
    
    NSLog(@"Upload Failed with error!!!");
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self.delegate upload:self didFinishWithData:self.receivedData];
    
    NSString *str = [[NSString alloc] initWithData:self.receivedData encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",str);
    
    if ([str isEqualToString:@"success"])
    {
        NSLog(@"Upload Success!!!");
    }
    else
    {
        NSLog(@"Upload Fail in server!!!");
    }
    
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data 
{
    [self.receivedData appendData:data];
}



@end