//
//  EventViewController.m
//  MusicApp
//
//  Created by Bayraa on 6/10/14.
//  Copyright (c) 2014 Kaizen Mongolia. All rights reserved.
//

#import "EventViewController.h"
#import "EventCell.h"
#import "CJSONDeserializer.h"
@interface EventViewController (){
     NSArray *newsArray;
}

@end

@implementation EventViewController
@synthesize eventTableview;
@synthesize subView;
@synthesize blackview;
@synthesize eventdatelabel;
@synthesize eventImg;
@synthesize eventTitlelabel;
@synthesize textView;

@synthesize headerImgview;
@synthesize headerTitleLabel;
@synthesize backBtn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:self.eventTableview];
    [self getNews];
    self.titleLabel.text = NSLocalizedString(@"Үйл явдал", nil);
    [self.titleLabel setFont:[UIFont fontWithName:@"AGAvantGardeMon" size:18]];
    
    [self.view addSubview:self.subView];
    [self.subView addSubview:self.eventImg];
    [self.subView addSubview:self.blackview];
    [self.subView addSubview:self.eventTitlelabel];
    [self.subView addSubview:self.eventdatelabel];
    [self.subView addSubview:self.textView];
    [self.subView addSubview:self.headerImgview];
    [self.subView addSubview:self.backBtn];
    [self.subView addSubview:self.headerTitleLabel];
    
    
    // Do any additional setup after loading the view.
}

-(void)getNews {
    NSURL *url = [NSURL URLWithString:@"http://apps.gadget.mn/news.php"];
    NSError *error = nil;
    NSString *jsonreturn = [[NSString alloc] initWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
    NSData *jsonData = [jsonreturn dataUsingEncoding:NSUTF16BigEndianStringEncoding];
    NSDictionary *dict = [[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData error:&error];
    
    if (dict)
    {
        newsArray = [dict objectForKey:@"news"];
    }
}

-(UITableView *)eventTableview{
    if(eventTableview == nil){
        eventTableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, MY_BOUNDS.width, MY_BOUNDS.height-64)];
        eventTableview.backgroundColor = CLEAR_COLOR;
        eventTableview.delegate = self;
        eventTableview.dataSource = self;
    }
    
    return eventTableview;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 174;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return newsArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"EventCell";
    EventCell *cell = (EventCell *)[eventTableview dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[EventCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *dict = [newsArray  objectAtIndex:indexPath.row];
    cell.titlelabel.text = [dict objectForKey:@"title"];
    cell.titlelabel.numberOfLines = 2;
    cell.dateLabel.text = [dict objectForKey:@"created_at"];
     cell.imgView.image = [UIImage imageNamed:@"Non-stop.jpg"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;

 
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [newsArray  objectAtIndex:indexPath.row];
    self.textView.text  = [dict objectForKey:@"body"];
    eventTitlelabel.text = [dict objectForKey:@"title"];
    eventdatelabel.text = [dict objectForKey:@"created_at"];
    
    NSString *urlStr = [NSString stringWithFormat:@"http://apps.gadget.mn/images/news/"];
    NSString *urlAppend = [urlStr stringByAppendingFormat:@"%@",[dict valueForKey:@"image"]];
    NSURL *imgUrl1 = [NSURL URLWithString:urlAppend];
    NSData *data = [NSData dataWithContentsOfURL:imgUrl1];
    UIImage *image = [UIImage imageWithData:data];
    eventImg.image = image;
    
    [UIView beginAnimations:@"newGrid" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.3];
    self.subView.frame = CGRectMake(0, 0, MY_BOUNDS.width, 568);
    [UIView commitAnimations];
}

-(UIView *)subView {
    if(subView == nil){
        subView = [[UIView alloc] initWithFrame:CGRectMake(320, 0, MY_BOUNDS.width, 568)];
        subView.backgroundColor = [UIColor whiteColor];
    }
    return subView;
}

-(UIImageView *)headerImgview {
    if(headerImgview == nil) {
        headerImgview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
        headerImgview.image = [UIImage imageNamed:@"header.png"];
    }
    return headerImgview;
}

-(UIButton *)backBtn {
    if(backBtn == nil){
        backBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 15, 40, 33)];
        [backBtn setImage:[UIImage imageNamed:@"button_back.png"] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(BackBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return backBtn;
}

-(UILabel *)headerTitleLabel {
    if(headerTitleLabel == nil){
        headerTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, 320, 21)];
        [headerTitleLabel setFont:[UIFont fontWithName:@"AGAvantGardeMon" size:17]];
        headerTitleLabel.text = NSLocalizedString(@"Үйл явдал", nil);
        headerTitleLabel.textColor = [UIColor blackColor];
        headerTitleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return headerTitleLabel;
}

-(void)BackBtnClicked{
    [UIView beginAnimations:@"newGrid" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.3];
    self.subView.frame = CGRectMake(320, 0, MY_BOUNDS.width, 568);
    [UIView commitAnimations];
}

-(UIImageView *)eventImg{
    if(eventImg == nil){
        eventImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 50, 320, 174)];
        eventImg.contentMode = UIViewContentModeScaleAspectFit;

        
    }
    return eventImg;
}

-(UIView *)blackview {
    if(blackview == nil) {
        blackview = [[UIView alloc]initWithFrame:CGRectMake(0, 222, 320, 50)];
        blackview.backgroundColor = [UIColor blackColor];
        blackview.alpha = 0.6f;
    }
    return blackview;
}

-(UILabel *)eventTitlelabel {
    if(eventTitlelabel == nil){
        eventTitlelabel = [[UILabel alloc] initWithFrame:CGRectMake(6, 227, 295, 29)];
        eventTitlelabel.textColor= [UIColor whiteColor];
        [eventTitlelabel setFont:[UIFont fontWithName:@"AGAvantGardeMon" size:14]];
        eventTitlelabel.numberOfLines = 2;
    }
    return eventTitlelabel;
}

-(UILabel *)eventdatelabel {
    if(eventdatelabel == nil){
        eventdatelabel = [[UILabel alloc] initWithFrame:CGRectMake(6, 255 , 158, 21)];
        eventdatelabel.textColor= [UIColor whiteColor];
        [eventdatelabel setFont:[UIFont fontWithName:@"AGAvantGardeMon" size:13]];
    }
    return eventdatelabel;
}

-(UITextView *)textView {
    if(textView == nil){
        textView = [[UITextView alloc]initWithFrame:CGRectMake(0, 275, 320, 200)];
        textView.editable = NO;
    }
    return textView;
}

@end
