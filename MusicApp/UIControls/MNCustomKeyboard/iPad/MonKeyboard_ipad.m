//
//  MonKeyboardView.m
//  IPad_MongolianKeyboard
//
//  Created by Gadget Store on 2014-03-11.
//  Copyright (c) 2014 bachgaa. All rights reserved.
//

#import "MonKeyboard_ipad.h"

@interface MonKeyboard_ipad ()
@end

@implementation MonKeyboard_ipad
@synthesize keys;

- (BOOL)enableInputClicksWhenVisible {
    return YES;
}

+ (instancetype)sharedMonKeyboardView {
    static MonKeyboard_ipad *_sharedMonKeyboardView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedMonKeyboardView = [[MonKeyboard_ipad alloc] initWithFrame:CGRectMake(0, 416, 1024, 352)];
        UIColor *backColor = [UIColor colorWithRed:(206.0 / 255.0) green:(209.0 / 255.0) blue:(213.0 / 255.0) alpha: 1];
        _sharedMonKeyboardView.backgroundColor = backColor;
    });
    
    return _sharedMonKeyboardView;
}

- (void)buildKeys {
    int characterIndex = 0;
    
#pragma mark Line 1
    int boundX = 6;
    int boundY = 11;
    for (int i = 0; i<12; i++) {
        
        UIButton *button = nil;
        if (i>=0 && i<=10) {
            button = [self getButton:CGRectMake(boundX, boundY, 70, 75) bgImage:[UIImage imageNamed:@"button_useg.png"] tag:MY_KEY_OTHER title:self.keys[characterIndex++]];
        } else {
            button = [self getButton:CGRectMake(boundX, boundY, 97, 75) bgImage:[UIImage imageNamed:@"mn_button_arilgah.png"] tag:MY_KEY_BACKSPACE title:nil];
        }
        boundX += button.bounds.size.width + 13;
        [self addSubview:button];
    }
    
#pragma mark Line 2
    boundY = 96;
    boundX = 26;
    for (int i = 0; i<12; i++) {
        
        UIButton *button = nil;
        if (i>=0 && i<=10) {
            button = [self getButton:CGRectMake(boundX, boundY, 70, 75) bgImage:[UIImage imageNamed:@"button_useg.png"] tag:MY_KEY_OTHER title:self.keys[characterIndex++]];
        } else {
            button = [self getButton:CGRectMake(boundX, boundY, 78, 75) bgImage:[UIImage imageNamed:@"button_dund"] tag:MY_KEY_ENTER title:@"оруул"];
        }
        boundX += button.bounds.size.width + 13;
        [self addSubview:button];
    }
    
#pragma mark Line 3
    boundX = 6;
    boundY = 181;
    for (int i = 0; i<12; i++) {
        
        UIButton *button = nil;
        if (i>=1 && i<=10) {
            button = [self getButton:CGRectMake(boundX, boundY, 70, 75) bgImage:[UIImage imageNamed:@"button_useg.png"] tag:MY_KEY_OTHER title:self.keys[characterIndex++]];
        } else if (i == 0) {
            button = [self getButton:CGRectMake(boundX, boundY, 70, 75) bgImage:[UIImage imageNamed:@"button_tomruulah_1"] tag:MY_KEY_SHIFT_SMALL title:nil];
        } else if (i == 11) {
            button = [self getButton:CGRectMake(boundX, boundY, 97, 75) bgImage:[UIImage imageNamed:@"button_tomruulah_2"] tag:MY_KEY_SHIFT_LARGE title:nil];
        }
        boundX += button.bounds.size.width + 13;
        [self addSubview:button];
    }
    
#pragma mark Line 4
    boundX = 6;
    boundY = 266;
    for (int i=0; i<=7; i++) {
        
        UIButton *button = nil;
        if (i>=3 && i<=5) {
            button = [self getButton:CGRectMake(boundX, boundY, 70, 75) bgImage:[UIImage imageNamed:@"button_useg.png"] tag:MY_KEY_OTHER title:self.keys[characterIndex++]];
        } else if (i == 0) {
            button = [self getButton:CGRectMake(boundX, boundY, 153, 75) bgImage:[UIImage imageNamed:@"button_dund"] tag:MY_KEY_ENG title:@"En"];
        } else if (i == 2) {
            button = [self getButton:CGRectMake(boundX, boundY, 422, 75) bgImage:[UIImage imageNamed:@"button_space"] tag:MY_KEY_SPACE title:@"Зай"];
        } else if (i == 1) {
            button = [self getButton:CGRectMake(boundX, boundY, 70, 75) bgImage:[UIImage imageNamed:@"button_tom"] tag:MY_KEY_NUMBER title:@"123"];
        } else if (i == 6) {
            button = [self getButton:CGRectMake(boundX, boundY, 77, 75) bgImage:[UIImage imageNamed:@"eng_button_keyboard_77"] tag:MY_KEY_HIDE_KEYBOARD title:nil];
        }
        boundX += button.bounds.size.width + 13;
        [self addSubview:button];
    }
}


