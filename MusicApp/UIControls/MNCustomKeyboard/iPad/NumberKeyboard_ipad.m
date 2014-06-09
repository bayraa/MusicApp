//
//  NumberKeyboardView.m
//  IPad_MongolianKeyboard
//
//  Created by Gadget Store on 2014-03-12.
//  Copyright (c) 2014 bachgaa. All rights reserved.
//

#import "NumberKeyboard_ipad.h"
#import "SymbolKeyboard_ipad.h"

@interface NumberKeyboard_ipad ()

@end

@implementation NumberKeyboard_ipad
@synthesize keys;

- (BOOL)enableInputClicksWhenVisible {
    return YES;
}

+ (instancetype)sharedNumberKeyboardView {
    static NumberKeyboard_ipad *_sharedNumberKeyboardView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedNumberKeyboardView = [[NumberKeyboard_ipad alloc] initWithFrame:CGRectMake(0, 416, 1024, 352)];
        UIColor *backColor = [UIColor colorWithRed:(206.0 / 255.0) green:(209.0 / 255.0) blue:(213.0 / 255.0) alpha: 1];
        _sharedNumberKeyboardView.backgroundColor = backColor;
    });
    
    return _sharedNumberKeyboardView;
}

- (void)buildKeys {
    int characterIndex = 0;
    
#pragma mark Line 1
    int boundX = 6;
    int boundY = 11;
    for (int i = 0; i<11; i++) {
        
        UIButton *button = nil;
        if (i>=0 && i<=9) {
            button = [self getButton:CGRectMake(boundX, boundY, 80, 75) bgImage:[UIImage imageNamed:@"eng_button_useg_77.png"] tag:MY_KEY_OTHER title:self.keys[characterIndex++]];
        } else {
            button = [self getButton:CGRectMake(boundX, boundY, 80, 75) bgImage:[UIImage imageNamed:@"eng_button_arilgah"] tag:MY_KEY_BACKSPACE title:@""];
        }
        boundX += button.bounds.size.width + 13;
        [self addSubview:button];
    }
    
#pragma mark Line 2
    boundY = 96;
    boundX = 47;
    for (int i = 0; i<10; i++) {
        
        UIButton *button = nil;
        if (i>=0 && i<=8) {
            button = [self getButton:CGRectMake(boundX, boundY, 80, 75) bgImage:[UIImage imageNamed:@"eng_button_useg_77"] tag:MY_KEY_OTHER title:self.keys[characterIndex++]];
        } else {
            button = [self getButton:CGRectMake(boundX, boundY, 133, 75) bgImage:[UIImage imageNamed:@"eng_button_dund_133"] tag:MY_KEY_ENTER title:@"return"];
        }
        boundX += button.bounds.size.width + 13;
        [self addSubview:button];
    }
    
#pragma mark Line 3
    boundX = 6;
    boundY = 181;
    for (int i = 0; i<10; i++) {
        
        UIButton *button = nil;
        if (i>=2 && i<=8) {
            button = [self getButton:CGRectMake(boundX, boundY, 77, 75) bgImage:[UIImage imageNamed:@"eng_button_useg_77"] tag:MY_KEY_OTHER title:self.keys[characterIndex++]];
        } else if (i == 0) {
            button = [self getButton:CGRectMake(boundX, boundY, 77, 75) bgImage:[UIImage imageNamed:@"eng_button_dund_77"] tag:MY_KEY_SYMBOL title:@"#+="];
        } else if (i == 1) {
            button = [self getButton:CGRectMake(boundX, boundY, 167, 75) bgImage:[UIImage imageNamed:@"eng_button_useg_77"] tag:MY_KEY_UNDO title:@"undo"];
        } else if (i == 9) {
            button = [self getButton:CGRectMake(boundX, boundY, 110, 75) bgImage:[UIImage imageNamed:@"eng_button_dund_110.png"] tag:MY_KEY_SYMBOL title:@"#+="];
        } boundX += button.bounds.size.width + 13;
        [self addSubview:button];
    }
    
#pragma mark Line 4
    boundX = 6;
    boundY = 266;
    for (int i=0; i<=3; i++) {
        UIButton *button = nil;
        if (i == 0) {
            button = [self getButton:CGRectMake(boundX, boundY, 167, 75) bgImage:[UIImage imageNamed:@"eng_button_dund_77"] tag:MY_KEY_ENG title:@"En"];
        } else if (i == 1) {
            button = [self getButton:CGRectMake(boundX, boundY, 617, 75) bgImage:[UIImage imageNamed:@"eng_button_dund_529"] tag:MY_KEY_SPACE title:@"Space"];
        } else if (i == 2) {
            button = [self getButton:CGRectMake(boundX, boundY, 110, 75) bgImage:[UIImage imageNamed:@"eng_button_dund_77"] tag:MY_KEY_MN title:@"Mn"];
        } else if (i == 3) {
            button = [self getButton:CGRectMake(boundX, boundY, 77, 75) bgImage:[UIImage imageNamed:@"eng_button_keyboard_77"] tag:MY_KEY_HIDE_KEYBOARD title:nil];
        }
        boundX += button.bounds.size.width + 13;
        [self addSubview:button];
    }
}

