//
//  ClipDetailViewController.m
//  NightdanceI
//
//  Created by cable8mm on 2013. 12. 15..
//  Copyright (c) 2013년 Lee Samgu. All rights reserved.
//

#import "ClipDetailViewController.h"
#import "../Global.h"
#import "ClipPlayerViewController.h"
#import "ClipDetailCell.h"
#import "ClipInformationCell.h"
#import "ClipReviewCell.h"
#import "SCManager.h"
#import "ClipCell.h"
#import "ClipMoreCell.h"
#import "NoDataCell.h"
#import "DownloadManager.h"
#import "NDCache.h"
#import "PlayButton.h"
#import "DownloadButton.h"
#import "UserManager.h"
//#import "WishBarButtonItem.h"
#import "GlobalFunctions.h"
#import "WriteReviewCell.h"
#import "NcashBuyingViewController.h"
#import "NetworkErrorViewController.h"
#import "NetworkErrorView.h"

@interface ClipDetailViewController ()
@property (nonatomic, retain) NSMutableDictionary *clip;
@property (nonatomic, retain) IBOutlet UIImageView *thumbnail;
@property (nonatomic, retain) IBOutlet UILabel *clipTitle;
@property (nonatomic, retain) IBOutlet UILabel *clipCredit;
@property (nonatomic, retain) IBOutlet UIButton *previewButton;
@property (nonatomic, retain) IBOutlet PlayButton *buyAndPlayButton;
@property (nonatomic, retain) IBOutlet DownloadButton *downloadButton;
@property (nonatomic, retain) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic, retain) NSMutableArray *clips;
@property (nonatomic, retain) NSMutableArray *comments;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *wishButton;
@property (nonatomic, retain) IBOutlet UILabel *loginMessage;
@property (nonatomic) BOOL isLogin;
@property(nonatomic) BOOL isNetworkAvailable;
- (IBAction)previewClip;
- (IBAction)playClip;
- (IBAction)buyAndPlayClip;
- (IBAction)contentChanged:(id)sender;
- (IBAction)downloadClip;
- (IBAction)saveWishClip;
- (void) myMovieFinishedCallback: (NSNotification*)aNotification;
@end

@implementation ClipDetailViewController

@synthesize thumbnail, clip, clipId, clipTitle, buyAndPlayButton, downloadButton, clips;

#pragma mark - Accessors
-(void)setIsLogin:(BOOL)isLogin {
    BOOL isWatchable    = [[self.clip objectForKey:@"is_watchable"] boolValue];

    // wishButton
    if (isLogin) {
        self.wishButton.enabled  = [[self->clip objectForKey:@"is_scraped"] boolValue] == NO;
    } else {
        self.wishButton.enabled  = [UserManager isScrapedClip:self.clipId] == NO;
    }
    self.wishButton.title  = self.wishButton.enabled? @"즐겨찾기 추가" : @"즐겨찾기 추가 됨";

//    self.wishButton.title   = NSLocalizedString(@"찜하기", nil);
    
    // loginMessage
    self.loginMessage.hidden    = YES;
    self.buyAndPlayButton.hidden    = NO;
    
    // downloadButton
    if (isWatchable == NO && [UserManager canPlayClip] == NO) {
        self.downloadButton.enabled = NO;
    } else {
        if ([[DownloadManager sharedObject] isDownloadClip:[self.clipId intValue]]) {
            self.downloadButton.isDownload  = YES;
        } else {
            self.downloadButton.isDownload  = NO;
        }
    }
    
    // 다운로드 큐에 있으면 그 상태를 보여준다.
    if (self.downloadButton.hidden == NO) {
        DownloadClip *downloadClip  = [[DownloadManager sharedObject] getDownloadClip:[self.clipId intValue]];
        if (downloadClip != nil) {
            [self.downloadButton setStatus:downloadClip.status];
        }
    }
    
    _isLogin    = isLogin;
}

