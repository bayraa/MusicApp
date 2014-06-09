//
//  MnKeyboard_iphone.m
//  IPad_MongolianKeyboard
//
//  Created by Gadget Store on 2014-03-19.
//  Copyright (c) 2014 bachgaa. All rights reserved.
//

#import "MnKeyboard_iphone.h"

enum {
    PKNumberPadViewImageLeft = 0,
    PKNumberPadViewImageInner,
    PKNumberPadViewImageRight,
    PKNumberPadViewImageMax
};

@interface MnKeyboard_iphone (){
}
@end

@implementation MnKeyboard_iphone
@synthesize keys;
@synthesize buttonArray;


+ (instancetype)sharedMnKeyboard {
    static MnKeyboard_iphone *_sharedKeyboard = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedKeyboard = [[MnKeyboard_iphone alloc] initWithFrame:CGRectMake(0, 264, 320, 216)];
        UIColor *backColor = [UIColor colorWithRed:(206.0 / 255.0) green:(209.0 / 255.0) blue:(213.0 / 255.0) alpha: 1];
        _sharedKeyboard.backgroundColor = backColor;
    });
    return _sharedKeyboard;
}

- (void)buildKeys {
    
    int characterIndex = 0;
    buttonArray = [NSMutableArray array];
    
#pragma mark Line 1
    int boundX = 3;
    int boundY = 9;
    for (int i = 0; i<11; i++) {
        
        UIButton *button = nil;
        button = [self getButton:CGRectMake(boundX, boundY, 24, 35) bgImage:[UIImage imageNamed:@"button_useg_23x35.png"] tag:MY_KEY_OTHER title:[self.keys[characterIndex++] uppercaseString]];
        boundX += button.bounds.size.width + 5;
        [buttonArray addObject:button];
        [self addSubview:button];
    }
    
#pragma mark Line 2
    boundY = 51;
    boundX = 3;
    for (int i = 0; i<11; i++) {
        
        UIButton *button = nil;
        button = [self getButton:CGRectMake(boundX, boundY, 24, 35) bgImage:[UIImage imageNamed:@"button_useg_23x35.png"] tag:MY_KEY_OTHER title:[self.keys[characterIndex++] uppercaseString]];
        boundX += button.bounds.size.width + 5;
        [buttonArray addObject:button];
        [self addSubview:button];
    }
    
#pragma mark Line 3
    boundY = 93;
    boundX = 18;
    for (int i = 0; i<10; i++) {
        
        UIButton *button = nil;
        button = [self getButton:CGRectMake(boundX, boundY, 24, 35) bgImage:[UIImage imageNamed:@"button_useg_23x35.png"] tag:MY_KEY_OTHER title:[self.keys[characterIndex++] uppercaseString]];
        boundX += button.bounds.size.width + 5;
        [buttonArray addObject:button];
        [self addSubview:button];
    }
    
#pragma mark Line 4
    boundX = 3;
    boundY = 135;
    for (int i = 0; i<10; i++) {
        
        UIButton *button = nil;
        if (i>=1 && i<9) {
            button = [self getButton:CGRectMake(boundX, boundY, 24, 35) bgImage:[UIImage imageNamed:@"button_useg_23x35.png"] tag:MY_KEY_OTHER title:[self.keys[characterIndex++] uppercaseString]];
            [buttonArray addObject:button];
            boundX += button.bounds.size.width + 5;
        } else if (i == 0) {
            button = [self getButton:CGRectMake(boundX, boundY, 30, 35) bgImage:[UIImage imageNamed:@"shift_23x35"] tag:MY_KEY_SHIFT_MN1 title:nil];
            boundX += button.bounds.size.width + 13;
        } else if (i == 9) {
            boundX += button.bounds.size.width + 9;
            button = [self getButton:CGRectMake(boundX, boundY, 30, 35) bgImage:[UIImage imageNamed:@"backspace_23x35"] tag:MY_KEY_BACKSPACE title:nil];
        }
        
        [self addSubview:button];
    }
    
#pragma mark Line 5
    boundX = 3;
    boundY = 177;
    for (int i=0; i<4; i++) {
        
        UIButton *button = nil;
        if (i == 0) {
            button = [self getButton:CGRectMake(boundX, boundY, 38, 35) bgImage:[UIImage imageNamed:@"button_dund_32x41.png"] tag:MY_KEY_ENG title:@"En"];
            boundX += button.bounds.size.width + 5;
        } else if (i == 1) {
            button = [self getButton:CGRectMake(boundX, boundY, 39, 35) bgImage:[UIImage imageNamed:@"button_dund_32x41"] tag:MY_KEY_NUMBER title:@"123"];
            boundX += button.bounds.size.width + 5;
        } else if (i == 2) {
            button = [self getButton:CGRectMake(boundX, boundY, 140, 35) bgImage:[UIImage imageNamed:@"space_135x35.png"] tag:MY_KEY_SPACE title:@"Зай"];
            boundX += button.bounds.size.width + 5;
        }else if (i == 3) {
            button = [self getButton:CGRectMake(boundX, boundY, 82, 35) bgImage:[UIImage imageNamed:@"button_dund_71x41.png"] tag:MY_KEY_ENTER title:@"return"];
            boundX += button.bounds.size.width + 5;
        }
        
        [self addSubview:button];
    }
}


