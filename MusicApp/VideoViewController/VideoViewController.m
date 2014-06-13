//
//  VideoViewController.m
//  MusicApp
//
//  Created by Bayraa on 6/9/14.
//  Copyright (c) 2014 Kaizen Mongolia. All rights reserved.
//

#import "VideoViewController.h"
#import <SWRevealViewController/SWRevealViewController.h>
#import "CJSONDeserializer.h"
#import "VideoCell.h"

@interface VideoViewController ()


@end

@implementation VideoViewController{
    NSArray *AllDataArray;
    NSMutableArray *CoverImgArray;
    NSInteger Index;
}

@synthesize videoTableView;
@synthesize videoView;
@synthesize titlelabel;
@synthesize ViewsLabel;
@synthesize LikesLabel;
@synthesize publishLabel;
@synthesize webview;
@synthesize videoBG;

@synthesize headerimg;
@synthesize headerLabel;
@synthesize backbtn;
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
    [self.titleLabel setFont:[UIFont fontWithName:@"AGAvantGardeMon" size:18.0]];
    self.titleLabel.text = NSLocalizedString(@"Видео", nil);
    [self.view addSubview:self.videoTableView];
    [self.view addSubview:self.videoView];
    
    [self.videoView addSubview:self.videoBG];
    [self.videoView addSubview:self.webview];
    [self.videoView addSubview:self.titlelabel];
    [self.videoView addSubview:self.ViewsLabel];
    [self.videoView addSubview:self.LikesLabel];
    [self.videoView addSubview:self.publishLabel];
    
    [self.videoView addSubview:self.headerimg];
    [self.videoView addSubview:self.headerLabel];
    [self.videoView addSubview:self.backbtn];
    AllDataArray = [[NSArray alloc]init];
    [self getAlbums];
//    [self.menuBtn addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    // Do any additional setup after loading the view.
}

- (void)getAlbums {
    [self showLoadingHUD];
    [CONNECTION_MANAGER getVideosSuccess:^(NSArray *resultArray) {
        [self.HUD hide:YES];
        
        AllDataArray = resultArray;
        [videoTableView reloadData];

    } failure:^(NSString *errorMessage, NSError *error) {
        [self.HUD hide:YES];
        if (error) {
            [SEUtils showAlert:NO_CONNECTION_ALERT];
        }else if(errorMessage){
            [SEUtils showAlert:errorMessage];
        }
    } sessionExpired:nil];
}