- (void) setIsNetworkAvailable:(BOOL)v {
    if (_isNetworkAvailable == v) {
        return;
    }
    
    _isNetworkAvailable = v;
    BOOL isHidden   = _isNetworkAvailable == NO;
    
    self.thumbnail.hidden   = isHidden;
    self.clipTitle.hidden   = isHidden;
    self.clipCredit.hidden   = isHidden;
    self.previewButton.hidden   = isHidden;
    self.buyAndPlayButton.hidden   = isHidden;
    self.downloadButton.hidden   = isHidden;
    self.segmentedControl.hidden   = isHidden;
    self.loginMessage.hidden    = isHidden;
    self.wishButton.enabled = _isNetworkAvailable;
}

#pragma mark - Life Cycle Methods
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
    
    // Initialize - clipId already assign.
    self.title  = @"강좌";
    self.downloadButton.clipId  = self.clipId;
    _isNetworkAvailable = YES;
    
    UINib *cellNib = [UINib nibWithNibName:@"ClipDetailCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:@"ClipDetailCell"];
    
    if (self.clip == nil) {
        NSString *params    = [NSString stringWithFormat:@"id=%@", self.clipId];
        NSString *urlString = [SCManager getAuthUrl:@"get_clip.php" param:params];
        NSDictionary *jsonData  = [SCManager getJsonData:urlString];

        self.isNetworkAvailable = jsonData != nil;
        
        if (jsonData != nil) {
            self.clip  = [NSMutableDictionary dictionaryWithDictionary:jsonData[@"clip"]];
            
            [self.clipTitle setNumberOfLines:0];
            [self.clipTitle sizeToFit];
            self.clipTitle.text  = [self.clip objectForKey:@"clip_title"];
            
            self.clipCredit.text    = [self.clip objectForKey:@"clip_credit"];
            NSString *clipThumbnail = [self.clip objectForKey:@"clip_thumbnail"];
            [[NDCache sharedObject] assignCachedImage:clipThumbnail
                                      completionBlock:^(UIImage *image) {
                                          self.thumbnail.image  = image;
                                      }];
            
            // 고객 리뷰에 갯수 넣기
            NSNumber *commentCount  = [jsonData objectForKey:@"comment_count"];
            if ([commentCount intValue] != 0) {
                NSString *reviewString  = [NSString stringWithFormat:@"고객 리뷰(%@)", commentCount];
                [self.segmentedControl setTitle:reviewString forSegmentAtIndex:1];
            }
            
            [self contentChanged:self.segmentedControl];
            
            if ([[self.clip objectForKey:@"clip_payment"] intValue] == 0) {
                self.previewButton.hidden   = YES;
            }
            
            self.isLogin    = [UserManager isLogin];
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notiLogout:) name:@"NOTI_USER_LOGINOUT" object:nil];
        } else {
            UIAlertView *alert =  [[UIAlertView alloc] initWithTitle:@"네트워크 에러"
                                                             message:@"네트워크가 원활하지 않습니다. 다시 시도해 주세요."
                                                            delegate:self
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil];
            alert.tag   = -1;
            [alert show];
        }
    }
}

// delegate
-(void)didCompleteJsonData:(NSDictionary*)data tag:(NSString*)tagString {
    
}

// Tell the system what we support
- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

// Tell the system It should autorotate
- (BOOL) shouldAutorotate {
    return NO;
}

// Tell the system which initial orientation we want to have
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Delegates
- (void)addComment:(NSString *)comment {
    NSDictionary *dic = @{
                          @"nickname":[UserManager getNickname],
                          @"comment_text":comment,
                          @"created":@"now"
                          };
    [self.comments insertObject:dic atIndex:0];
    [self.tableView reloadData];
}

#pragma mark - IBAction Methods
- (IBAction)previewClip {
    // clip_hd_sample_url
    NSLog(@"preview clip : %@", [self.clip objectForKey:@"clip_sample_url"]);
    
    NSURL *previewClipUrl = [NSURL URLWithString:[self.clip objectForKey:@"clip_sample_url"]];

    _moviePlayer =  [[ClipPlayerViewController alloc] initWithContentURL:previewClipUrl];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(myMovieFinishedCallback:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:_moviePlayer.moviePlayer];
    
    [self presentMoviePlayerViewControllerAnimated:_moviePlayer];
}