- (void)rotate_buildKeys {
    
    int characterIndex = 0;
    buttonArray = [NSMutableArray array];
    
#pragma mark Line 1
    int boundX = myBoundX - 2;
    int boundY = 6;
    for (int i = 0; i<11; i++) {
        UIButton *button = nil;
        button = [self getButton:CGRectMake(boundX, boundY, 38, 26) bgImage:[UIImage imageNamed:@"button_useg_40x31.png"] tag:MY_KEY_OTHER title:[self.keys[characterIndex++] uppercaseString]];
        boundX += button.bounds.size.width + 5;
        [buttonArray addObject:button];
        [self addSubview:button];
    }
    
#pragma mark Line 2
    boundY = 37;
    boundX = myBoundX - 2;
    for (int i = 0; i<11; i++) {
        
        UIButton *button = nil;
        button = [self getButton:CGRectMake(boundX, boundY, 38, 26) bgImage:[UIImage imageNamed:@"button_useg_40x31.png"] tag:MY_KEY_OTHER title:[self.keys[characterIndex++] uppercaseString]];
        boundX += button.bounds.size.width + 5;
        [buttonArray addObject:button];
        [self addSubview:button];
    }
    
#pragma mark Line 3
    boundY = 68;
    boundX = myBoundX + 22;
    for (int i = 0; i<10; i++) {
        
        UIButton *button = nil;
        button = [self getButton:CGRectMake(boundX, boundY, 38, 26) bgImage:[UIImage imageNamed:@"button_useg_40x31.png"] tag:MY_KEY_OTHER title:[self.keys[characterIndex++] uppercaseString]];
        boundX += button.bounds.size.width + 5;
        [buttonArray addObject:button];
        [self addSubview:button];
    }
    
#pragma mark Line 4
    boundX = myBoundX - 2;
    boundY = 99;
    for (int i = 0; i<10; i++) {
        
        UIButton *button = nil;
        if (i>=1 && i<9) {
            button = [self getButton:CGRectMake(boundX, boundY, 38, 26) bgImage:[UIImage imageNamed:@"button_useg_40x31.png"] tag:MY_KEY_OTHER title:[self.keys[characterIndex++] uppercaseString]];
            [buttonArray addObject:button];
            boundX += button.bounds.size.width + 5;
        } else if (i == 0) {
            button = [self getButton:CGRectMake(boundX, boundY, 47, 26) bgImage:[UIImage imageNamed:@"shift_38x26.png"] tag:MY_kEY_SHIFT_MN2 title:nil];
            boundX += button.bounds.size.width + 17;
        } else if (i == 9) {
            boundX += button.bounds.size.width + 12;
            button = [self getButton:CGRectMake(boundX, boundY, 46, 26) bgImage:[UIImage imageNamed:@"backspace_38x26"] tag:MY_KEY_BACKSPACE title:nil];
            
        }
        [self addSubview:button];
    }
    
#pragma mark Line 5
    boundX = myBoundX - 2;
    boundY = 130;
    for (int i=0; i<4; i++) {
        
        UIButton *button = nil;
        if (i == 0) {
            button = [self getButton:CGRectMake(boundX, boundY, 54, 26) bgImage:[UIImage imageNamed:@"button_dund_52x31.png"] tag:MY_KEY_ENG title:@"En"];
            boundX += button.bounds.size.width + 5;
        } else if (i == 1) {
            button = [self getButton:CGRectMake(boundX, boundY, 54, 26) bgImage:[UIImage imageNamed:@"button_dund_52x31"] tag:MY_KEY_NUMBER title:@"123"];
            boundX += button.bounds.size.width + 5;
        } else if (i == 2) {
            button = [self getButton:CGRectMake(boundX, boundY, 252, 26) bgImage:[UIImage imageNamed:@"space_252x26"] tag:MY_KEY_SPACE title:@"Зай"];
            boundX += button.bounds.size.width + 5;
        }else if (i == 3) {
            button = [self getButton:CGRectMake(boundX, boundY, 93, 26) bgImage:[UIImage imageNamed:@"button_dund_89x31.png"] tag:MY_KEY_ENTER title:@"return"];
            boundX += button.bounds.size.width + 5;
        }
        
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
    else if (button.tag == MY_KEY_SHIFT_MN1 || button.tag == MY_kEY_SHIFT_MN2) {
        shifted = !shifted;
        [self syncBuildKeys];
    }
    else if (button.tag == MY_KEY_SPACE) {
        [self.textField insertText:@" "];
    }
    else if (button.tag == MY_KEY_HIDE_KEYBOARD) {
        [self.textField resignFirstResponder];
    }
    else if (button.tag == MY_KEY_ENG) {
        MY_IPHONE_EN_KEYBOARD.textField = self.textField;
    }
    else if (button.tag == MY_KEY_NUMBER) {
        MY_IPHONE_NUM_KEYBOARD.textField = self.textField;
    }
}

- (void)refreshFrame {
    [super refreshFrame];

    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    {
        if (UIInterfaceOrientationIsPortrait([[NSUserDefaults standardUserDefaults] integerForKey:MY_CURRENT_INTERFACE_ORIENTATION])){
            [self buildKeys];
        } else if(UIInterfaceOrientationIsLandscape([[NSUserDefaults standardUserDefaults] integerForKey:MY_CURRENT_INTERFACE_ORIENTATION])) {
            [self rotate_buildKeys];
        } else {
            NSLog(@"ORIENATION ERROR");
            exit(1);
        }
    }
}

#pragma mark -
#pragma mark Getters
- (NSArray *)keys {
    if (keys == nil)
    {
        keys = @[@"ф", @"ц", @"у", @"ж", @"э", @"н", @"г", @"ш", @"ү", @"з", @"к", @"й", @"ы", @"б", @"ө", @"а", @"х", @"р", @"о", @"л", @"д", @"п", @"я", @"ч", @"ё", @"с", @"м", @"и", @"т", @"ь", @"в", @"ю", @"₮", @"=", @"-", @".", @",",@"ъ", @"е" , @"щ", @"",];
    }
    return keys;
}


- (void)addPopupToButton:(UIButton *)b {
    
    
    UIImageView *keyPop;
    UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(13, 10, 52, 60)];
    
    if (b == [self.buttonArray objectAtIndex:0] || b == [self.buttonArray objectAtIndex:11]) {
        if (isrotate == YES) {
            keyPop = [[UIImageView alloc] initWithImage:[UIImage imageWithCGImage:[self createKeytopImageWithKind:PKNumberPadViewImageRight] scale:[[UIScreen mainScreen] scale] orientation:UIImageOrientationDown]];
            keyPop.frame = CGRectMake(-20, -78, keyPop.frame.size.width+43, keyPop.frame.size.height-2);
            text.frame = CGRectMake(37, 10, 52, 60);
        }else{
            keyPop = [[UIImageView alloc] initWithImage:[UIImage imageWithCGImage:[self createKeytopImageWithKind:PKNumberPadViewImageRight] scale:[[UIScreen mainScreen] scale] orientation:UIImageOrientationDown]];
            keyPop.frame = CGRectMake(-14, -71, keyPop.frame.size.width, keyPop.frame.size.height);
        }
    }
    else if (b == [self.buttonArray objectAtIndex:10] || b == [self.buttonArray objectAtIndex:21]) {
        if (isrotate == YES) {
            keyPop = [[UIImageView alloc] initWithImage:[UIImage imageWithCGImage:[self createKeytopImageWithKind:PKNumberPadViewImageLeft] scale:[[UIScreen mainScreen] scale] orientation:UIImageOrientationDown]];
            keyPop.frame = CGRectMake(-61, -78, keyPop.frame.size.width+43, keyPop.frame.size.height-2);
            text.frame = CGRectMake(37, 10, 52, 60);
        }else{
            keyPop = [[UIImageView alloc] initWithImage:[UIImage imageWithCGImage:[self createKeytopImageWithKind:PKNumberPadViewImageLeft] scale:[[UIScreen mainScreen] scale] orientation:UIImageOrientationDown]];
            keyPop.frame = CGRectMake(-38, -71, keyPop.frame.size.width, keyPop.frame.size.height);
        }
    }
    else {
        if (isrotate == YES) {
            keyPop = [[UIImageView alloc] initWithImage:[UIImage imageWithCGImage:[self createKeytopImageWithKind:PKNumberPadViewImageInner] scale:[[UIScreen mainScreen] scale] orientation:UIImageOrientationDown]];
            keyPop.frame = CGRectMake(-40, -78, keyPop.frame.size.width+43, keyPop.frame.size.height-2);
            text.frame = CGRectMake(37, 10, 52, 60);
        }else{
            keyPop = [[UIImageView alloc] initWithImage:[UIImage imageWithCGImage:[self createKeytopImageWithKind:PKNumberPadViewImageInner] scale:[[UIScreen mainScreen] scale] orientation:UIImageOrientationDown]];
            keyPop.frame = CGRectMake(-27, -71, keyPop.frame.size.width, keyPop.frame.size.height);
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


#define _UPPER_WIDTH   (52.0 * [[UIScreen mainScreen] scale])
#define _LOWER_WIDTH   (26.0 * [[UIScreen mainScreen] scale])

#define _PAN_UPPER_RADIUS  (6.0 * [[UIScreen mainScreen] scale])
#define _PAN_LOWER_RADIUS  (3.0 * [[UIScreen mainScreen] scale])

#define _PAN_UPPDER_WIDTH   (_UPPER_WIDTH-_PAN_UPPER_RADIUS*2)
#define _PAN_UPPER_HEIGHT    (56.0 * [[UIScreen mainScreen] scale])

#define _PAN_LOWER_WIDTH     (_LOWER_WIDTH-_PAN_LOWER_RADIUS*2-3)
#define _PAN_LOWER_HEIGHT    (27.0 * [[UIScreen mainScreen] scale])

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

