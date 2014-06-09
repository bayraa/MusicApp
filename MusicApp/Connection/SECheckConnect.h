//
//  checkConnect.h
//  Working-Dog
//
//  Created by Jörg Stewig on 04.11.10.
//  Copyright 2010 Dögel IT-Management. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import <netdb.h>
#import <SystemConfiguration/SystemConfiguration.h>

@interface SECheckConnect : NSObject {

}

+ (BOOL)connectedToNetwork;

+ (BOOL)connectedToNetworkWithoutAlert;

+ (void)start;

@end