- (IBAction)downloadClip {
    self.downloadButton.isDownloading   = YES;
    
    UITabBarController *tabBarController    = (UITabBarController*)self.tabBarController;
    UITabBarItem *tabBarItem3   = [tabBarController.tabBar.items objectAtIndex:2];
    int badgeValue = [tabBarItem3.badgeValue intValue] + 1;
    [tabBarItem3 setBadgeValue:[NSString stringWithFormat:@"%d", badgeValue]];
    
    NSString *fileURLString = [self.clip objectForKey:@"clip_url"];
    NSString *filename  = [[NSURL URLWithString:fileURLString] lastPathComponent];
    NSString *thumbnailString = [self.clip objectForKey:@"clip_thumbnail"];
    NSURL *fileURL  = [[DownloadManager sharedObject] getFileURLFromFile:filename];
    NSNumber *remainSeconds = [self.clip objectForKey:@"remain_seconds"];
    
    if (fileURL == nil) {
        [[DownloadManager sharedObject] addDownloadingClip:[self.clipId intValue]
                                                     title:[self.clip objectForKey:@"clip_title"]
                                                       url:[self.clip objectForKey:@"clip_url"]
                                                 thumbnail:thumbnailString
                                                    remain:[remainSeconds intValue]
                                                    isFree:[self.clip objectForKey:@"is_free"]];
        return;
    }
    
//    NSURL *localURL = [NSURL fileURLWithPath:[fileURL path] isDirectory:NO]; //THIS IS THE KEY TO GET THIS RUN :)
//    _moviePlayer =  [[ClipPlayerViewController alloc] initWithContentURL:localURL];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(myMovieFinishedCallback:)
//                                                 name:MPMoviePlayerPlaybackDidFinishNotification
//                                               object:_moviePlayer.moviePlayer];
//    
//    [self presentMoviePlayerViewControllerAnimated:_moviePlayer];
}

- (IBAction)buyAndPlayClip {
    self.buyAndPlayButton.selected  = YES;
    
    if ([[self.clip objectForKey:@"is_watchable"] boolValue] == YES) {
        [self playClip];
    } else {
        if ([UserManager daysRemainingOnSubscription] == 0.) {
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"이 강좌는 자유이용권 구매 후 시청하실 수 있습니다"
                                                              message:nil
                                                             delegate:nil
                                                    cancelButtonTitle:@"확인"
                                                    otherButtonTitles:nil];
            [message show];
            self.buyAndPlayButton.selected  = NO;

        } else {
            [self playClip];
        }
//        int price   = [[self->clip objectForKey:@"clip_payment"] intValue];
//        NSString *priceString   = GetCommaNumber(price);
//        if ([UserManager getNcash] >= price) {
//            NSString *messageString = price == 0 ? @"무료 강좌이므로, 앤캐쉬가 차감되지 않습니다." : [NSString stringWithFormat:@"%@ 캐쉬가 차감됩니다.", priceString];
//            
//            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"이 강좌를 시청하시겠습니까?"
//                                                              message:messageString
//                                                             delegate:self
//                                                    cancelButtonTitle:@"취소"
//                                                    otherButtonTitles:@"시청", nil];
//            message.tag = 1;
//            [message show];
//        } else {
//            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"앤캐시 부족"
//                                                              message:@"엔캐시가 부족힙니다. 충전하시겠습니까?"
//                                                             delegate:self
//                                                    cancelButtonTitle:@"취소"
//                                                    otherButtonTitles:@"충전", nil];
//            message.tag = 2;
//            [message show];
//        }
    }
}

- (IBAction)contentChanged:(id)sender {
    NSInteger index = [(UISegmentedControl *)sender selectedSegmentIndex];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    if (index == 0) {   // 정보
        
    }
    
    if (index == 1) {
        if (self.comments == nil) {
            self.comments = [NSMutableArray arrayWithArray:[SCManager getComments:[self.clipId intValue]]];
        }
    }
    
    if (index == 2) {
        if (self.clips == nil) {
            NSString *params    = [NSString stringWithFormat:@"clip_id=%@", self.clipId];
            NSString *urlString = [SCManager getAuthUrl:@"get_relate_clips.php" param:params];
            NSDictionary *jsonData  = [SCManager getJsonData:urlString];
            
            if (jsonData != nil) {
                self.clips  = jsonData[@"clips"];
            }
        }
    }
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self.tableView reloadData];
}

