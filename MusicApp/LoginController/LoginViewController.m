//
//  RootViewController.m
//  Bold_login
//
//  Created by Gadget Store on 2014-03-27.
//  Copyright (c) 2014 batsukh bachgaa. All rights reserved.
//

#import "LoginViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <float.h>
#import "SWRevealViewController.h"
@interface  LoginViewController()<UITextFieldDelegate>
@end

@implementation LoginViewController{
    UIButton *rememberbutton;
    UIButton *loginBtn;
    UIButton *regBtn;
    UIButton *logoutBtn;
    UIButton *MenuBtn;
    UITextField *password, *username;
    UIImageView *imageView;
    UIView *footerview;
    UIView *membersView;
    BOOL isLogin;
    NSMutableArray *userArray;
       // FXBlurView *blurView;
}

@synthesize proView;
@synthesize nameLabel;
@synthesize statusLabel;
@synthesize profilePictureView;
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
    userArray = [NSMutableArray array];
    if(self){
    NSArray *permissionsArray = @[ @"user_about_me", @"user_relationships", @"user_birthday", @"user_location"];
    // Create a FBLoginView to log the user in with basic, email and friend list permissions
    // You should ALWAYS ask for basic permissions (public_profile) when logging the user in
    FBLoginView *loginView = [[FBLoginView alloc] initWithReadPermissions:permissionsArray];
    // Set this loginUIViewController to be the loginView button's delegate
    loginView.delegate = self;
    
    // Align the button in the center horizontally
    loginView.frame = CGRectOffset(loginView.frame,
                                   (self.view.center.x - (loginView.frame.size.width / 2)),
                                   5);
    
    // Align the button in the center vertically
    loginView.center = self.view.center;
        [ self.view addSubview:loginView];
        [self.proView addSubview:loginView];
    }
    // Add the button to the view
    if (IS_IPHONE_5) {
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];
        imageView.alpha = 0.7;
        imageView.image = [UIImage imageNamed:@"login_background.jpg"];
    } else {
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
         imageView.alpha = 0.7;
        imageView.image = [UIImage imageNamed:@"login_background.jpg"];
    }
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5f].CGColor;
    [self.view addSubview:imageView];

    if (IS_IPHONE_5) {
        footerview = [[UIView alloc] initWithFrame:CGRectMake(0, 300, 320, 268)];
    } else {
        footerview = [[UIView alloc] initWithFrame:CGRectMake(0, 300, 320, 180)];
    }
    footerview.backgroundColor = [UIColor clearColor];
    [self.view addSubview:footerview];
    
    username = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    username.delegate = self;
    username.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    username.font = [UIFont fontWithName:@"Helvetica" size:15.0f];
    username.placeholder = @"Нэрээ оруулна уу";
    username.textAlignment = NSTextAlignmentCenter;
    [footerview addSubview:username];
    
    password = [[UITextField alloc]initWithFrame:CGRectMake(0, 41, 320, 40)];
    password.delegate = self;
    password.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5f];
    password.font = [UIFont fontWithName:@"Helvetica" size:15.0f];
    password.placeholder = @"Нууц үгээ оруулна уу";
    password.textAlignment = NSTextAlignmentCenter;
    password.secureTextEntry = YES;
    [footerview addSubview:password];
    
    {
        loginBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 82, 320, 40)];
        loginBtn.backgroundColor = [UIColor colorWithRed: 0.0/255.0f green:121.0/255.0f blue:220.0/255.0f alpha:1.0];
        [loginBtn setTitle:@"НЭВТРЭХ" forState:UIControlStateNormal];
        [loginBtn addTarget:self action:@selector(loginButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [footerview addSubview:loginBtn];
    }
    
    
    {
        regBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 130, 40, 40)];
        regBtn.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"button_burtguuleh.png"]];
        [regBtn addTarget:self action:@selector(registrationButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [footerview addSubview:regBtn];
    }
    
    {
        rememberbutton = [[UIButton alloc]initWithFrame:CGRectMake(260, 130, 40, 40)];
        rememberbutton.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"button_sanuulah_yes.png"]];
        [rememberbutton addTarget:self action:@selector(rememberButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [footerview addSubview:rememberbutton];
    }
    
    [self syncRememberButton];
    membersView = [[UIView alloc] initWithFrame:CGRectMake(320, 0, 320, 568)];
    membersView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:membersView];
    
    {
        logoutBtn = [[UIButton alloc] initWithFrame:CGRectMake(50, 50, 100, 50)];
        [logoutBtn setTitle:@"Logout" forState:UIControlStateNormal];
        [logoutBtn addTarget:self action:@selector(Logout) forControlEvents:UIControlEventTouchUpInside];
        [membersView addSubview:logoutBtn];
    }
    
    {
        MenuBtn = [[UIButton alloc] initWithFrame:CGRectMake(9, 20, 26, 20)];
        [MenuBtn setBackgroundImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
       // [MenuBtn setTitle:@"Logout" forState:UIControlStateNormal];
    //   [MenuBtn addTarget:self action:@selector(Logout) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:MenuBtn];
    }
    
    [MenuBtn addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    [self.view addSubview:self.proView];
    [self.proView addSubview:self.statusLabel];
    [self.proView addSubview:self.nameLabel];
    [self.proView addSubview:self.profilePictureView];
  
}

-(void)Logout {
    username.text = @"";
    password.text = @"";
    [UIView beginAnimations:@"hah" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.4];
    membersView.frame = CGRectMake(320, 0, 320, 568);
     [UIView commitAnimations];
    isLogin = NO;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:NO forKey:@"LoginStatus"];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
 
    // Listen for keyboard appearances and disappearances
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)keyboardWillShow: (NSNotification *) notif{
    // Do something here
  
    [UIView animateWithDuration:0.3f animations:^{
        imageView.alpha = 0.5f;
        if (IS_IPHONE_5) {
            footerview.frame = CGRectMake(0, 150, 320, 568);
        }
        else {
            footerview.frame = CGRectMake(0, 90, 320, 480);
        }
        
    }];
}

