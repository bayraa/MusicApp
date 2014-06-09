//
//  LeftMenuController.h
//  MusicApp
//
//  Created by Bayraa on 6/9/14.
//  Copyright (c) 2014 Kaizen Mongolia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FGalleryViewController.h"

@interface LeftMenuController : UIViewController<FGalleryViewControllerDelegate> {
    FGalleryViewController *gallery;
    NSMutableArray *networkImages;
    NSMutableArray *localImages;
}

@property (nonatomic , strong) UIImageView *menuBg;

@property (nonatomic , strong) UIButton *albumBtn;
@property (nonatomic , strong) UIButton *videoBtn;
@property (nonatomic , strong) UIButton *photosBtn;
@property (nonatomic , strong) UIButton *eventBtn;
@property (nonatomic , strong) UIButton *memberBtn;

@property (nonatomic , strong) UILabel *albumLabel;
@property (nonatomic , strong) UILabel *videoLabel;
@property (nonatomic , strong) UILabel *photosLabel;
@property (nonatomic , strong) UILabel *eventLabel;
@property (nonatomic , strong) UILabel *memberLabel;

@end