- (IBAction)playClip {
    BOOL isDownloadExisted  = [[DownloadManager sharedObject] isDownloadClip:[self.clipId intValue]];
    
    if (isDownloadExisted) {
        NSURL *localURL = [[DownloadManager sharedObject] getFileURLFromClipId:[self.clipId intValue]];
        _moviePlayer =  [[ClipPlayerViewController alloc] initWithContentURL:localURL];
    } else {
        NSURL *url = [NSURL URLWithString:[self.clip objectForKey:@"clip_url"]];
        NSLog(@"play clip url = %@", url);

        _moviePlayer =  [[ClipPlayerViewController alloc] initWithContentURL:url];
    }
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(myMovieFinishedCallback:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:_moviePlayer.moviePlayer];
    
    [self presentMoviePlayerViewControllerAnimated:_moviePlayer];
}

- (IBAction)saveWishClip {
    if (self.isLogin) {
        NSString *params    = [NSString stringWithFormat:@"clip_id=%@", self.clipId];
        NSString *urlString = [SCManager getAuthUrl:@"add_wish_clip.php" param:params];
        NSDictionary *jsonData  = [SCManager getJsonData:urlString];
        
        BOOL isSuccess  = [jsonData[@"isSuccess"] boolValue];
        if (isSuccess) {
            [UserManager setViewedScrapingClip:YES];
        }
        
        NSString *titleString;
        NSString *messageString;
        
        titleString = isSuccess? @"강좌가 찜 되었습니다." : @"강좌가 찜 되지 못했습니다.";
        messageString = isSuccess? @"보관함에서 확인하실 수 있으세요." : @"보관함에서 확인하실 수 없으세요.";
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:titleString
                                                       message:messageString
                                                      delegate:nil
                                             cancelButtonTitle:nil
                                             otherButtonTitles:@"확인", nil];
        [alert show];
    } else {
        [UserManager addScrapedClip:clipId];
        self.wishButton.title   = @"즐겨찾기 추가 됨";
        self.wishButton.enabled = NO;
    }
}

#pragma mark - Notification Methods
- (void) notiLogout:(NSNotification *) notification {
    NSNumber *isLogin  = [[notification userInfo] objectForKey:@"IS_LOGIN"];
    self.isLogin    = [isLogin boolValue];
    [self.tableView reloadData];
}

- (void) myMovieFinishedCallback: (NSNotification*)notification {
    MPMoviePlayerController *player = [notification object];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:player];
    
    [player stop];
	
	[self dismissMoviePlayerViewControllerAnimated];
    self.buyAndPlayButton.selected  = NO;
}