- (void)keyboardWillHide: (NSNotification *) notif{
    // Do something here
    [UIView animateWithDuration:0.3f animations:^{
        imageView.alpha = 1.0;
        footerview.frame = CGRectMake(0, 300, 320, 180);
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[self view] endEditing:YES];
   
    
}


- (void)loginButtonClicked{
    
    if([username.text isEqualToString:@"bayraa"] || [password.text isEqualToString:@"test"]){
        
//       MembersViewController *viewController = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"members"];
//        [self.revealViewController setFrontViewController:viewController animated:YES];
      [[self view] endEditing:YES];
        [UIView beginAnimations:@"hah" context:nil];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.4];
        membersView.frame = CGRectMake(0, 0, 320, 568);
         [UIView commitAnimations];
        isLogin = YES;
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setBool:YES forKey:@"LoginStatus"];
    }else {
   
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Алдаа"
                                                        message:@"Хэрэглэгчийн нэр эсвэл нууц үг буруу байна "
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (void)registrationButtonClicked{
   // RegistrationViewController *registration = [RegistrationViewController new];
  //  [self.navigationController pushViewController:registration animated:YES];
}

- (void)rememberButtonClicked {
    
    [[NSUserDefaults standardUserDefaults] setBool:![[NSUserDefaults standardUserDefaults] boolForKey:@"remember"] forKey:@"remember"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self syncRememberButton];
}

- (void)syncRememberButton {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"remember"])
    {
        rememberbutton.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"button_sanuulah_yes.png"]];
    }
    else
    {
        rememberbutton.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"button_sanuulah_no.png"]];
    }
}


-(UIView *)proView {
    if(proView == nil){
        proView = [[UIView alloc] initWithFrame:CGRectMake(320, 0, 320, 568)];
        proView.backgroundColor = [UIColor whiteColor];
        
    }
    return proView;
}

-(UILabel *)nameLabel {
    if(nameLabel == nil){
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 200, 21)];
        
    }
    return nameLabel;
}

-(UILabel *)statusLabel {
    if(statusLabel == nil){
        statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 200, 200, 21)];
        
    }
    return statusLabel;
}

-(FBProfilePictureView *) profilePictureView
{
    if(profilePictureView == nil){
        profilePictureView = [[FBProfilePictureView alloc] initWithFrame:CGRectMake(86, 135, 50, 50)];
        profilePictureView.backgroundColor = GRAY_COLOR;
        
    }
    return profilePictureView;
}


// This method will be called when the user information has been fetched
- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
   
    
    [self RegisterUser:loginView user:user];
}

