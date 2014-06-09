//
//  MnKeyboard_iphone.h
//  IPad_MongolianKeyboard
//
//  Created by Gadget Store on 2014-03-19.
//  Copyright (c) 2014 bachgaa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Keyboard.h"


@interface MnKeyboard_iphone : Keyboard <UIInputViewAudioFeedback,UIGestureRecognizerDelegate>{
  
}

+(instancetype) sharedMnKeyboard;

@end