#pragma mark - AlertView Callbacks
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == -1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    if (alertView.tag == 1) {   // 엔캐시 4,000코인을 사용해서 이 강좌를 시청하시겠습니까?
        if (buttonIndex == 1) { // 확인
            NSLog(@"코인 사용 후 시청");
            NSString *params    = [NSString stringWithFormat:@"number=%@&type=c", self.clipId];
            NSString *urlString = [SCManager getAuthUrl:@"submit_stat.php" param:params];
            NSDictionary *jsonData  = [SCManager getJsonData:urlString];
            
            BOOL isBuying   = [jsonData[@"is_buying"] boolValue];
            if (isBuying) {
                NSLog(@"self.clip = %@", self.clip);
                NSNumber *userNcash = jsonData[@"user"][@"user_mobile_ncash"];
                [UserManager setNcash:userNcash];
                [UserManager setViewedPurchasingClip:YES];
                
                int remainSeconds   = 60*60*24*[[self.clip objectForKey:@"clip_term"] intValue];
                [self.clip setObject:[NSNumber numberWithBool:YES] forKey:@"is_watchable"];
                [self.clip setObject:[NSNumber numberWithInt:remainSeconds] forKey:@"remain_seconds"];
//                NSDictionary *userInfo  = [NSDictionary dictionaryWithObject:self.clipId forKey:@"CLIP_ID"];
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTI_BOUGHT_CLIP"
//                                                                    object:nil
//                                                                  userInfo:userInfo];
                self.downloadButton.enabled = YES;
                self.downloadButton.status  = DownloadStatusReady;
//                [self.tableView reloadData];
            }
        }
    }

    if (alertView.tag == 2) {
        if (buttonIndex == 1) {
            NSLog(@"엔캐시 충전");
            [self performSegueWithIdentifier:@"showCharge" sender:alertView];
        }
    }
    
    self.buyAndPlayButton.selected  = NO;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    CGRect frame = webView.frame;
    frame.size.height = 5.0f;
    webView.frame = frame;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    CGSize mWebViewTextSize = [webView sizeThatFits:CGSizeMake(1.0f, 1.0f)];  // Pass about any size
    CGRect mWebViewFrame = webView.frame;
    
    mWebViewFrame.size.height = mWebViewTextSize.height;
    webView.frame = mWebViewFrame;
    
    //Disable bouncing in webview
    for (id subview in webView.subviews)
    {
        if ([[subview class] isSubclassOfClass: [UIScrollView class]])
        {
            [subview setBounces:NO];
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    switch (self.segmentedControl.selectedSegmentIndex) {
        case 0: // 상세 설명
        {
            if (self.clip == nil) {
                return 0;
            }
            return 2;
        }
            break;
        case 1:
        {
            int writeReview = self.isLogin? 1 : 0;
            if (self.comments == nil) {
                return 0;
            }
            return [self.comments count] != 0? [self.comments count]+writeReview : 1+writeReview;   // 덧글 갯수 + 덧글쓰기
        }
            break;
        case 2:         // 함께 보기
            return self.clips==nil? 0 : [self.clips count];
            break;
        default:
            break;
    }

    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id cell;
    switch (self.segmentedControl.selectedSegmentIndex) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                {
                    ClipDetailCell *detailCell  = (ClipDetailCell*)cell;
                    
                    detailCell = [tableView dequeueReusableCellWithIdentifier:@"ClipDetailCell"];
                    detailCell.song.text    = [self->clip objectForKey:@"music_title"];
                    detailCell.artist.text = [self->clip objectForKey:@"music_singer"];
                    detailCell.genreTitle.text   = [self->clip objectForKey:@"genre_name"];
                    detailCell.difficulty.text  = [self->clip objectForKey:@"clip_level"];
                    int clipSex   = [[self->clip objectForKey:@"clip_sex"] intValue];
                    detailCell.sex.text = GetSexString(clipSex);
                    detailCell.clipRate1.score  = [[self->clip objectForKey:@"clip_rate1"] intValue];
                    detailCell.clipRate2.score  = [[self->clip objectForKey:@"clip_rate2"] intValue];
                    int clipTerm = [[self->clip objectForKey:@"clip_term"] intValue];
                    NSString *clipTermLabel    = (clipTerm==0)? @"기간 제한 없음" : [NSString stringWithFormat:@"%d 시간", clipTerm*24];
                    detailCell.clipTerm.text  = clipTermLabel;
                    
                    int clipPayment = [[self->clip objectForKey:@"clip_payment"] intValue];
                    NSString *priceLabel    = (clipPayment==0)? @"무료" : [NSString stringWithFormat:@"%@ 코인", GetCommaNumber(clipPayment)];
                    detailCell.price.text  = priceLabel;
                    return detailCell;
                }
                    break;
                case 1:
                {
                    ClipInformationCell *informationCell  = (ClipInformationCell*)cell;
                    informationCell = [tableView dequeueReusableCellWithIdentifier:@"ClipInformationCell"];
                    informationCell.titleLabel.text = @"설명";
                    [informationCell.descriptionView setScrollEnabled:YES];
                    [informationCell.descriptionView setText:[self.clip objectForKey:@"clip_text"]];
                    CGRect frame    = informationCell.descriptionView.frame;
                    frame.size.height   = informationCell.descriptionView.contentSize.height;
//                    frame.size.height   = 300.;
                    informationCell.descriptionView.frame = frame;
                    informationCell.descriptionView.clipsToBounds = NO;

                    return informationCell;
                }
                    break;
                default:
                {
                    ClipDetailCell *detailCell  = (ClipDetailCell*)cell;
                    detailCell = [tableView dequeueReusableCellWithIdentifier:@"ClipDetailCell"];
//                    detailCell.titleLabel.text = @"강의 내용";
//                    [detailCell.descriptionView loadHTMLString:[self.clip objectForKey:@"clip_text"] baseURL:nil];
                    return detailCell;
                }
                    break;
            }
        }
            break;
        case 1: // 고객리뷰
        {
            NSInteger unNum = [indexPath indexAtPosition: 1 ];

            if (unNum == 0 && self.isLogin) {   // 리뷰 쓰기 버튼
                static NSString *CellIdentifier = @"WriteReviewCell";
                WriteReviewCell *cell = (WriteReviewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (cell == nil) {
                    NSArray *nib    = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
                    cell = (WriteReviewCell*)[nib objectAtIndex:0];
                }
                
                return cell;
            }

            if ([self.comments count] == 0) {
                static NSString *CellIdentifier = @"NoDataCell";
                NoDataCell *cell = (NoDataCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (cell == nil) {
                    NSArray *nib    = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
                    cell = (NoDataCell*)[nib objectAtIndex:0];
                }
                
                return cell;
            }

            static NSString *CellIdentifier = @"ClipReviewCell";
            ClipReviewCell *cell = (ClipReviewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil) {
                NSArray *nib    = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
                cell = (ClipReviewCell*)[nib objectAtIndex:0];
            }
            
            int writeReview = (self.isLogin)? 1 : 0;
            NSInteger commentNumber = unNum-writeReview;
            NSDictionary *comment   = [self.comments objectAtIndex:commentNumber];

            cell.nickname.text  = [comment objectForKey:@"nickname"];
            cell.created.text   = [comment objectForKey:@"created"];
            cell.descriptionView.text= [comment objectForKey:@"comment_text"];
            cell.descriptionView.clipsToBounds = NO;
            return cell;
        }
            break;
        case 2:
        {
            static NSString *CellIdentifier = @"ClipCell";
            ClipCell *cell = (ClipCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil) {
                NSArray *nib    = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
                cell = (ClipCell*)[nib objectAtIndex:0];
            }
            
            // Configure the cell...
            NSInteger unNum = [indexPath indexAtPosition: 1 ];
            NSDictionary *relatedClip   = [self->clips objectAtIndex:unNum];
            cell.titleLabel.text = [NSString stringWithFormat:@"%d. %@",(int)unNum+1, [relatedClip objectForKey:@"clip_title"]];
            cell.dancer.text    = [relatedClip objectForKey:@"music_title"];
            NSString *star1 = [relatedClip objectForKey:@"clip_rate1"];
            NSString *star2 = [relatedClip objectForKey:@"clip_rate2"];
            cell.starsView1.score = [star1 intValue];
            cell.starsView2.score = [star2 intValue];
            cell.commentCount = [relatedClip objectForKey:@"comment_count"];
            cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
            
            NSString *clipThumbnail = [relatedClip objectForKey:@"clip_thumbnail"];
            [[NDCache sharedObject] assignCachedImage:clipThumbnail
                                      completionBlock:^(UIImage *image) {
                                          cell.thumbnail.image  = image;
                                      }];
            return cell;
        }
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.segmentedControl.selectedSegmentIndex == 1) {
        NSInteger unNum = [indexPath indexAtPosition: 1 ];
        
        if (unNum == 0 && self.isLogin) {   // 리뷰 쓰기 버튼
            [self performSegueWithIdentifier:@"showWriteReview" sender:self];
        }
    }
    if (self.segmentedControl.selectedSegmentIndex == 2) {
        ClipCell *cell  = (ClipCell*)[tableView cellForRowAtIndexPath:indexPath];
        [self performSegueWithIdentifier:@"showSelf" sender:cell];
    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:@"showCharge"]) {
        return NO;
    }

    if ([identifier isEqualToString:@"showLogin"]) {
        return NO;
    }

    if ([identifier isEqualToString:@"showWriteReview"]) {
        return NO;
    }
    
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showSelf"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSInteger unNum = [indexPath indexAtPosition: 1 ];
        NSDictionary *selectedClip   = [self->clips objectAtIndex:unNum];
        NSString *strClipId = [selectedClip objectForKey:@"clip_id"];
        NSNumber *selectedClipId    = [NSNumber numberWithInteger:[strClipId intValue]];
        [[segue destinationViewController] setClipId:selectedClipId];
    }

    if ([[segue identifier] isEqualToString:@"showWriteReview"]) {
        [[segue destinationViewController] setClipId:self.clipId];
        [[segue destinationViewController] setDelegate:self];
    }
    
    if ([[segue identifier] isEqualToString:@"showCharge"]) {
//        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
//        NSInteger unNum = [indexPath indexAtPosition: 1 ];
//        NSDictionary *selectedClip   = [self->clips objectAtIndex:unNum];
//        NSString *strClipId = [selectedClip objectForKey:@"clip_id"];
//        NSNumber *selectedClipId    = [NSNumber numberWithInteger:[strClipId intValue]];
//        [[segue destinationViewController] setClipId:selectedClipId];
    }
}

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

