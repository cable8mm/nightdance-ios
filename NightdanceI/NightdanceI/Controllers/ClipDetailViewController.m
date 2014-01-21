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

@interface ClipDetailViewController ()
@property (nonatomic, retain) NSDictionary *clip;
@property (nonatomic, retain) IBOutlet UIImageView *thumbnail;
@property (nonatomic, retain) IBOutlet UILabel *clipTitle;
@property (nonatomic, retain) IBOutlet UILabel *clipCredit;
@property (nonatomic, retain) IBOutlet UIButton *previewButton;
@property (nonatomic, retain) IBOutlet UIButton *buyAndPlayButton;
@property (nonatomic, retain) IBOutlet UIButton *downloadButton;
@property (nonatomic, retain) IBOutlet UISegmentedControl *segmentedControl;
@property (strong ,nonatomic) NSMutableDictionary *cachedImages;
@property (nonatomic, retain) NSArray *clips;
@property (nonatomic, retain) NSMutableArray *comments;

- (IBAction)previewClip;
- (IBAction)playClip;
- (IBAction)buyAndPlayClip;
- (IBAction)contentChanged:(id)sender;
- (IBAction)presentActivities:(id)sender;
- (void) myMovieFinishedCallback: (NSNotification*)aNotification;
@end

@implementation ClipDetailViewController

@synthesize thumbnail, clip, clipId, clipTitle, buyAndPlayButton, downloadButton, clips, cachedImages;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[SKPaymentQueue defaultQueue] addTransactionObserver: self];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Style
    buyAndPlayButton.layer.cornerRadius = 4;
    buyAndPlayButton.layer.borderWidth = 1;
    buyAndPlayButton.layer.borderColor = buyAndPlayButton.tintColor.CGColor;
    buyAndPlayButton.layer.backgroundColor  = buyAndPlayButton.tintColor.CGColor;
    [buyAndPlayButton sizeToFit];

    downloadButton.layer.cornerRadius = 4;
    downloadButton.layer.borderWidth = 1;
    downloadButton.layer.borderColor = downloadButton.tintColor.CGColor;
    downloadButton.layer.backgroundColor  = downloadButton.tintColor.CGColor;
    [downloadButton sizeToFit];
    
    self.title  = @"강좌";
    
    UINib *cellNib = [UINib nibWithNibName:@"ClipDetailCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:@"ClipDetailCell"];
    
    if (self->clip == nil) {
        self->clip  = [SCManager getClip:[self.clipId intValue]];
        
        self.thumbnail.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[self.clip objectForKey:@"clip_thumbnail"]]]];
        self.thumbnail.contentMode  = UIViewContentModeScaleAspectFill;
        
        [self.clipTitle setNumberOfLines:0];
        [self.clipTitle sizeToFit];
        self.clipTitle.text  = [NSString stringWithFormat:@"%@%@", [self.clip objectForKey:@"clip_title"], @"\n\n\n\n\n"];
        
        self.clipCredit.text    = [self.clip objectForKey:@"clip_credit"];
        
        [self contentChanged:self.segmentedControl];
    }
    
    self.cachedImages = [[NSMutableDictionary alloc] init];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (IBAction)previewClip {
    // clip_hd_sample_url
    NSLog(@"preview clip : %@", [self.clip objectForKey:@"clip_hd_sample_url"]);
    
    NSURL *url = [NSURL URLWithString:[self.clip objectForKey:@"clip_hd_sample_url"]];

    _moviePlayer =  [[ClipPlayerViewController alloc] initWithContentURL:url];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(myMovieFinishedCallback:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:_moviePlayer.moviePlayer];
    
    [self presentMoviePlayerViewControllerAnimated:_moviePlayer];
}

- (void) myMovieFinishedCallback: (NSNotification*)notification {
    MPMoviePlayerController *player = [notification object];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:player];
    
    [player stop];
	
	[self dismissMoviePlayerViewControllerAnimated];
}

- (IBAction)buyAndPlayClip {
    [self requestProUpgradeProductData];
}

- (IBAction)contentChanged:(id)sender {
    NSInteger index = [(UISegmentedControl *)sender selectedSegmentIndex];
    NSLog(@"Content Changed = %d", index);
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
            self.clips  = [SCManager getClips];
        }
    }
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self.tableView reloadData];
}

