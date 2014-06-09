//
//  MyAlertView.h
//  iWaiterRepo
//
//  Created by Developer on 12/14/13.
//  Copyright (c) 2013 Sodtseren. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyAlertView : UIAlertView

@property (copy, nonatomic) void (^completion)(BOOL, NSInteger);

- (id)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles;

@end
