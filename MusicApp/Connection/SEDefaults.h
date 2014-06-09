//
//  SEDefaults.h
//  SEDefaults
//
//  Created by Developer on 10/17/13.
//  Copyright (c) 2013 SE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SEUtils.h"
#import "SECheckConnect.h"
#import "UIImage+SEUtils.h"
#import "NSString+SEUtils.h"
#import "DDLog.h"
#import "DDTTYLogger.h"

// Log levels: off, error, warn, info, verbose
static const int ddLogLevel = LOG_LEVEL_VERBOSE;

//COLOR
#define RANDOM_COLOR                        [UIColor colorWithRed:(arc4random()%100) *.01 green:(arc4random()%100) *.01 blue:(arc4random()%100) *.01 alpha:1]
#define CLEAR_COLOR                         [UIColor clearColor]

//FONT
#define NORMALFONT                          @"Helvetica"
#define BOLDFONT                            @"Helvetica-Bold"

//APPLICATION DEFAULT
#define USERDEF                             [NSUserDefaults standardUserDefaults]
#define APPDEL                              ((AppDelegate *)[[UIApplication sharedApplication] delegate])

//CONNECTION DEFAULT
#define NO_CONNECTION_ALERT                 @"Сервертэй холбогдоход алдаа гарлаа. Интернэт холболтоо шалгана уу."

#define isiPhone                            [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone
#define isiPad                              [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad
#define isiPhone5                           ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < 1 )

static NSString *const ErrorTag = @"ErrorTag";

#define SELogError(frmt, ...) LOG_OBJC_TAG_MACRO(NO, 0, 0, 0, ErrorTag, frmt, ##__VA_ARGS__)

#define MY_BOUNDS                           [SEUtils getBounds]

@interface SEDefaults : NSObject

+ (SEDefaults *)sharedManager;

- (void)printTestLog;

@end
