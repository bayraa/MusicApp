//
//  MotionManagerSingleton.h
//  BoldRepo
//
//  Created by Sodtseren Enkhee on 5/20/14.
//  Copyright (c) 2014 Sodtseren Enkhee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>

@interface MotionManagerSingleton : NSObject

+ (MotionManagerSingleton*) sharedInstance;

- (void)startMotionManager;
- (CMAcceleration)getCurrentAcceleration;
- (CMAttitude*)getCurrentAttitude;
- (CMAttitude*)getStartingAttitude;
- (void)setStartingAttitude: (CMAttitude*) ref;
- (bool)isDeviceReady;
- (void)destroyMotionManager;
- (NSTimeInterval) getStamp;

@end
