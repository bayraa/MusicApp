//
//  Keyboard.m
//  IPad_MongolianKeyboard
//
//  Created by Gadget Store on 2014-03-19.
//  Copyright (c) 2014 bachgaa. All rights reserved.
//

#import "Keyboard.h"

enum {
    PKNumberPadViewImageLeft = 0,
    PKNumberPadViewImageInner,
    PKNumberPadViewImageRight,
    PKNumberPadViewImageMax
};

@interface Keyboard ()
@end

@implementation Keyboard
@synthesize textField;
@synthesize keys;
@synthesize buttonArray;

+ (instancetype)sharedKeyboardView {
    static Keyboard *_sharedKeyboardView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedKeyboardView = [[Keyboard alloc] initWithFrame:CGRectMake(0, 264, 320, 216)];
        UIColor *backColor = [UIColor colorWithRed:(206.0 / 255.0) green:(209.0 / 255.0) blue:(213.0 / 255.0) alpha: 1];
        _sharedKeyboardView.backgroundColor = backColor;
    });
    
    return _sharedKeyboardView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        if (IS_IPHONE_5) {
            myBoundX = 52;
        } else {
            myBoundX = 8;
        }
        
        //Custom Keyboard Integration
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


#pragma mark -
#pragma mark User
- (void)buildKeys {
    //Portrait Keyboards
}
- (void)rotate_buildKeys {
    //Lanscape Keyboards
}
- (UIButton *)getButton:(CGRect)frame bgImage:(UIImage *)bgImage tag:(int)tag title:(NSString *)title {
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    button.tag = tag;
    button.titleLabel.font = [UIFont fontWithName:@"Helvetica Light" size:18.0f];
    [button setTitle:title forState:UIControlStateNormal];
    [button setBackgroundImage:bgImage forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    if (button.tag == MY_KEY_OTHER) {
        [button setUserInteractionEnabled:NO];
    }
    if (button.tag == MY_KEY_BACKSPACE) {
        [button removeTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
        [button addTarget:self action:@selector(backspaceCancel) forControlEvents:UIControlEventTouchUpInside];
        [button addTarget:self action:@selector(backspaceCancel) forControlEvents:UIControlEventTouchCancel];
        [button addTarget:self action:@selector(backspaceCancel) forControlEvents:UIControlEventTouchUpOutside];
    }
    return button;
}
- (void)syncBuildKeys {
    for (UIView *view in self.subviews) {
        if (view.tag == MY_KEY_OTHER)
        {
            UIButton *button = (UIButton *)view;
            [button setTitle:[button.titleLabel.text uppercaseString] forState:UIControlStateNormal];
        }
        
        else if(view.tag == MY_KEY_SHIFT_MN1){
            UIButton *button = (UIButton *)view;
            if (shifted) {
                [button setBackgroundImage:[UIImage imageNamed:@"shift23x35"] forState:UIControlStateNormal];
            }
            else{
                [button setBackgroundImage:[UIImage imageNamed:@"shift_23x35"] forState:UIControlStateNormal];
            }
        }
        
        else if(view.tag == MY_kEY_SHIFT_MN2){
            UIButton *button = (UIButton *)view;
            if (shifted) {
                [button setBackgroundImage:[UIImage imageNamed:@"shift38x26"] forState:UIControlStateNormal];
            }
            else{
                [button setBackgroundImage:[UIImage imageNamed:@"shift_38x26"] forState:UIControlStateNormal];
            }
        }
        
        else if(view.tag == MY_KEY_SHIFT_EN1){
            UIButton *button = (UIButton *)view;
            if (shifted) {
                [button setBackgroundImage:[UIImage imageNamed:@"shift30x41"] forState:UIControlStateNormal];
            }
            else{
                [button setBackgroundImage:[UIImage imageNamed:@"shift_30x41"] forState:UIControlStateNormal];
            }
        }
        
        else if(view.tag == MY_KEY_SHIFT_EN2){
            UIButton *button = (UIButton *)view;
            if (shifted) {
                [button setBackgroundImage:[UIImage imageNamed:@"shift60x31"] forState:UIControlStateNormal];
            }
            else{
                [button setBackgroundImage:[UIImage imageNamed:@"shift_60x31"] forState:UIControlStateNormal];
            }
        }
    }
}
- (void)myOrientationChanged {
    [self refreshFrame];
}

- (void)refreshFrame {
    
    if (UIInterfaceOrientationIsLandscape([[NSUserDefaults standardUserDefaults] integerForKey:MY_CURRENT_INTERFACE_ORIENTATION])) {
        isrotate = YES;
        if (!IS_IPHONE_5) {
            self.frame = CGRectMake(0, 0, 480, 162);
        } else {
            self.frame = CGRectMake(0, 0, 568, 162);
        }
    } else if (UIInterfaceOrientationIsPortrait([[NSUserDefaults standardUserDefaults] integerForKey:MY_CURRENT_INTERFACE_ORIENTATION])) {
        isrotate = NO;
        self.frame = CGRectMake(0, 0, 320, 216);
    } else {
        NSLog(@"ORIENATION ERROR");
        exit(1);
    }
    [self.textField reloadInputViews];
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

#pragma mark -
#pragma mark - UIActions
- (void)buttonClicked:(UIButton *)button {
    //
}

#pragma mark - 
#pragma mark - Touches
- (void)touchesBegan: (NSSet *)touches withEvent: (UIEvent *)event {
    
    CGPoint location = [[touches anyObject] locationInView:self];
    [super touchesBegan:touches withEvent:event];
    [self.nextResponder touchesBegan:touches withEvent:event];
    
    BOOL clicked = NO;
    for (UIView *view in self.buttonArray) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)view;
            if ([button subviews].count > 2) {
                [[[button subviews] objectAtIndex:2] removeFromSuperview];
            }
            if(CGRectContainsPoint(CGRectMake(button.frame.origin.x-5, button.frame.origin.y-5, button.frame.size.width+10, button.frame.size.height+10), location) && !clicked)
            {
                clicked = YES;
                [self addPopupToButton:button];
            }
        }
        
    }
}

