//
//  MNCustomKeyboard.h
//  MNCustomKeyboard
//
//  Created by Sodtseren Enkhee on 3/15/14.
//  Copyright (c) 2014 Sodtseren Enkhee. All rights reserved.
//

#import "MonKeyboard_ipad.h"
#import "EngKeyboard_ipad.h"
#import "SymbolKeyboard_ipad.h"
#import "NumberKeyboard_ipad.h"

#import "NumKeyboard_iphone.h"
#import "SymbolKeyboard_iphone.h"
#import "MnKeyboard_iphone.h"
#import "EnKeyboard_iphone.h"

#define MY_IPAD_MON_KEYBOARD [MonKeyboard_ipad sharedMonKeyboardView]
#define MY_IPAD_NUM_KYEBOARD [NumberKeyboard_ipad sharedNumberKeyboardView]
#define MY_IPAD_ENG_KYEBOARD [EngKeyboard_ipad sharedEngKeyboardView]
#define MY_IPAD_SYMBOL_KEYBOARD [SymbolKeyboard_ipad sharedSymbolKeyboardView]

#define MY_IPHONE_NUM_KEYBOARD [NumKeyboard_iphone sharedNumKeyboardView]
#define MY_IPHONE_EN_KEYBOARD  [EnKeyboard_iphone sharedEnKeyboardView]
#define MY_IPHONE_MN_KEYBOARD  [MnKeyboard_iphone sharedMnKeyboard]
#define MY_IPHONE_SYMBOL_KEYBOARD [SymbolKeyboard_iphone sharedSymbolKeyboardView]

#define MY_ORIENTATION_CHANGED              @"myOrientationChanged"
#define MY_CURRENT_INTERFACE_ORIENTATION    @"myCurrentInterfaceOrientation"
#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )