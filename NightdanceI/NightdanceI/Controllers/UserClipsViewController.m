//
//  UserClipsViewController.m
//  NightdanceI
//
//  Created by cable8mm on 2014. 1. 23..
//  Copyright (c) 2014년 Lee Samgu. All rights reserved.
//

#import "UserClipsViewController.h"
#import "SCManager.h"
#import "ScrapClipCell.h"
#import "PackCell.h"
#import "ClipDetailViewController.h"
#import "NDCache.h"
#import "UserManager.h"

@interface UserClipsViewController ()
@property(nonatomic) BOOL isLogin;
@property(nonatomic, retain) NSMutableArray *scrapClips;
@property(nonatomic, retain) NSMutableArray *purchasedClips;
@property(nonatomic) int selectedMode;  // 0 = 구입한 강좌, 1 = 찜한 강좌
@property(nonatomic, retain) UIRefreshControl *refresh;
@property(nonatomic, retain) IBOutlet UISegmentedControl *segmentedControl;
-(IBAction)changedMode:(id)sender;
@end

@implementation UserClipsViewController

@synthesize selectedMode;

#pragma mark - Accessors
- (void)setIsLogin:(BOOL)isLogin {
    _isLogin    = isLogin;
    
//    if (_isLogin) {
//        self.refreshControl = self.refresh;
//        self.selectedMode   = self.segmentedControl.selectedSegmentIndex;
//    } else {
//        self.refreshControl = nil;
//        self.selectedMode   = 1;
//    }
}

-(void)setSelectedMode:(int) mode {
    if (self.isLogin == NO) {
        selectedMode    = 1;
        self.purchasedClips = nil;
        self.scrapClips = nil;
        [self.tableView reloadData];
        return;
    }
    
    selectedMode   = mode;
    
    if (mode == 1) {
        if ([UserManager isViewedScrapingClip]) {
            [self refreshView:self.refresh];
            [UserManager setViewedScrapingClip:NO];
        }
    }
    
    if (mode == 0) {
        if ([UserManager isViewedPurchasingClip]) {
            [self refreshView:self.refresh];
            [UserManager setViewedPurchasingClip:NO];
        }

    }

    if (mode == 1 && self.scrapClips == nil) {
        [self reloadScrapClips];
    } else if (mode == 0 && self.purchasedClips == nil) {
        [self reloadPurchaseClips];
    }
    
    [self.tableView reloadData];
}

#pragma mark - IBActions
-(IBAction)changedMode:(id)sender {
    UISegmentedControl *modes   = (UISegmentedControl*)sender;
    [self setSelectedMode:(int)modes.selectedSegmentIndex];
}

#pragma mark - Action Methods
- (void)reloadPurchaseClips {
    self.purchasedClips = nil;
    NSString *urlString = [SCManager getAuthUrl:@"get_buy_list.php"];
    NSDictionary *jsonData  = [SCManager getJsonData:urlString];
    NSLog(@"%@", jsonData);
    self.purchasedClips  = [NSMutableArray arrayWithArray:jsonData[@"clips"]];
}

- (void)reloadScrapClips {
    self.scrapClips = nil;
    if ([UserManager isLogin]) {
        NSString *urlString = [SCManager getAuthUrl:@"get_wish_clips.php"];
        NSDictionary *jsonData  = [SCManager getJsonData:urlString];
        NSLog(@"%@", jsonData);
        self.scrapClips  = [NSMutableArray arrayWithArray:jsonData[@"clips"]];
    } else {
        NSArray *scrapedClips   = [UserManager getScrapedClips];
        if ([scrapedClips count] > 0) {
            NSString *scrapedClipsString    = [scrapedClips componentsJoinedByString:@","];
            NSString *params    = [NSString stringWithFormat:@"clip_ids=%@", scrapedClipsString];
            NSString *urlString = [SCManager getAuthUrl:@"get_clips_from_ids.php" param:params];
            NSDictionary *jsonData  = [SCManager getJsonData:urlString];
            NSLog(@"%@", jsonData);
            self.scrapClips  = [NSMutableArray arrayWithArray:jsonData[@"clips"]];
        }
    }
    [self.tableView reloadData];
}

#pragma mark - Notification Observers
- (void) login:(NSNotification *) notification {
    NSNumber *isLogin  = [[notification userInfo] objectForKey:@"IS_LOGIN"];
    self.isLogin    = [isLogin boolValue];
}

- (void) icloudUpdated:(NSNotification *) notification {
    NSArray *scrapedClips   = [UserManager getScrapedClips];
    if ([scrapedClips count] != [self.scrapClips count]) {
        [self reloadScrapClips];
    }
}