- (void)addPopupToButton:(UIButton *)b {
    
    UIImageView *keyPop;
    UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 52, 60)];
    
    if (b == [self.buttonArray objectAtIndex:0] ) {
        if (isrotate ==  YES) {
            keyPop = [[UIImageView alloc] initWithImage:[UIImage imageWithCGImage:[self createKeytopImageWithKind:PKNumberPadViewImageRight] scale:[[UIScreen mainScreen] scale] orientation:UIImageOrientationDown]];
            keyPop.frame = CGRectMake(-18, -80, keyPop.frame.size.width+30, keyPop.frame.size.height-15);
            text.frame = CGRectMake(27, 10, 52, 60);
        }else{
            keyPop = [[UIImageView alloc] initWithImage:[UIImage imageWithCGImage:[self createKeytopImageWithKind:PKNumberPadViewImageRight] scale:[[UIScreen mainScreen] scale] orientation:UIImageOrientationDown]];
            keyPop.frame = CGRectMake(-13, -72, keyPop.frame.size.width-4, keyPop.frame.size.height-9);
            text.frame = CGRectMake(13, 10, 52, 60);
        }
    }
    else if (b == [self.buttonArray objectAtIndex:9] ) {
        if (isrotate == YES) {
            keyPop = [[UIImageView alloc] initWithImage:[UIImage imageWithCGImage:[self createKeytopImageWithKind:PKNumberPadViewImageLeft] scale:[[UIScreen mainScreen] scale] orientation:UIImageOrientationDown]];
            keyPop.frame = CGRectMake(-48, -80, keyPop.frame.size.width+30, keyPop.frame.size.height-15);
            text.frame = CGRectMake(27, 10, 52, 60);
        }else{
            keyPop = [[UIImageView alloc] initWithImage:[UIImage imageWithCGImage:[self createKeytopImageWithKind:PKNumberPadViewImageLeft] scale:[[UIScreen mainScreen] scale] orientation:UIImageOrientationDown]];
            keyPop.frame = CGRectMake(-34, -72, keyPop.frame.size.width-4, keyPop.frame.size.height-9);
            text.frame = CGRectMake(13, 10, 52, 60);
        }
    }
    else {
        if (isrotate == YES) {
            keyPop = [[UIImageView alloc] initWithImage:[UIImage imageWithCGImage:[self createKeytopImageWithKind:PKNumberPadViewImageInner] scale:[[UIScreen mainScreen] scale] orientation:UIImageOrientationDown]];
            keyPop.frame = CGRectMake(-33, -80, keyPop.frame.size.width+30, keyPop.frame.size.height-15);
            text.frame = CGRectMake(28, 10, 52, 60);
        }else{
            keyPop = [[UIImageView alloc] initWithImage:[UIImage imageWithCGImage:[self createKeytopImageWithKind:PKNumberPadViewImageInner] scale:[[UIScreen mainScreen] scale] orientation:UIImageOrientationDown]];
            keyPop.frame = CGRectMake(-25, -72, keyPop.frame.size.width, keyPop.frame.size.height-9);
            text.frame = CGRectMake(13, 10, 52, 60);

        }
    }
    
    [text setFont:[UIFont boldSystemFontOfSize:44]];
    [text setTextAlignment:NSTextAlignmentCenter];
    [text setBackgroundColor:[UIColor clearColor]];
    [text setShadowColor:[UIColor whiteColor]];
    [text setText:b.titleLabel.text];
    
    keyPop.layer.shadowColor = [UIColor colorWithWhite:0.1 alpha:1.0].CGColor;
    keyPop.layer.shadowOffset = CGSizeMake(0, 3.0);
    keyPop.layer.shadowOpacity = 1;
    keyPop.layer.shadowRadius = 5.0;
    keyPop.clipsToBounds = NO;
    [keyPop addSubview:text];
    [b addSubview:keyPop];
    [self bringSubviewToFront:b];
}

