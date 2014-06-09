//
//  MainAbstractViewController.m
//  iRestaurantRepo
//
//  Created by Sodtseren Enkhee on 2/18/14.
//  Copyright (c) 2014 Sodtseren Enkhee. All rights reserved.
//

#import "MainAbstractViewController.h"
#import "MyAlertView.h"
#import <SWRevealViewController/SWRevealViewController.h>

@interface MainAbstractViewController ()

@end

@implementation MainAbstractViewController
@synthesize headerView;
@synthesize titleLabel;
@synthesize menuButton;
@synthesize backButton;
@synthesize HUD;
@synthesize refreshControl;

- (void)showLoadingHUD {
    if (HUD == nil) {
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        HUD.userInteractionEnabled = YES;
        self.HUD.labelText = NSLocalizedString(@"Уншиж байна...", nil);
    }
    [self.view addSubview:self.HUD];
    [self.HUD show:YES];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self configureView];
}

- (void)configureView {
    //UIRefreshControl
    {
        self.refreshControl = [[UIRefreshControl alloc] init];
        [refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    }
   // self.view.backgroundColor = CLEAR_COLOR;
    UIImageView * brickAnim = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"album_bg.jpg"]];
    brickAnim.frame = CGRectMake(0, 0, 320, 580);
    [self.view addSubview:brickAnim];
    [self.view addSubview:self.headerView];
}

#pragma mark -
#pragma mark Connection

#pragma mark -
#pragma mark Rotation
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (isiPhone) {
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
    } else {
        return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
    }
}

-(BOOL)shouldAutorotate
{
    return YES;
}

-(NSUInteger)supportedInterfaceOrientations
{
    if (isiPhone) {
        return UIInterfaceOrientationMaskPortrait;
    } else {
        return UIInterfaceOrientationMaskLandscape;
    }
}

#pragma mark -
#pragma mark UIActions
-(void)handleRefresh:(UIRefreshControl *)refresh {
    // Reload my data
    //...
}
- (void)menuButtonClicked:(UIButton *)button {
    SWRevealViewController *revealController = [self revealViewController];
    [revealController revealToggle:button];
}
- (void)backButtonClicked {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark User Methods

#pragma mark -
#pragma mark Getters
- (UIView *)headerView {
    if (headerView == nil) {
        
        int height = 44;
        if ([SEUtils OSVersion] >= 7)
            height += 20;
        
        headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MY_BOUNDS.width, height)];
        headerView.backgroundColor = CLEAR_COLOR;
        headerView.clipsToBounds = YES;
        {
            UIView *view = [[UIView alloc] initWithFrame:headerView.bounds];
            view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5f];
            [headerView addSubview:view];
        }
        
        //SubViews
        {
            //Back button
            if (self.navigationController.viewControllers.count > 1)
                [headerView addSubview:self.backButton];
            else
                [headerView addSubview:self.menuButton];
            
            int y = 0;
            if ([SEUtils OSVersion] >= 7)
                y += 20;
            
            //Back button <=> Menu button
            self.backButton.frame = CGRectMake(0, y, 44, 44);
            
            [headerView addSubview:self.titleLabel];
        }
    }
    return headerView;
}
- (UILabel *)titleLabel {
    if (titleLabel == nil) {
        
        int y = 0;
        if ([SEUtils OSVersion] >= 7)
            y += 20;
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(44, y, MY_BOUNDS.width-88, 44)];
        titleLabel.backgroundColor = CLEAR_COLOR;
        titleLabel.textColor = BLACK_COLOR;
        titleLabel.font = FONT_MEDIUM_BOLD;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.numberOfLines = 2;
    }
    return titleLabel;
}
- (UIButton *)menuButton {
    if (menuButton == nil) {
        
        int y = 0;
        if ([SEUtils OSVersion] >= 7)
            y += 20;
        
        menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
        menuButton.frame = CGRectMake(0, y, 46, 49);
        [menuButton setImage:[UIImage imageNamed:@"menu_button"] forState:UIControlStateNormal];
        [menuButton addTarget:self action:@selector(menuButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return menuButton;
}
- (UIButton *)backButton {
    if (backButton == nil) {
        
        int y = 0;
        if ([SEUtils OSVersion] >= 7)
            y += 20;
        
        backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        backButton.frame = CGRectMake(0, y, 44, 44);
        [backButton setImage:[UIImage imageNamed:@"button_back"] forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return backButton;
}

@end