#pragma mark - Life Cycle Methods
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // initialize
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(login:) name:@"NOTI_USER_LOGINOUT" object:nil];
    // ICLOUD_UPDATED
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(icloudUpdated:) name:@"ICLOUD_UPDATED" object:nil];
    
    self.selectedMode    = 1;   // 찜 동영상
    
    // UI initialize
    self.refresh = [[UIRefreshControl alloc] init];
    self.refresh.attributedTitle = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Pull to Refresh", nil) ];
    [self.refresh addTarget:self
                            action:@selector(refreshView:)
                  forControlEvents:UIControlEventValueChanged];
    self.isLogin    = [UserManager isLogin];
    
    self.refreshControl = self.refresh;
    [self reloadScrapClips];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    if ([UserManager isViewedPurchasingClip]) {
        [self refreshView:self.refresh];
        [UserManager setViewedPurchasingClip:NO];
    }
    
    if ([UserManager isViewedScrapingClip]) {
        [self refreshView:self.refresh];
        [UserManager setViewedScrapingClip:NO];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Selectors
-(void)refreshView:(UIRefreshControl *)refresh {
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Refreshing clips...", nil)];
    
    if (self.selectedMode == 1) {
        [self reloadScrapClips];
    }
    
    if (self.selectedMode == 0) {
        [self reloadPurchaseClips];
    }
    
    [refresh endRefreshing];
    [self.tableView reloadData];
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
    if (self.selectedMode == 0) {
        return [self.purchasedClips count];
    } else if (self.selectedMode == 1) {
        return [self.scrapClips count];
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // Configure the cell...
    id cell;
    NSDictionary *clip;
    if (self.selectedMode == 0) {   // 구입한 강좌
        static NSString *CellIdentifier = @"ScrapClipCell";
        ScrapClipCell *cell = (ScrapClipCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];

        if (cell == nil) {
            NSArray *nib    = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
            cell = (ScrapClipCell*)[nib objectAtIndex:0];
        }

        clip  = [self.purchasedClips objectAtIndex:indexPath.row];
        cell.titleLabel.text = [clip objectForKey:@"clip_title"];
        cell.dancer.text    = [clip objectForKey:@"clip_credit"];
//        cell.scrapedLabel.text    = [clip objectForKey:@"scraped"];
        cell.song.text  = [clip objectForKey:@"music_title"];
        cell.tag = [[clip objectForKey:@"clip_id"] intValue];
        
        NSString *clipThumbnail = [clip objectForKey:@"clip_thumbnail"];
        [[NDCache sharedObject] assignCachedImage:clipThumbnail
                                  completionBlock:^(UIImage *image) {
                                      cell.thumbnail.image  = image;
                                  }];
        
        return cell;
    }
    if (self.selectedMode == 1) {
        static NSString *CellIdentifier = @"ScrapClipCell";
        ScrapClipCell *cell = (ScrapClipCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            NSArray *nib    = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
            cell = (ScrapClipCell*)[nib objectAtIndex:0];
        }
        
        clip  = [self.scrapClips objectAtIndex:indexPath.row];
        cell.titleLabel.text = [clip objectForKey:@"clip_title"];
        cell.dancer.text    = [clip objectForKey:@"clip_credit"];
        cell.scrapedLabel.text    = [clip objectForKey:@"scraped"];
        cell.song.text  = [clip objectForKey:@"music_title"];
        cell.tag = [[clip objectForKey:@"clip_id"] intValue];
        
        NSString *clipThumbnail = [clip objectForKey:@"clip_thumbnail"];
        [[NDCache sharedObject] assignCachedImage:clipThumbnail
                                  completionBlock:^(UIImage *image) {
                                      cell.thumbnail.image  = image;
                                  }];
        return cell;
    }
    
    if (self.selectedMode == 2) {
        static NSString *CellIdentifier = @"LoginCell";
        UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            NSArray *nib    = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
            cell = (UITableViewCell*)[nib objectAtIndex:0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }

    return cell;
}

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectedMode == 0) {
        UITableViewCell *cell = (UITableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
        [self performSegueWithIdentifier:@"showDetail" sender:cell];
    } else if(self.selectedMode == 1) {
        ScrapClipCell *cell = (ScrapClipCell*)[tableView cellForRowAtIndexPath:indexPath];
        [self performSegueWithIdentifier:@"showDetail" sender:cell];
    } else {
    }
    //    [self.navigationController pushViewController:detailViewController animated:YES];
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return self.selectedMode == 1;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectedMode == 1) {
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            // Delete the row from the data source
            if ([UserManager isLogin]) {
                ScrapClipCell *cell = (ScrapClipCell*)[tableView cellForRowAtIndexPath:indexPath];
                NSString *param = [NSString stringWithFormat:@"clip_id=%d",(int)cell.tag];
                NSString *urlString = [SCManager getAuthUrl:@"remove_wish_clip.php" param:param];
                [SCManager getJsonData:urlString];
                [self.scrapClips removeObjectAtIndex:indexPath.row];
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            } else {
                ScrapClipCell *cell = (ScrapClipCell*)[tableView cellForRowAtIndexPath:indexPath];
                [UserManager removeScrapedClip:[NSNumber numberWithInteger:cell.tag]];
                [self.scrapClips removeObjectAtIndex:indexPath.row];
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
        }
        else if (editingStyle == UITableViewCellEditingStyleInsert) {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }   
    }
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.selectedMode != 1;
}

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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSInteger unNum = [indexPath indexAtPosition: 1 ];
        NSDictionary *clip;
        if (self.selectedMode == 1) {
            clip   = [self.scrapClips objectAtIndex:unNum];
        } else {
            clip   = [self.purchasedClips objectAtIndex:unNum];
        }
        
        NSString *strClipId = [clip objectForKey:@"clip_id"];
        NSNumber *clipId    = [NSNumber numberWithInteger:[strClipId intValue]];
        [[segue destinationViewController] setClipId:clipId];
    }
}

@end
