//
//  LeftMenuController.m
//  MusicApp
//
//  Created by Bayraa on 6/9/14.
//  Copyright (c) 2014 Kaizen Mongolia. All rights reserved.
//

#import "LeftMenuController.h"
#import "AlbumsViewController.h"
#import "MyNavigationController.h"
#import <SWRevealViewController/SWRevealViewController.h>
#import "CJSONDeserializer.h"
#import "VideoViewController.h"
#import "EventViewController.h"
#import "LoginViewController.h"
@interface LeftMenuController ()

@end

@implementation LeftMenuController

@synthesize albumBtn;
@synthesize videoBtn;
@synthesize photosBtn;
@synthesize eventBtn;
@synthesize memberBtn;

@synthesize albumLabel;
@synthesize videoLabel;
@synthesize photosLabel;
@synthesize eventLabel;
@synthesize memberLabel;
@synthesize menuBg;

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
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.frame = CGRectMake(0, 0, 84, 568);
    [self.view addSubview:self.menuBg];
    [self.view addSubview:self.albumBtn];
    [self.view addSubview:self.videoBtn];
    [self.view addSubview:self.photosBtn];
    [self.view addSubview:self.eventBtn];
    [self.view addSubview:self.memberBtn];
    
    [self.view addSubview:self.albumLabel];
    [self.view addSubview:self.videoLabel];
    [self.view addSubview:self.photosLabel];
    [self.view addSubview:self.eventLabel];
    [self.view addSubview:self.memberLabel];
    
    NSURL *url = [NSURL URLWithString:@"http://apps.gadget.mn/photo.php"];
    NSError *error = nil;
    NSString *jsonreturn = [[NSString alloc] initWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
    NSData *jsonData = [jsonreturn dataUsingEncoding:NSUTF16BigEndianStringEncoding];
    NSDictionary *dict = [[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData error:&error];
    NSArray *temp;
    networkImages = [NSMutableArray array];
    if (dict){
        temp = [dict valueForKey:@"photos"];
    }
    for (int i=0; i<=temp.count-1; i++) {
        NSDictionary *dict = [temp objectAtIndex:i];
        NSString *urlAppend = [NSString stringWithFormat:@"http://apps.gadget.mn/photos/"];
        NSString *urlstr = [urlAppend stringByAppendingFormat:@"%@",[dict valueForKey:@"path"]];
        [networkImages addObject:urlstr];
    }
    
    localImages = [[NSMutableArray alloc] initWithCapacity:19];
    for (int i=1; i<=19; i++) {
        [localImages addObject:[NSString stringWithFormat:@"%i.jpg",i]];
    }
    
    
}

#pragma mark -
#pragma mark Getters

- (UIImageView *)menuBg{
    if(menuBg == nil){
        menuBg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 84, 568)];
        menuBg.image = [UIImage imageNamed:@"menu_bg.jpg"];
    }
    
    return menuBg;
}

