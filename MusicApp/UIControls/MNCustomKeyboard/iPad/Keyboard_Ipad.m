
//
//  Keyboard_Ipad.m
//  IPad_MongolianKeyboard
//
//  Created by Gadget Store on 2014-03-24.
//  Copyright (c) 2014 bachgaa. All rights reserved.
//

#import "Keyboard_Ipad.h"

@interface Keyboard_Ipad ()
@end

@implementation Keyboard_Ipad
@synthesize keys;
@synthesize textField;

- (BOOL)enableInputClicksWhenVisible {
    return YES;
}

+ (instancetype)sharedKeyboard_IpadView {
    static Keyboard_Ipad *_sharedKeyboardView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedKeyboardView = [[Keyboard_Ipad alloc] initWithFrame:CGRectMake(0, 416, 1024, 352)];
        UIColor *backColor = [UIColor colorWithRed:(206.0 / 255.0) green:(209.0 / 255.0) blue:(213.0 / 255.0) alpha: 1];
        _sharedKeyboardView.backgroundColor = backColor;
    });
    
    return _sharedKeyboardView;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myOrientationChanged) name:MY_ORIENTATION_CHANGED object:nil];
        [self refreshFrame];
        [self syncBuildKeys];
    }
    return self;
}

#pragma mark -
#pragma mark Setters
- (void)setTextField:(id)tf {
    
    if (textField != tf) {
        textField = nil;
        textField = tf;
    }
    [textField setValue:self forKey:@"inputView"];
    [textField reloadInputViews];
}
#pragma mark -
#pragma mark Getters
- (NSArray *)keys {
    return keys;
}

- (NSInteger)OSVersion {
    static NSUInteger _deviceSystemMajorVersion = -1;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _deviceSystemMajorVersion = [[[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."] objectAtIndex:0] intValue];
    });
    return _deviceSystemMajorVersion;
}



#pragma mark -
#pragma mark User
-(void) buildKeys{
    //Portrait Keyboards
}

- (void)rotate_buildKeys {
    //Lanscape Keyboards
}

- (void)syncBuildKeys {
    for (UIView *view in self.subviews) {
        if (view.tag == MY_KEY_OTHER) {
            UIButton *button = (UIButton *)view;
            [button setTitle:[button.titleLabel.text uppercaseString] forState:UIControlStateNormal];
        }
        else if(view.tag == MY_KEY_SHIFT_SMALL){
            UIButton *button = (UIButton *)view;
            if (shifted) {
                [button setBackgroundImage:[UIImage imageNamed:@"eng_button_tomruulah_1_seletion.png"] forState:UIControlStateNormal];
            }
            else{
                [button setBackgroundImage:[UIImage imageNamed:@"button_tomruulah_1.png"] forState:UIControlStateNormal];
            }
        }
        else if(view.tag == MY_KEY_SHIFT_LARGE){
            UIButton *button = (UIButton *)view;
            if (shifted) {
                [button setBackgroundImage:[UIImage imageNamed:@"eng_button_tomruulah_2_seletion.png"] forState:UIControlStateNormal];
            }
            else{
                [button setBackgroundImage:[UIImage imageNamed:@"button_tomruulah_2.png"] forState:UIControlStateNormal];
            }
        }
    }
}

- (UIButton *)getButton:(CGRect)frame bgImage:(UIImage *)bgImage tag:(int)tag title:(NSString *)title {
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    button.tag = tag;
    if ([self OSVersion] < 7) {
        button.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:24.0f];
    } else {
        button.titleLabel.font = [UIFont fontWithName:@"Helvetica Light" size:24.0f];
    }
    [button setTitle:title forState:UIControlStateNormal];
    [button setBackgroundImage:bgImage forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    if (button.tag == MY_KEY_BACKSPACE) {
        [button removeTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
        [button addTarget:self action:@selector(backspaceCancel) forControlEvents:UIControlEventTouchUpInside];
        [button addTarget:self action:@selector(backspaceCancel) forControlEvents:UIControlEventTouchCancel];
        [button addTarget:self action:@selector(backspaceCancel) forControlEvents:UIControlEventTouchUpOutside];
    }
    return button;
}

- (void)refreshFrame {
    
    if (UIInterfaceOrientationIsPortrait([[NSUserDefaults standardUserDefaults] integerForKey:MY_CURRENT_INTERFACE_ORIENTATION])) {
        self.frame = CGRectMake(0, 0, 768, 264);
    } else {
        self.frame = CGRectMake(0, 0, 1024, 352);
    }
}

- (void)myOrientationChanged {
    [self refreshFrame];
}

- (void)buttonClicked:(UIButton *)button{
}

- (void)backspace {
    backing = YES;
    [self.textField deleteBackward];
    [self performSelector:@selector(realBackspace) withObject:nil afterDelay:0.1f];
}
- (void)realBackspace {
    if (backing) {
        [self.textField deleteBackward];
        [self performSelector:@selector(realBackspace) withObject:nil afterDelay:0.1f];
    }
}
- (void)backspaceCancel {
    backing = NO;
}

@end
