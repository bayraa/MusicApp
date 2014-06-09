//
//  Keyboard.h
//  IPad_MongolianKeyboard
//
//  Created by Gadget Store on 2014-03-19.
//  Copyright (c) 2014 bachgaa. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MY_KEY_OTHER           0
#define MY_KEY_BACKSPACE       1
#define MY_KEY_ENTER           2

#define MY_KEY_SHIFT_MN1       3
#define MY_kEY_SHIFT_MN2       11
#define MY_KEY_SHIFT_EN1       12
#define MY_KEY_SHIFT_EN2       13

#define MY_KEY_NUMBER          4
#define MY_KEY_SPACE           5
#define MY_KEY_HIDE_KEYBOARD   6
#define MY_KEY_MN              7
#define MY_KEY_ENG             8
#define MY_KEY_SYMBOL          9
#define MY_KEY_UNDO            10


@interface Keyboard : UIView <UIInputViewAudioFeedback,UIGestureRecognizerDelegate> {
    BOOL shifted;
    BOOL isrotate;
    int myBoundX;
    
    BOOL backing;
}

+ (instancetype)sharedKeyboardView;

@property (strong, nonatomic) id textField;
@property (strong, nonatomic) NSArray *keys;
@property (strong, nonatomic) UIView *frameView;
@property (strong, nonatomic) NSMutableArray *buttonArray;

- (void)buildKeys;
- (void)buttonClicked:(UIButton *)button;
- (void)syncBuildKeys;
- (void)refreshFrame;
- (UIButton *)getButton:(CGRect)frame bgImage:(UIImage *)bgImage tag:(int)tag title:(NSString *)title;
- (void)addPopupToButton:(UIButton *)b;
- (void)rotate_buildKeys;

- (void)backspace;

@end