-(UITableView *)videoTableView {
    if(videoTableView == nil) {
        videoTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, MY_BOUNDS.width, MY_BOUNDS.height-64) style:UITableViewStylePlain];
        videoTableView.backgroundColor = CLEAR_COLOR;
        videoTableView.delegate = self;
        videoTableView.dataSource = self;
        videoTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        videoTableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
    }
    return videoTableView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 182;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [AllDataArray count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"VideoCell";
    VideoCell *cell = (VideoCell *)[videoTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[VideoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    Index = indexPath.row;
    
    cell.video = [AllDataArray objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSURL *url = [NSURL URLWithString:[cell.video.cover objectAtIndex:0]];
    [cell.coverIMG setImageWithURL:url placeholderImage:nil];
    
     [cell layoutSubviews];
   // cell.videoTitleLabel.text = [[CoverImgArray objectAtIndex:indexPath.row]valueForKey:@"title"];
   // cell.videoTitleLabel.font = [UIFont fontWithName:@"AGAvantGardeMon" size:16.0];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSString *urlStr = [[AllDataArray objectAtIndex:indexPath.row]valueForKey:@"url_embed"];
    [self embedYouTube :urlStr  frame:CGRectMake(0, 50, 320, 200)];
    
    Video *video = [AllDataArray objectAtIndex:indexPath.row];
    [UIView beginAnimations:@"newGrid" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.3];
    self.videoView.frame = CGRectMake(0, 0, MY_BOUNDS.width, 568);
    self.titlelabel.text = video.title;
    self.ViewsLabel.text =[NSString stringWithFormat:@"Views: %@",video.views];
    self.LikesLabel.text =[NSString stringWithFormat:@"Likes: %@",video.likes];
    self.publishLabel.text =[NSString stringWithFormat:@"Published: %@",video.published];
    [UIView commitAnimations];
    
}

- (void)embedYouTube:(NSString*)url frame:(CGRect)frame {
    
    NSString* embedHTML = @"\
    <html><head>\
    <style type=\"text/css\">\
    body {\
    background-color: transparent;\
    color: white;\
    }\
    </style>\
    </head><body style=\"margin:0\">\
    <embed id=\"yt\" src=\"%@\" type=\"application/x-shockwave-flash\" \
    width=\"%0.0f\" height=\"%0.0f\"></embed>\
    </body></html>";
    
    NSString* html = [NSString stringWithFormat:embedHTML, url, frame.size.width, frame.size.height];
    [self.webview  loadHTMLString:html baseURL:nil];
    
}

-(UIView *)videoView{
    if(videoView == nil) {
        videoView = [[UIView alloc]initWithFrame:CGRectMake(320, 0, MY_BOUNDS.width, 568)];
        videoView.backgroundColor = [UIColor whiteColor];
    }
    return videoView;
}

-(UILabel *)titlelabel {
    if(titlelabel == nil){
        titlelabel = [[UILabel alloc]initWithFrame:CGRectMake(9, 238, 298, 51)];
        [titlelabel setFont:[UIFont fontWithName:@"AGAvantGardeMon" size:16]];
        titlelabel.textColor = [UIColor blackColor];
        titlelabel.backgroundColor = CLEAR_COLOR;
        titlelabel.numberOfLines = 3;
        titlelabel.adjustsFontSizeToFitWidth = YES;
    }
    return titlelabel;
}
-(UILabel *)LikesLabel {
    if(LikesLabel == nil){
        LikesLabel = [[UILabel alloc]initWithFrame:CGRectMake(9, 330, 150, 21)];
        [LikesLabel setFont:[UIFont fontWithName:@"AGAvantGardeMon" size:16]];
        LikesLabel.textColor = [UIColor blackColor];
        LikesLabel.backgroundColor = CLEAR_COLOR;
        
    }
    return LikesLabel;
}
-(UILabel *)ViewsLabel {
    if(ViewsLabel == nil){
        ViewsLabel = [[UILabel alloc]initWithFrame:CGRectMake(9, 310, 150, 21)];
        [ViewsLabel setFont:[UIFont fontWithName:@"AGAvantGardeMon" size:16]];
        ViewsLabel.textColor = [UIColor blackColor];
        ViewsLabel.backgroundColor = CLEAR_COLOR;
        
    }
    return ViewsLabel;
}
-(UILabel *)publishLabel {
    if(publishLabel == nil){
        publishLabel = [[UILabel alloc]initWithFrame:CGRectMake(9, 290, 303, 21)];
        [publishLabel setFont:[UIFont fontWithName:@"AGAvantGardeMon" size:13]];
        publishLabel.textColor = [UIColor blackColor];
        publishLabel.backgroundColor = CLEAR_COLOR;
     
    }
    return publishLabel;
}

-(UIWebView *)webview {
    if(webview == nil){
        webview = [[UIWebView alloc]initWithFrame:CGRectMake(0, 50 , MY_BOUNDS.width, 185)];
        webview.backgroundColor = [UIColor whiteColor];
    }
    return webview;
}

-(UIImageView *)videoBG {
    if(videoBG == nil){
        videoBG = [[UIImageView alloc] initWithFrame:CGRectMake(0, 50, 320, 568)];
        videoBG.backgroundColor = CLEAR_COLOR;
        videoBG.image = [UIImage imageNamed:@"album_bg.jpg"];
    }
    return videoBG;
}

-(UILabel *)headerLabel{
    if(headerLabel == nil){
        headerLabel = [[UILabel alloc]initWithFrame:CGRectMake(71, 20, 174, 21)];
        headerLabel.backgroundColor = CLEAR_COLOR;
        [headerLabel setFont:[UIFont fontWithName:@"AGAvantGardeMon" size:18]];
        headerLabel.textAlignment = NSTextAlignmentCenter;
        headerLabel.text = NSLocalizedString(@"Видео", nil);
    }
    return headerLabel;
}

-(UIImageView *) headerimg{
    if(headerimg == nil){
        headerimg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
        headerimg.image = [UIImage imageNamed:@"header.png"];
    }
    return headerimg;
}

-(UIButton *)backbtn{
    if(backbtn == nil){
        backbtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 13, 40, 33)];
        [backbtn setImage:[UIImage imageNamed:@"button_back.png"] forState:UIControlStateNormal];
        [backbtn addTarget:self action:@selector(backbtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return backbtn;
}

-(void)backbtnClicked{
    [UIView beginAnimations:@"newGrid" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.3];
    self.videoView.frame = CGRectMake(320, 0, MY_BOUNDS.width, 568);
    [UIView commitAnimations];
}
@end