-(void)touchesMoved: (NSSet *)touches withEvent: (UIEvent *)event {
    
    CGPoint location = [[touches anyObject] locationInView:self];
    
    BOOL clicked = NO;
    for (UIButton *button in self.buttonArray) {
        if ([button subviews].count > 2) {
            [[[button subviews] objectAtIndex:2] removeFromSuperview];
        }
        if(CGRectContainsPoint(CGRectMake(button.frame.origin.x-5, button.frame.origin.y-5, button.frame.size.width+10, button.frame.size.height+10), location) && !clicked)
        {
            clicked = YES;
            [self addPopupToButton:button];
        }
    }
    
}

-(void) touchesEnded: (NSSet *)touches withEvent: (UIEvent *)event{
    CGPoint location = [[touches anyObject] locationInView:self];
    
    BOOL clicked = NO;
    for (UIButton *button in self.buttonArray) {
        if ([button subviews].count > 2) {
            [[[button subviews] objectAtIndex:2] removeFromSuperview];
        }
        if(CGRectContainsPoint(CGRectMake(button.frame.origin.x-5, button.frame.origin.y-5, button.frame.size.width+10, button.frame.size.height+10), location) && !clicked)
        {
            clicked = YES;
            [self buttonClicked:button];
        }
    }
    
    backing = NO;
}

#pragma mark - 
#pragma mark - UIViewController
- (BOOL)enableInputClicksWhenVisible {
    return YES;
}

#pragma mark -
#pragma mark Other

#define _UPPER_WIDTH   (52.0 * [[UIScreen mainScreen] scale])
#define _LOWER_WIDTH   (30.0 * [[UIScreen mainScreen] scale])

#define _PAN_UPPER_RADIUS  (6.0 * [[UIScreen mainScreen] scale])
#define _PAN_LOWER_RADIUS  (3.0 * [[UIScreen mainScreen] scale])

#define _PAN_UPPDER_WIDTH   (_UPPER_WIDTH-_PAN_UPPER_RADIUS*2)
#define _PAN_UPPER_HEIGHT    (60.0 * [[UIScreen mainScreen] scale])

#define _PAN_LOWER_WIDTH     (_LOWER_WIDTH-_PAN_LOWER_RADIUS*2-3)
#define _PAN_LOWER_HEIGHT    (40.0 * [[UIScreen mainScreen] scale])+5

#define _PAN_UL_WIDTH        ((_UPPER_WIDTH-_LOWER_WIDTH)/2)

#define _PAN_MIDDLE_HEIGHT    (11.0 * [[UIScreen mainScreen] scale])

#define _PAN_CURVE_SIZE      (7.0 * [[UIScreen mainScreen] scale])

#define _PADDING_X     (13 * [[UIScreen mainScreen] scale])
#define _PADDING_Y     (10 * [[UIScreen mainScreen] scale])
#define _WIDTH   (_UPPER_WIDTH + _PADDING_X*2)
#define _HEIGHT   (_PAN_UPPER_HEIGHT + _PAN_MIDDLE_HEIGHT + _PAN_LOWER_HEIGHT + _PADDING_Y*2)


#define _OFFSET_X    -25 * [[UIScreen mainScreen] scale])
#define _OFFSET_Y    59 * [[UIScreen mainScreen] scale])


