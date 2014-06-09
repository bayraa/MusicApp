//
//  PlayerViewController.h
//  BoldRepo
//
//  Created by Sodtseren Enkhee on 5/19/14.
//  Copyright (c) 2014 Sodtseren Enkhee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainAbstractViewController.h"
#import "Album.h"

@interface PlayerViewController : MainAbstractViewController

@property (nonatomic, strong) Album *album;

@end
