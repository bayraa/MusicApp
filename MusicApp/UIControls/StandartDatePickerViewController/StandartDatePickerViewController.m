//
//  StandartDatePickerViewController.m
//  iCalendarRepo
//
//  Created by Developer on 9/24/13.
//  Copyright (c) 2013 Sodtseren. All rights reserved.
//

#import "StandartDatePickerViewController.h"

@interface StandartDatePickerViewController ()

@property (nonatomic, strong) UIDatePicker *datePicker;

@end

@implementation StandartDatePickerViewController
@synthesize datePicker;
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.preferredContentSize = CGSizeMake(320, 216);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self configureView];
    
    UITapGestureRecognizer *recognozer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(finishController:)];
    recognozer.cancelsTouchesInView = NO;
    [self.datePicker addGestureRecognizer:recognozer];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.delegate didChangedDatePicker:datePicker.date];
}

- (void)configureView {
    [self.view addSubview:self.datePicker];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)selectDate:(NSDate *)date animated:(BOOL)animated {
    [datePicker setDate:date animated:animated];
    [self datePickerChanged:self.datePicker];
}

- (void) finishController: (UITapGestureRecognizer *)recognizer {
    
    CGPoint touchPoint = [recognizer locationInView:recognizer.view.superview];
    
    CGRect frame = self.datePicker.frame;
    CGRect selectorFrame = CGRectInset(frame, 0.0, self.datePicker.bounds.size.height * 0.85 / 2.0 );
    
    if( CGRectContainsPoint(selectorFrame, touchPoint) )
    {
        [delegate dismissDatePicker];
    }
}

#pragma mark -
#pragma mark Getters
#pragma mark -
- (UIDatePicker *)datePicker {
    if (datePicker == nil) {
        datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, 320, 216)];
        [datePicker setDatePickerMode:UIDatePickerModeDate];
        [datePicker addTarget:self action:@selector(datePickerChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return datePicker;
}


#pragma mark -
#pragma mark DatePickerDelegate
#pragma mark -
- (void)datePickerChanged:(UIDatePicker *)picker {
    [self.delegate didChangedDatePicker:datePicker.date];
}

@end