- (void)rotate_buildKeys {
    int characterIndex = 0;
    
#pragma mark Line 1
    int boundX = 9;
    int boundY = 10;
    for (int i = 0; i<11; i++) {
        
        UIButton *button = nil;
        if (i>=0 && i<=9) {
            button = [self getButton:CGRectMake(boundX, boundY, 60, 55) bgImage:[UIImage imageNamed:@"eng_button_useg_77.png"] tag:MY_KEY_OTHER title:self.keys[characterIndex++]];
        } else {
            button = [self getButton:CGRectMake(boundX, boundY, 60, 55) bgImage:[UIImage imageNamed:@"eng_button_arilgah"] tag:MY_KEY_BACKSPACE title:@""];
        }
        boundX += button.bounds.size.width + 9;
        [self addSubview:button];
    }
    
#pragma mark Line 2
    boundY = 73;
    boundX = 39;
    for (int i = 0; i<10; i++) {
        
        UIButton *button = nil;
        if (i>=0 && i<=8) {
            button = [self getButton:CGRectMake(boundX, boundY, 60, 55) bgImage:[UIImage imageNamed:@"eng_button_useg_77"] tag:MY_KEY_OTHER title:self.keys[characterIndex++]];
        } else {
            button = [self getButton:CGRectMake(boundX, boundY, 99, 55) bgImage:[UIImage imageNamed:@"eng_button_dund_133"] tag:MY_KEY_ENTER title:@"return"];
        }
        boundX += button.bounds.size.width + 9;
        [self addSubview:button];
    }
    
#pragma mark Line 3
    boundX = 9;
    boundY = 136;
    for (int i = 0; i<10; i++) {
        
        UIButton *button = nil;
        if (i>=2 && i<=8) {
            button = [self getButton:CGRectMake(boundX, boundY, 59, 55) bgImage:[UIImage imageNamed:@"eng_button_useg_77"] tag:MY_KEY_OTHER title:self.keys[characterIndex++]];
        } else if (i == 0) {
            button = [self getButton:CGRectMake(boundX, boundY, 59, 55) bgImage:[UIImage imageNamed:@"eng_button_dund_77"] tag:MY_KEY_SYMBOL title:@"#+="];
        } else if (i == 1) {
            button = [self getButton:CGRectMake(boundX, boundY, 127, 55) bgImage:[UIImage imageNamed:@"eng_button_useg_77"] tag:MY_KEY_UNDO title:@"undo"];
        } else if (i == 9) {
            button = [self getButton:CGRectMake(boundX, boundY, 70, 55) bgImage:[UIImage imageNamed:@"eng_button_dund_110.png"] tag:MY_KEY_SYMBOL title:@"#+="];
        }
        boundX += button.bounds.size.width + 9;
        [self addSubview:button];
    }
    
#pragma mark Line 4
    boundX = 9;
    boundY = 199;
    for (int i=0; i<=6; i++) {
        UIButton *button = nil;
        if (i == 0) {
            button = [self getButton:CGRectMake(boundX, boundY, 127, 55) bgImage:[UIImage imageNamed:@"eng_button_dund_77"] tag:MY_KEY_ENG title:@"En"];
        } else if (i == 1) {
            button = [self getButton:CGRectMake(boundX, boundY, 467, 55) bgImage:[UIImage imageNamed:@"eng_button_dund_77"] tag:MY_KEY_SPACE title:@"Space"];
        } else if (i == 2) {
            button = [self getButton:CGRectMake(boundX, boundY, 70, 55) bgImage:[UIImage imageNamed:@"eng_button_dund_77"] tag:MY_KEY_MN title:@"Mn"];
        } else if (i == 3) {
            button = [self getButton:CGRectMake(boundX, boundY, 59, 55) bgImage:[UIImage imageNamed:@"eng_button_keyboard_77"] tag:MY_KEY_HIDE_KEYBOARD title:@""];
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
        if ([self.textField isKindOfClass:[UITextView class]])
            [self.textField insertText:@"\n"];
        else {
            [self.textField resignFirstResponder];
        }
    }
    else if (button.tag == MY_KEY_SHIFT_LARGE || button.tag == MY_KEY_SHIFT_SMALL) {
        shifted = !shifted;
        [self syncBuildKeys];
    }
    
    else if (button.tag == MY_KEY_SPACE) {
        [self.textField insertText:@" "];
    }
    else if (button.tag == MY_KEY_HIDE_KEYBOARD) {
        [self.textField resignFirstResponder];
    }
    else if (button.tag == MY_KEY_MN) {
        MY_IPAD_MON_KEYBOARD.textField = self.textField;
    }
    else if (button.tag == MY_KEY_ENG) {
        MY_IPAD_ENG_KYEBOARD.textField = self.textField;
    }
    else if (button.tag == MY_KEY_SYMBOL) {
        MY_IPAD_SYMBOL_KEYBOARD.textField = self.textField;
    }
    else if (button.tag == MY_KEY_UNDO) {
        [self.textField setValue:@"" forKey:@"text"];
    }
    
}



#pragma mark -
#pragma mark Getters
-(NSArray *)keys {
    [super keys];
    keys = @[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"0", @"-", @"/", @":", @";", @"(", @")", @"$", @"&", @"@", @".", @",", @"?", @"!", @"'", @"''", @"₮", @"", @"",@"", @"", @"", @"", @"", @"", @""];
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