- (void)rotate_buildKeys{
    int characterIndex = 0;
    
#pragma mark Line 1
    int boundX = 9;
    int boundY = 10;
    for (int i = 0; i<12; i++) {
        
        UIButton *button = nil;
        if (i>=0 && i<=10) {
            button = [self getButton:CGRectMake(boundX, boundY, 50, 55) bgImage:[UIImage imageNamed:@"button_useg.png"] tag:MY_KEY_OTHER title:self.keys[characterIndex++]];
        } else {
            button = [self getButton:CGRectMake(boundX, boundY, 101, 55) bgImage:[UIImage imageNamed:@"button_arilgah.png"] tag:MY_KEY_BACKSPACE title:nil];
        }
        boundX += button.bounds.size.width + 9;
        [self addSubview:button];
    }
    
#pragma mark Line 2
    boundY = 73;
    boundX = 39;
    for (int i = 0; i<12; i++) {
        
        UIButton *button = nil;
        if (i>=0 && i<=10) {
            button = [self getButton:CGRectMake(boundX, boundY, 50, 55) bgImage:[UIImage imageNamed:@"button_useg.png"] tag:MY_KEY_OTHER title:self.keys[characterIndex++]];
        } else {
            button = [self getButton:CGRectMake(boundX, boundY, 71, 55) bgImage:[UIImage imageNamed:@"button_dund"] tag:MY_KEY_ENTER title:@"оруул"];
        }
        boundX += button.bounds.size.width + 9;
        [self addSubview:button];
    }
    
#pragma mark Line 3
    boundX = 9;
    boundY = 136;
    for (int i = 0; i<12; i++) {
        
        UIButton *button = nil;
        if (i>=1 && i<=10) {
            button = [self getButton:CGRectMake(boundX, boundY, 50, 55) bgImage:[UIImage imageNamed:@"button_useg.png"] tag:MY_KEY_OTHER title:self.keys[characterIndex++]];
        } else if (i == 0) {
            button = [self getButton:CGRectMake(boundX, boundY, 50, 55) bgImage:[UIImage imageNamed:@"button_tomruulah_1"] tag:MY_KEY_SHIFT_SMALL title:nil];
        } else if (i == 11) {
            button = [self getButton:CGRectMake(boundX, boundY, 101, 55) bgImage:[UIImage imageNamed:@"button_tomruulah_2"] tag:MY_KEY_SHIFT_LARGE title:nil];
        }
        boundX += button.bounds.size.width + 9;
        [self addSubview:button];
    }
    
#pragma mark Line 4
    boundX = 9;
    boundY = 199;
    for (int i=0; i<=7; i++) {
        
        UIButton *button = nil;
        if (i>=3 && i<=5) {
            button = [self getButton:CGRectMake(boundX, boundY, 50, 55) bgImage:[UIImage imageNamed:@"button_useg.png"] tag:MY_KEY_OTHER title:self.keys[characterIndex++]];
        } else if (i == 0) {
            button = [self getButton:CGRectMake(boundX, boundY, 109, 55) bgImage:[UIImage imageNamed:@"button_dund"] tag:MY_KEY_ENG title:@"En"];
        } else if (i == 2) {
            button = [self getButton:CGRectMake(boundX, boundY, 328, 55) bgImage:[UIImage imageNamed:@"button_space"] tag:MY_KEY_SPACE title:@"Зай"];
        } else if (i == 1) {
            button = [self getButton:CGRectMake(boundX, boundY, 50, 55) bgImage:[UIImage imageNamed:@"button_tom"] tag:MY_KEY_NUMBER title:@"123"];
        } else if (i == 6) {
            button = [self getButton:CGRectMake(boundX, boundY, 59, 55) bgImage:[UIImage imageNamed:@"eng_button_keyboard_77"] tag:MY_KEY_HIDE_KEYBOARD title:nil];
        }
        boundX += button.bounds.size.width + 9;
        [self addSubview:button];
    }
}


- (void)buttonClicked:(UIButton *)button {
    
    [[UIDevice currentDevice] playInputClick];
    if (button.tag == MY_KEY_OTHER) {
        NSString *character = button.titleLabel.text;
        if (!shifted)
            character = [character lowercaseString];
        [self.textField insertText:character];
        if (shifted) {
            shifted = NO;
            [self syncBuildKeys];
        }
    }
    else if (button.tag == MY_KEY_BACKSPACE) {
        [self backspace];
    }
    else if (button.tag == MY_KEY_ENTER) {
        [[UIDevice currentDevice] playInputClick];
        if ([self.textField isKindOfClass:[UITextView class]])
            [self.textField insertText:@"\n"];
        else {
            [self.textField resignFirstResponder];
        }
    }
    else if (button.tag == MY_KEY_SHIFT_SMALL || button.tag == MY_KEY_SHIFT_LARGE) {
        shifted = !shifted;
        [self syncBuildKeys];
    }
    else if (button.tag == MY_KEY_NUMBER) {
        MY_IPAD_NUM_KYEBOARD.textField = self.textField;
    }
    else if (button.tag == MY_KEY_SPACE) {
        [self.textField insertText:@" "];
    }
    else if (button.tag == MY_KEY_HIDE_KEYBOARD) {
        [self.textField resignFirstResponder];
    }
    else if (button.tag == MY_KEY_ENG) {
        MY_IPAD_ENG_KYEBOARD.textField = self.textField;
    }
}

#pragma mark -
#pragma mark Getters
- (NSArray *)keys {
    if (keys == nil)
    {
        keys = @[@"ф", @"ц", @"у", @"ж", @"э", @"н", @"г", @"ш", @"ү", @"з", @"к", @"й", @"ы", @"б", @"ө", @"а", @"х", @"р", @"о", @"л", @"д", @"п", @"я", @"ч", @"ё", @"с", @"м", @"и", @"т", @"ь", @"в", @"ю",@"ъ", @"е" , @"щ",];
    }
    
    return keys;
}

- (void)refreshFrame {
    [super refreshFrame];
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    {
        if (UIInterfaceOrientationIsPortrait([[NSUserDefaults standardUserDefaults] integerForKey:MY_CURRENT_INTERFACE_ORIENTATION])) {
            [self rotate_buildKeys];
        } else {
            [self buildKeys];
        }
        [self syncBuildKeys];
    }
}





@end
