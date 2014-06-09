//
//  StandartDatePickerViewController.h
//  iCalendarRepo
//
//  Created by Developer on 9/24/13.
//  Copyright (c) 2013 Sodtseren. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol StandartDatePickerDelegate
@required
-(void)didChangedDatePicker:(NSDate *)date;
-(void)dismissDatePicker;
@end

@interface StandartDatePickerViewController : UIViewController

@property (nonatomic, assign) id<StandartDatePickerDelegate> delegate;

- (void)selectDate:(NSDate *)date animated:(BOOL)animated;

@end
