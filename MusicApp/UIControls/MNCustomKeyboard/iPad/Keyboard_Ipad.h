//
//  Keyboard_Ipad.h
//  IPad_MongolianKeyboard
//
//  Created by Gadget Store on 2014-03-24.
//  Copyright (c) 2014 bachgaa. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MY_KEY_OTHER           0
#define MY_KEY_BACKSPACE       1
#define MY_KEY_ENTER           2
#define MY_KEY_SHIFT_SMALL     3
#define MY_KEY_NUMBER          4
#define MY_KEY_SPACE           5
#define MY_KEY_HIDE_KEYBOARD   6
#define MY_KEY_MN              7
#define MY_KEY_ENG             8
#define MY_KEY_SYMBOL          9
#define MY_KEY_UNDO            10
#define MY_KEY_SHIFT_LARGE     11
#define MY_KEY_EMPTY           12

@interface Keyboard_Ipad : UIView <UIInputViewAudioFeedback> {
    BOOL shifted;
    
    BOOL backing;
}

+ (instancetype)sharedKeyboard_IpadView;

@property (strong, nonatomic) NSArray *keys;
@property (strong, nonatomic) id textField;
- (NSInteger)OSVersion;
- (void)buildKeys;
- (void)rotate_buildKeys;
- (void)buttonClicked:(UIButton *)button;
- (void)syncBuildKeys;
- (void)refreshFrame;
- (UIButton *)getButton:(CGRect)frame bgImage:(UIImage *)bgImage tag:(int)tag title:(NSString *)title;

- (void)backspace;

@end