- (IBAction)playClip {
    // clip_hd_url
    NSLog(@"play clip");
    
    NSURL *url = [NSURL URLWithString:[self.clip objectForKey:@"clip_hd_url"]];
    
    _moviePlayer =  [[ClipPlayerViewController alloc] initWithContentURL:url];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(myMovieFinishedCallback:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:_moviePlayer.moviePlayer];
    
    [self presentMoviePlayerViewControllerAnimated:_moviePlayer];
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

- (IBAction)presentActivities:(id)sender
{
    if( ![UIActivity class])
    {
        // UIActivity supported in iOS6
        // show error dialog
        return;
    }
    
    NSString *text = @"Hello World!";
    NSArray* actItems = [NSArray arrayWithObjects:
                         text, nil];
    
    UIActivityViewController *activityView = [[UIActivityViewController alloc]
                                               initWithActivityItems:actItems
                                               applicationActivities:nil];
    
    [self presentViewController:activityView
                       animated:YES
                     completion:nil];
}

#pragma mark - Purchase
- (void)requestProUpgradeProductData
{
    if ([SKPaymentQueue canMakePayments]) {
        NSLog(@"결제 가능");
        
        NSSet *productIdentifiers = [NSSet setWithObject:@"BUY_STAR_3"];
        productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
        productsRequest.delegate = self;
        [productsRequest start];
    } else {
        NSLog(@"결제 불가능");
    }
}
#pragma mark -
#pragma mark SKProductsRequestDelegate methods

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    for (SKProduct *product in response.products) {
        if (product != nil) {
            // 구매 요청
            SKPayment *payment  = [SKPayment paymentWithProduct:product];
            [[SKPaymentQueue defaultQueue] addPayment:payment];
            NSLog(@"구매 요청");
        }
    }
    
    for (NSString *invalidProductId in response.invalidProductIdentifiers)
    {
        NSLog(@"InAppPurchase Invalid product id: %@", invalidProductId);
    }
}

-(void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    NSLog(@"paymentQueue");

    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchasing:
                NSLog(@"서버에 거래 처리중 / PURCHASING_IAP_NOTIFICATION");
                break;
            case SKPaymentTransactionStatePurchased:
                NSLog(@"구매 완료 / PURCHASED_IAP_NOTIFICATION");
                
                [self completeTransaction:transaction];
                
                break;
            case SKPaymentTransactionStateFailed:
            {
                NSLog(@"거래 실패 또는 취소 / FAILED_IAP_NOTIFICATION");
                [self failedTransaction:transaction];
            }
                break;
            case SKPaymentTransactionStateRestored:
                NSLog(@"재구매 / RESTORED_IAP_NOTIFICATION");
                [self restoreTransaction:transaction];
                break;
        }
    }
}

-(void)completeTransaction:(SKPaymentTransaction *)transaction {
    NSLog(@"completeTransaction");
    
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    
//    std::string productId   = [transaction.payment.productIdentifier UTF8String];
//    cocos2d::CCString *productIdentifier     = cocos2d::CCString::create(productId.c_str());
//    
//    cocos2d::CCNotificationCenter::sharedNotificationCenter()->postNotification("PURCHASED_IAP_NOTIFICATION", productIdentifier);
}

-(void)restoreTransaction:(SKPaymentTransaction *)transaction {
    NSLog(@"restoreTransaction");
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    
//    cocos2d::CCNotificationCenter::sharedNotificationCenter()->postNotification("RESTORED_IAP_NOTIFICATION");
}

-(void)failedTransaction:(SKPaymentTransaction *)transaction {
    NSLog(@"failedTransaction");
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    
//    std::string productId   = [transaction.payment.productIdentifier UTF8String];
//    cocos2d::CCString *productIdentifier     = cocos2d::CCString::create(productId.c_str());
//    cocos2d::CCNotificationCenter::sharedNotificationCenter()->postNotification("FAILED_IAP_NOTIFICATION", productIdentifier);
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
            return 2;
            break;
        case 1:
            return [self.comments count] != 0? [self.comments count] : 1;   // 덧글 갯수
            break;
        case 2:         // 함께 보기
            return [self.clips count];
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
                    frame.size.height   = 300.;
                    informationCell.descriptionView.frame = frame;
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
        case 1:
        {
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
            
            NSInteger unNum = [indexPath indexAtPosition: 1 ];
            NSDictionary *comment   = [self.comments objectAtIndex:unNum];

            cell.nickname.text  = [comment objectForKey:@"nickname"];
            cell.created.text   = [comment objectForKey:@"created"];
            cell.descriptionView.text= [comment objectForKey:@"comment_text"];
            return cell;
        }
            break;
        case 2:
        {
//            static NSString *CellIdentifier = @"ClipCell";
//            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//            if (cell == nil) {
//                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
//            }
            
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
            cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
            
            NSString *clipThumbnail = [relatedClip objectForKey:@"clip_thumbnail_s"];
            NSString *identifier = [NSString stringWithFormat:@"RelatedCell%d",(int)indexPath.row];
            
            if([self.cachedImages objectForKey:identifier] != nil){
                cell.thumbnail.image = [self.cachedImages valueForKey:identifier];
            }else{
                char const * s = [identifier  UTF8String];
                dispatch_queue_t queue = dispatch_queue_create(s, 0);
                dispatch_async(queue, ^{
                    UIImage *img = nil;
                    NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:clipThumbnail]];
                    img = [[UIImage alloc] initWithData:data];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if ([tableView indexPathForCell:cell].row == indexPath.row) {
                            [self.cachedImages setValue:img forKey:identifier];
                            cell.thumbnail.image = [self.cachedImages valueForKey:identifier];
                        }
                    });
                });
            }

            return cell;
        }
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.segmentedControl.selectedSegmentIndex == 2) {
        ClipCell *cell  = (ClipCell*)[tableView cellForRowAtIndexPath:indexPath];
        [self performSegueWithIdentifier:@"showSelf" sender:cell];
    }
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
                    return 115.;
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
            if ([self.comments count] == 0) {
                return 80.;
            }
            
            NSDictionary *comment   = [self.comments objectAtIndex:indexPath.row];
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