- (UIButton *)albumBtn {
    if (albumBtn == nil) {
        albumBtn = [[UIButton alloc] initWithFrame: CGRectMake(20, 108, 44, 44)];
        albumBtn.backgroundColor = CLEAR_COLOR;
        [albumBtn setImage:[UIImage imageNamed:@"menu_music.png"] forState:UIControlStateNormal];
        [albumBtn addTarget:self action:@selector(AlbumButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return albumBtn;
}

- (UIButton *)videoBtn {
    if (videoBtn == nil) {
        videoBtn = [[UIButton alloc] initWithFrame: CGRectMake(20, 202, 44, 44)];
        videoBtn.backgroundColor = CLEAR_COLOR;
        [videoBtn setImage:[UIImage imageNamed:@"menu_clip.png"] forState:UIControlStateNormal];
        [videoBtn addTarget:self action:@selector(videoBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return videoBtn;
}

- (UIButton *)photosBtn {
    if (photosBtn == nil) {
        photosBtn = [[UIButton alloc] initWithFrame: CGRectMake(20, 300, 44, 44)];
        photosBtn.backgroundColor = CLEAR_COLOR;
        [photosBtn setImage:[UIImage imageNamed:@"menu_pictures.png"] forState:UIControlStateNormal];
        [photosBtn addTarget:self action:@selector(PhotosBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return photosBtn;
}

- (UIButton *)eventBtn {
    if (eventBtn == nil) {
        eventBtn = [[UIButton alloc] initWithFrame: CGRectMake(20, 390, 44, 44)];
        eventBtn.backgroundColor = CLEAR_COLOR;
        [eventBtn setImage:[UIImage imageNamed:@"menu_event.png"] forState:UIControlStateNormal];
        [eventBtn addTarget:self action:@selector(EventBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return eventBtn;
}

- (UIButton *)memberBtn {
    if (memberBtn == nil) {
        memberBtn = [[UIButton alloc] initWithFrame: CGRectMake(20, 485, 44, 44)];
        memberBtn.backgroundColor = CLEAR_COLOR;
        [memberBtn setImage:[UIImage imageNamed:@"menu_members.png"] forState:UIControlStateNormal];
        [memberBtn addTarget:self action:@selector(memberBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return memberBtn;
}

-(UILabel *) albumLabel{
    if(albumLabel == nil) {
        albumLabel = [[UILabel alloc]initWithFrame: CGRectMake(0, 148, 84, 21)];
        albumLabel.backgroundColor = [UIColor clearColor];
        albumLabel.textColor = [UIColor grayColor];
        albumLabel.textAlignment = NSTextAlignmentCenter;
        [albumLabel setFont:[UIFont fontWithName:@"AGAvantGardeMon" size:15]];
        albumLabel.text = @"Дуу";
    }
    return albumLabel;
    
}

-(UILabel *) videoLabel{
    if(videoLabel == nil) {
        videoLabel = [[UILabel alloc]initWithFrame: CGRectMake(0, 242, 84, 21)];
        videoLabel.backgroundColor = [UIColor clearColor];
        videoLabel.textColor = [UIColor grayColor];
        videoLabel.textAlignment = NSTextAlignmentCenter;
        [videoLabel setFont:[UIFont fontWithName:@"AGAvantGardeMon" size:15]];
        videoLabel.text = @"Видео";
    }
    return videoLabel;
    
}

-(UILabel *) photosLabel{
    if(photosLabel == nil) {
        photosLabel = [[UILabel alloc]initWithFrame: CGRectMake(0, 340, 84, 21)];
        photosLabel.backgroundColor = [UIColor clearColor];
        photosLabel.textColor = [UIColor grayColor];
        photosLabel.textAlignment = NSTextAlignmentCenter;
        [photosLabel setFont:[UIFont fontWithName:@"AGAvantGardeMon" size:15]];
        photosLabel.text = @"Зураг";
    }
    return photosLabel;
    
}

-(UILabel *) eventLabel{
    if(eventLabel == nil) {
        eventLabel = [[UILabel alloc]initWithFrame: CGRectMake(0, 430, 84, 21)];
        eventLabel.backgroundColor = [UIColor clearColor];
        eventLabel.textColor = [UIColor grayColor];
        eventLabel.textAlignment = NSTextAlignmentCenter;
        [eventLabel setFont:[UIFont fontWithName:@"AGAvantGardeMon" size:15]];
        eventLabel.text = @"Үйл явдал";
    }
    return eventLabel;
    
}

-(UILabel *) memberLabel{
    if(memberLabel == nil) {
        memberLabel = [[UILabel alloc]initWithFrame: CGRectMake(0, 525, 84, 21)];
        memberLabel.backgroundColor = [UIColor clearColor];
        memberLabel.textColor = [UIColor grayColor];
        memberLabel.textAlignment = NSTextAlignmentCenter;
        [memberLabel setFont:[UIFont fontWithName:@"AGAvantGardeMon" size:15]];
        memberLabel.text = @"Гишүүд";
    }
    return memberLabel;
    
}

-(void)AlbumButtonClicked {
    
    SWRevealViewController *revealController = [self revealViewController];
    UIViewController *frontViewController = revealController.frontViewController;
    MyNavigationController *frontNavigationController = nil;
    
    if ( [frontViewController isKindOfClass:[MyNavigationController class]] )
        frontNavigationController = (id)frontViewController;
    
    if ( ![frontNavigationController.topViewController isKindOfClass:[AlbumsViewController class]] )
    {
        AlbumsViewController *controller = [[AlbumsViewController alloc] initWithNibName:nil bundle:nil];
        MyNavigationController *navigationController = [[MyNavigationController alloc] initWithRootViewController:controller];
        navigationController.navigationBarHidden = YES;
        [revealController setFrontViewController:navigationController animated:NO];
    }
    
    [self.revealViewController revealToggle:nil];
}

-(void)PhotosBtnClicked {
    SWRevealViewController *revealController = [self revealViewController];
    UIViewController *frontViewController = revealController.frontViewController;
    MyNavigationController *frontNavigationController = nil;
    if ( [frontViewController isKindOfClass:[MyNavigationController class]] )
        frontNavigationController = (id)frontViewController;
    
    if ( ![frontNavigationController.topViewController isKindOfClass:[gallery class]] )
    {
        gallery = [[FGalleryViewController alloc] initWithPhotoSource:self];
        MyNavigationController *navigationController = [[MyNavigationController alloc] initWithRootViewController:gallery];
        navigationController.navigationBarHidden = YES;
        [revealController setFrontViewController:navigationController animated:NO];
    }
    
    [self.revealViewController revealToggle:nil];
}

-(void)EventBtnClicked {
    SWRevealViewController *revealController = [self revealViewController];
    UIViewController *frontViewController = revealController.frontViewController;
    MyNavigationController *frontNavigationController = nil;
    
    if ( [frontViewController isKindOfClass:[MyNavigationController class]] )
        frontNavigationController = (id)frontViewController;
    
    if ( ![frontNavigationController.topViewController isKindOfClass:[EventViewController class]] )
    {
        EventViewController *controller = [[EventViewController alloc] initWithNibName:nil bundle:nil];
        MyNavigationController *navigationController = [[MyNavigationController alloc] initWithRootViewController:controller];
        navigationController.navigationBarHidden = YES;
        [revealController setFrontViewController:navigationController animated:NO];
    }
    
    [self.revealViewController revealToggle:nil];
}

-(void) videoBtnClicked {
    SWRevealViewController *revealController = [self revealViewController];
    UIViewController *frontViewController = revealController.frontViewController;
    MyNavigationController *frontNavigationController = nil;
    
    if ( [frontViewController isKindOfClass:[MyNavigationController class]] )
        frontNavigationController = (id)frontViewController;
    
    if ( ![frontNavigationController.topViewController isKindOfClass:[VideoViewController class]] )
    {
        VideoViewController *controller = [[VideoViewController alloc] initWithNibName:nil bundle:nil];
        MyNavigationController *navigationController = [[MyNavigationController alloc] initWithRootViewController:controller];
        navigationController.navigationBarHidden = YES;
        [revealController setFrontViewController:navigationController animated:NO];
    }
    
    [self.revealViewController revealToggle:nil];
}

-(void) memberBtnClicked {
    SWRevealViewController *revealController = [self revealViewController];
    UIViewController *frontViewController = revealController.frontViewController;
    MyNavigationController *frontNavigationController = nil;
    
    if ( [frontViewController isKindOfClass:[MyNavigationController class]] )
        frontNavigationController = (id)frontViewController;
    
    if ( ![frontNavigationController.topViewController isKindOfClass:[LoginViewController class]] )
    {
        LoginViewController *controller = [[LoginViewController alloc] initWithNibName:nil bundle:nil];
        MyNavigationController *navigationController = [[MyNavigationController alloc] initWithRootViewController:controller];
        navigationController.navigationBarHidden = YES;
        [revealController setFrontViewController:navigationController animated:NO];
    }
    
    [self.revealViewController revealToggle:nil];
}

-(int)numberOfPhotosForPhotoGallery:(FGalleryViewController *)gallery{
    int num;
    //  if( gallery == localGallery ) {
    //     num = [localImages count];
    // }
    // else {
    num = [networkImages count];
    // }
	return num;
}

-(FGalleryPhotoSourceType)photoGallery:(FGalleryViewController *)gallery sourceTypeForPhotoAtIndex:(NSUInteger)index{
    //  if (self.appDelegate.noconnection) {
    
    //      return FGalleryPhotoSourceTypeLocal;
    //}else{
    
    return FGalleryPhotoSourceTypeNetwork;
    //}
    
}

- (NSString*)photoGallery:(FGalleryViewController *)gallery urlForPhotoSize:(FGalleryPhotoSize)size atIndex:(NSUInteger)index {
    return [networkImages objectAtIndex:index];
    NSDictionary *dict = [networkImages objectAtIndex:index];
    NSString *urlStr = [NSString stringWithFormat:@"http://apps.gadget.mn/photos/"];
    NSString *urlAppend = [urlStr stringByAppendingFormat:@"%@",[dict valueForKey:@"path"]];
    return urlAppend;
}
- (NSString*)photoGallery:(FGalleryViewController*)gallery filePathForPhotoSize:(FGalleryPhotoSize)size atIndex:(NSUInteger)index {
    return [localImages objectAtIndex:index];
}

@end