-(void)RegisterUser:(FBLoginView *)log user:(id<FBGraphUser>)user{
    profilePictureView.profileID = user.id;
//    self.nameLabel.text = user.name;
//    NSLog(@"Email: %@",user.email);
//    NSLog(@"Birthday: %@",user.birthday);
//    NSLog(@"name: %@",user.name);
//    NSLog(@"male: %@",user.gender);
//    NSLog(@"location: %@",user.location.name);
   NSLog(@"Link: %@",user.link);
//    NSLog(@"firstname: %@",user.first_name);
//    NSLog(@"lastname: %@",user.last_name);
    
    //NSMutableDictionary *eventData = [NSMutableDictionary dictionaryWithObjectsAndKeys:user,@"user", nil];
    NSMutableDictionary *userData  = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *userid  = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *usermail  = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *userfirst  = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *userlast  = [[NSMutableDictionary alloc]init];
    NSArray* fb_id = [user.link componentsSeparatedByString: @"/"];
    NSString* fbpro_id = [fb_id objectAtIndex: 4];

    NSMutableArray *userInfo = [[NSMutableArray alloc]initWithObjects:user.email, user.first_name,user.last_name,user.name, fbpro_id , nil];
    NSMutableArray *userKeys = [[NSMutableArray alloc]initWithObjects:@"mail", @"first",@"last" ,@"data", @"id", nil];
    

    [userData setObject:user.name forKey:@"username"];
    [usermail setObject:user.email forKey:@"mail"];
    [userfirst setObject:user.first_name forKey:@"firstname"];
    [userlast setObject:user.last_name forKey:@"lastname"];
    [userid setObject:user.link forKey:@"fb_id"];
    RequestHelper *helper = [[RequestHelper alloc] init];
    helper.delegate = self;
 //   NSDictionary *postDict = [NSDictionary dictionaryWithObjectsAndKeys: userData,@"data",userid , @"id",userlast,@"last", userfirst,@"first",usermail, @"mail" ,nil];
    NSDictionary *test = [NSDictionary dictionaryWithObjects:userInfo forKeys:userKeys];
    NSString *strResponse = [helper sendSyncRequestWithHost:@"user/RegisterUser" Data:nil withValues:test];
    NSLog(@"RES:%@",strResponse);
    
}

// Implement the loginViewShowingLoggedInUser: delegate method to modify your app's UI for a logged-in user experience
- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    self.statusLabel.text = @"You're logged in as";
    [self.proView addSubview:profilePictureView];
    [UIView beginAnimations:@"hah" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.4];
    proView.frame = CGRectMake(0, 0, 320, 568);
    [UIView commitAnimations];

    
}

// Implement the loginViewShowingLoggedOutUser: delegate method to modify your app's UI for a logged-out user experience
- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    profilePictureView.profileID = nil;
    nameLabel.text = @"";
    statusLabel.text= @"You're not logged in!";
    [self.view addSubview:loginView];
    [UIView beginAnimations:@"hah" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.4];
    proView.frame = CGRectMake(320, 0, 320, 568);
    [UIView commitAnimations];
}

// You need to override loginView:handleError in order to handle possible errors that can occur during login
- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
    NSString *alertMessage, *alertTitle;
    
    // If the user should perform an action outside of you app to recover,
    // the SDK will provide a message for the user, you just need to surface it.
    // This conveniently handles cases like Facebook password change or unverified Facebook accounts.
    if ([FBErrorUtility shouldNotifyUserForError:error]) {
        alertTitle = @"Facebook error";
        alertMessage = [FBErrorUtility userMessageForError:error];
        
        // This code will handle session closures since that happen outside of the app.
        // You can take a look at our error handling guide to know more about it
        // https://developers.facebook.com/docs/ios/errors
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession) {
        alertTitle = @"Session Error";
        alertMessage = @"Your current session is no longer valid. Please log in again.";
        
        // If the user has cancelled a login, we will do nothing.
        // You can also choose to show the user a message if cancelling login will result in
        // the user not being able to complete a task they had initiated in your app
        // (like accessing FB-stored information or posting to Facebook)
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
        NSLog(@"user cancelled login");
        
        // For simplicity, this sample handles other errors with a generic message
        // You can checkout our error handling guide for more detailed information
        // https://developers.facebook.com/docs/ios/errors
    } else {
        alertTitle  = @"Something went wrong";
        alertMessage = @"Please try again later.";
        NSLog(@"Unexpected error:%@", error);
    }
    
    if (alertMessage) {
        [[[UIAlertView alloc] initWithTitle:alertTitle
                                    message:alertMessage
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}




@end
