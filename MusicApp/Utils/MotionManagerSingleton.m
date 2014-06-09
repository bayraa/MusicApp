//
//  MotionManagerSingleton.m
//  BoldRepo
//
//  Created by Sodtseren Enkhee on 5/20/14.
//  Copyright (c) 2014 Sodtseren Enkhee. All rights reserved.
//

#import "MotionManagerSingleton.h"

@implementation MotionManagerSingleton

CMMotionManager *motionManager;
CMAttitude *referenceAttitude;
bool initialized;

#pragma mark -
#pragma mark Singleton Methods

+ (MotionManagerSingleton*)sharedInstance {
    
    static MotionManagerSingleton *_sharedInstance;
    if(!_sharedInstance) {
        static dispatch_once_t oncePredicate;
        dispatch_once(&oncePredicate, ^{
            _sharedInstance = [[super allocWithZone:nil] init];
        });
    }
    
    return _sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone {
    
    return [self sharedInstance];
}


- (id)copyWithZone:(NSZone *)zone {
    return self;
}

#if (!__has_feature(objc_arc))

- (id)retain {
    
    return self;
}

- (unsigned)retainCount {
    return UINT_MAX;  //denotes an object that cannot be released
}

- (void)release {
    //do nothing
}

- (id)autorelease {
    
    return self;
}
#endif

#pragma mark -
#pragma mark Custom Methods

// Add your custom methods here
- (void)startMotionManager{
    if (!initialized) {
        motionManager = [[CMMotionManager alloc] init];
        if (motionManager.deviceMotionAvailable) {
            motionManager.deviceMotionUpdateInterval = 1.0/70.0;
            [motionManager startDeviceMotionUpdates];
            NSLog(@"Device Motion Manager Started");
            initialized = YES;
        }
    }
}
- (CMAcceleration)getCurrentAcceleration{
    return motionManager.deviceMotion.userAcceleration;
}
- (CMAttitude*)getCurrentAttitude{
    return motionManager.deviceMotion.attitude;
}
- (CMAttitude*)getStartingAttitude{
    return referenceAttitude;
}
- (float)getInterval{
    return motionManager.accelerometerUpdateInterval;
}
- (NSTimeInterval) getStamp{
    return motionManager.deviceMotion.timestamp;
}
- (void)setStartingAttitude: (CMAttitude*) ref{
    referenceAttitude = motionManager.deviceMotion.attitude;
}
- (bool)isDeviceReady{
    return motionManager.deviceMotionActive;
}
- (void)destroyMotionManager{
    [motionManager stopDeviceMotionUpdates];
    motionManager = nil;
}

@end