- (CGSize)text:(NSString *)text sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size
{
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        CGRect frame = [text boundingRectWithSize:size
                                          options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                       attributes:@{NSFontAttributeName:font}
                                          context:nil];
        return frame.size;
    }
    else
    {
        return [text sizeWithFont:font constrainedToSize:size];
    }
}

- (CGFloat)textViewHeightForAttributedText:(NSAttributedString *)text andWidth:(CGFloat)width
{
    UITextView *textView = [[UITextView alloc] init];
    [textView setAttributedText:text];
    CGSize size = [textView sizeThatFits:CGSizeMake(width, CGFLOAT_MAX)];
    return size.height;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (self.segmentedControl.selectedSegmentIndex) {
        case 0:
        {
            switch (indexPath.row ) {
                case 0:
                {
                    return 134.;    // 상세 설명 -> 정보
                }
                    break;
                case 1:
                {
                    NSString *text = [self.clip objectForKey:@"clip_text"];
                    CGFloat width = 300.;
                    UIFont *font = [UIFont systemFontOfSize:15.];
                    NSAttributedString *attributedText =
                    [[NSAttributedString alloc]
                     initWithString:text
                     attributes:@
                     {
                     NSFontAttributeName: font
                     }];
                    CGRect rect = [attributedText boundingRectWithSize:(CGSize){width, CGFLOAT_MAX}
                                                               options:NSStringDrawingUsesLineFragmentOrigin
                                                               context:nil];
                    CGSize size = rect.size;
                    return size.height + 40.;
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 1:
        {
            if (indexPath.row == 0 && self.isLogin == YES) {
                return 60.;
            }
            
            if ([self.comments count] == 0) {
                return 80.;
            }
            
            int reviewWrite = self.isLogin? 1 : 0;
            NSDictionary *comment   = [self.comments objectAtIndex:indexPath.row-reviewWrite];
            NSString *text = [comment objectForKey:@"comment_text"];
            CGFloat width = 300.;
            UIFont *font = [UIFont systemFontOfSize:15.];
            NSAttributedString *attributedText =
            [[NSAttributedString alloc]
             initWithString:text
             attributes:@
             {
             NSFontAttributeName: font
             }];
            CGRect rect = [attributedText boundingRectWithSize:(CGSize){width, CGFLOAT_MAX}
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                       context:nil];
            CGSize size = rect.size;
            return size.height + 45.;
        }
            break;
        case 2:
            return 70.;
            break;
            
    }
    return 100.;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

 #pragma mark - Navigation

@end

NSString *GetSexString(int i) {
    if (i == 0) {
        return @"남성";
    }
    if (i == 1) {
        return @"여성";
    }
    return @"남성+여성";
}
