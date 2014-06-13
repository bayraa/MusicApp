//
//  LoginViewController.h
//  SidebarDemo
//
//  Created by Bayraa on 4/21/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "MainAbstractViewController.h"
#import "RequestHelper.h"
@interface LoginViewController : UIViewController<FBLoginViewDelegate ,RequestHelperDelegate>

@property (strong, nonatomic) FBProfilePictureView *profilePictureView;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *statusLabel;
@property (strong , nonatomic)  UIView *proView;
@end