- (CGImageRef)createKeytopImageWithKind:(int)kind
{
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPoint p = CGPointMake(_PADDING_X, _PADDING_Y);
    CGPoint p1 = CGPointZero;
    CGPoint p2 = CGPointZero;
    
    p.x += _PAN_UPPER_RADIUS;
    CGPathMoveToPoint(path, NULL, p.x, p.y);
    
    p.x += _PAN_UPPDER_WIDTH;
    CGPathAddLineToPoint(path, NULL, p.x, p.y);
    
    p.y += _PAN_UPPER_RADIUS;
    CGPathAddArc(path, NULL,
                 p.x, p.y,
                 _PAN_UPPER_RADIUS,
                 3.0*M_PI/2.0,
                 4.0*M_PI/2.0,
                 false);
    
    p.x += _PAN_UPPER_RADIUS;
    p.y += _PAN_UPPER_HEIGHT - _PAN_UPPER_RADIUS - _PAN_CURVE_SIZE;
    CGPathAddLineToPoint(path, NULL, p.x, p.y);
    
    p1 = CGPointMake(p.x, p.y + _PAN_CURVE_SIZE);
    switch (kind) {
        case PKNumberPadViewImageLeft:
            p.x -= _PAN_UL_WIDTH*2;
            break;
            
        case PKNumberPadViewImageInner:
            p.x -= _PAN_UL_WIDTH;
            break;
            
        case PKNumberPadViewImageRight:
            break;
    }
    
    p.y += _PAN_MIDDLE_HEIGHT + _PAN_CURVE_SIZE*2;
    p2 = CGPointMake(p.x, p.y - _PAN_CURVE_SIZE);
    CGPathAddCurveToPoint(path, NULL,
                          p1.x, p1.y,
                          p2.x, p2.y,
                          p.x, p.y);
    
    p.y += _PAN_LOWER_HEIGHT - _PAN_CURVE_SIZE - _PAN_LOWER_RADIUS;
    CGPathAddLineToPoint(path, NULL, p.x, p.y);
    
    p.x -= _PAN_LOWER_RADIUS;
    CGPathAddArc(path, NULL,
                 p.x, p.y,
                 _PAN_LOWER_RADIUS,
                 4.0*M_PI/2.0,
                 1.0*M_PI/2.0,
                 false);
    
    p.x -= _PAN_LOWER_WIDTH;
    p.y += _PAN_LOWER_RADIUS;
    CGPathAddLineToPoint(path, NULL, p.x, p.y);
    
    p.y -= _PAN_LOWER_RADIUS;
    CGPathAddArc(path, NULL,
                 p.x, p.y,
                 _PAN_LOWER_RADIUS,
                 1.0*M_PI/2.0,
                 2.0*M_PI/2.0,
                 false);
    
    p.x -= _PAN_LOWER_RADIUS;
    p.y -= _PAN_LOWER_HEIGHT - _PAN_LOWER_RADIUS - _PAN_CURVE_SIZE;
    CGPathAddLineToPoint(path, NULL, p.x, p.y);
    
    p1 = CGPointMake(p.x, p.y - _PAN_CURVE_SIZE);
    
    switch (kind) {
        case PKNumberPadViewImageLeft:
            break;
            
        case PKNumberPadViewImageInner:
            p.x -= _PAN_UL_WIDTH;
            break;
            
        case PKNumberPadViewImageRight:
            p.x -= _PAN_UL_WIDTH*2;
            break;
    }
    
    p.y -= _PAN_MIDDLE_HEIGHT + _PAN_CURVE_SIZE*2;
    p2 = CGPointMake(p.x, p.y + _PAN_CURVE_SIZE);
    CGPathAddCurveToPoint(path, NULL,
                          p1.x, p1.y,
                          p2.x, p2.y,
                          p.x, p.y);
    
    p.y -= _PAN_UPPER_HEIGHT - _PAN_UPPER_RADIUS - _PAN_CURVE_SIZE;
    CGPathAddLineToPoint(path, NULL, p.x, p.y);
    
    p.x += _PAN_UPPER_RADIUS;
    CGPathAddArc(path, NULL,
                 p.x, p.y,
                 _PAN_UPPER_RADIUS,
                 2.0*M_PI/2.0,
                 3.0*M_PI/2.0,
                 false);
    //----
    CGContextRef context;
    UIGraphicsBeginImageContext(CGSizeMake(_WIDTH,
                                           _HEIGHT));
    context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0.0, _HEIGHT);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextAddPath(context, path);
    CGContextClip(context);
    
    //----
    
    // draw gradient
    //    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceGray();
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceGray();
    CGFloat components[] = {
        1.0f, 1.0f,
        1.0f, 1.0f,
        1.0f, 1.0f,
        1.0f, 1.0f};
    
    size_t count = sizeof(components)/ (sizeof(CGFloat)* 2);
    
    CGRect frame = CGPathGetBoundingBox(path);
    CGPoint startPoint = frame.origin;
    CGPoint endPoint = frame.origin;
    endPoint.y = frame.origin.y + frame.size.height;
    
    CGGradientRef gradientRef =
    CGGradientCreateWithColorComponents(colorSpaceRef, components, NULL, count);
    
    CGContextDrawLinearGradient(context,
                                gradientRef,
                                startPoint,
                                endPoint,
                                kCGGradientDrawsAfterEndLocation);
    
    CGGradientRelease(gradientRef);
    CGColorSpaceRelease(colorSpaceRef);
    
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    UIGraphicsEndImageContext();
    
    CFRelease(path);
    
    return imageRef;
}


@end

