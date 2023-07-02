//
//  ClipsPacksViewController.m
//  NightdanceI
//
//  Created by cable8mm on 2014. 1. 13..
//  Copyright (c) 2014년 Lee Samgu. All rights reserved.
//

#import "ClipsPacksViewController.h"
#import "SCManager.h"
#import "ClipCell.h"
#import "PackCell.h"
#import "ClipDetailViewController.h"
#import "PackDetailViewController.h"
#import "ClipMoreCell.h"
#import "CategoriesViewController.h"
#import "NDCache.h"
#import "UserManager.h"

@interface ClipsPacksViewController ()
@property(nonatomic, retain) NSMutableArray *clips;
@property(nonatomic, retain) NSArray *packs;
@property(nonatomic, retain) IBOutlet UISegmentedControl *clipPackButton;
@property(nonatomic, retain) IBOutlet UIBarButtonItem *categoryButton;
@property(nonatomic, retain) IBOutlet UIBarButtonItem *ticketButton;
@property (nonatomic) int pageNumber;
@property(nonatomic, getter = isNetworkAvailable) BOOL isNetworkAvailable;
- (IBAction)clipPackChanged:(id)sender;
@end

@implementation ClipsPacksViewController

@synthesize selectedCategoryId;
@synthesize isNetworkAvailable = _isNetworkAvailable;

// delegate Method
- (void)recieveData:(NSArray *)theData {
    //Do something with data here
    if (self.selectedCategoryId == [[theData objectAtIndex:0] intValue]) {
        return;
    }
    self.selectedCategoryId = [[theData objectAtIndex:0] intValue];
    self.categoryButton.title   = [theData objectAtIndex:1];
    NSLog(@"receiveData = %@", theData);
    [self reloadClips];
    [self.tableView scrollToRowAtIndexPath:
     [NSIndexPath indexPathForRow:0 inSection:0]
                        atScrollPosition:UITableViewScrollPositionBottom
                                animated:YES];
}

#pragma mark - IBActions
- (IBAction)clipPackChanged:(id)sender {    // 0 : 강좌, 1 : 패키지
    UISegmentedControl *topButton   = (UISegmentedControl*)sender;
    NSLog(@"clipPack = %d", (int)topButton.selectedSegmentIndex);
    
    // 카테고리 버튼
    if ([self isClipsViewed]) {
        self.categoryButton.enabled = true;
        self.categoryButton.title  = @"카테고리";
    } else {
        self.categoryButton.enabled = false;
        self.categoryButton.title  = @"";
    }
    
    if (self.packs == nil) {
        self.packs  = [SCManager getPackages];
        NSLog(@"packs = %@", self.packs);
    }
    [self.tableView reloadData];
}

- (BOOL) isClipsViewed {
    return self.clipPackButton.selectedSegmentIndex == 0;
}

- (BOOL) isPacksViewed {
    return self.clipPackButton.selectedSegmentIndex == 1;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.title  = @"강좌";
    }
    return self;
}

- (void)reloadClips {
    self.clips  = nil;
    self.pageNumber = 1;
    NSString *urlString;
    if (self.selectedCategoryId == 99) {
        urlString = [SCManager getAuthUrl:@"get_clips.php"];
    } else {
        NSString *params = [NSString stringWithFormat:@"category_id=%d&page=%d", self.selectedCategoryId, self.pageNumber];
        urlString = [SCManager getAuthUrl:@"get_clips.php" param:params];
    }
    
    self.pageNumber++;
    
    NSDictionary *jsonData  = [SCManager getJsonData:urlString];
    
    if (jsonData == nil) {
        self.isNetworkAvailable = NO;
    }
    
    self.clips  = [NSMutableArray arrayWithArray:jsonData[@"clips"]];
    [self.tableView reloadData];
}

- (void) setIsNetworkAvailable:(BOOL)v {
    if (_isNetworkAvailable == v) {
        return;
    }

    _isNetworkAvailable = v;
    
    self.categoryButton.enabled = self.ticketButton.enabled = _isNetworkAvailable;
}

- (BOOL) isNetworkAvailable {
    return _isNetworkAvailable;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _isNetworkAvailable = YES;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.selectedCategoryId = 99;   // 전체 보기
    
    [self reloadClips];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

//- (void) viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
//    [self reloadClips];
//     [self.tableView reloadData];
//}

- (void) getMoreClips {
    NSString *urlString;
    if (self.selectedCategoryId == 99) {
        NSString *params = [NSString stringWithFormat:@"category_id=%d&page=%d", self.selectedCategoryId, self.pageNumber];
        urlString = [SCManager getAuthUrl:@"get_clips.php" param:params];
    } else {
        NSString *params = [NSString stringWithFormat:@"category_id=%d&page=%d", self.selectedCategoryId, self.pageNumber];
        urlString = [SCManager getAuthUrl:@"get_clips.php" param:params];
    }
    
    NSDictionary *jsonData  = [SCManager getJsonData:urlString];
    
    self.isNetworkAvailable = jsonData != nil;
    
    if (self.isNetworkAvailable) {
        self.pageNumber++;
        [self.clips addObjectsFromArray:jsonData[@"clips"]];
        //    self.clips  = [NSMutableArray arrayWithArray:[SCManager getClips:[self.clips count]]];
        [self.tableView reloadData];
    } else {
        UIAlertView *alert =  [[UIAlertView alloc] initWithTitle:@"네트워크 에러"
                                                         message:@"네트워크가 원활하지 않습니다."
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];;
        [alert show];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    if ([self isClipsViewed] == YES) {
        return [self.clips count] + 1;
    }
    if ([self isPacksViewed] == YES) {
        return [self.packs count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self isClipsViewed] == YES) {
        if (indexPath.row == [self.clips count]) {  // 모어 버튼
            static NSString *CellIdentifier = @"ClipMoreCell";
            ClipMoreCell *cell = (ClipMoreCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil) {
                NSArray *nib    = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
                cell = (ClipMoreCell*)[nib objectAtIndex:0];
            }
            
            cell.messageLabel.text  = @"더 보기";
            return cell;
        }
        
        static NSString *CellIdentifier = @"ClipCell";
        ClipCell *cell = (ClipCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            NSArray *nib    = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
            cell = (ClipCell*)[nib objectAtIndex:0];
        }
        
        // Configure the cell...
        NSInteger unNum = [indexPath indexAtPosition: 1 ];
        NSDictionary *clip   = [self.clips objectAtIndex:unNum];
        cell.titleLabel.text = [NSString stringWithFormat:@"%d. %@",(int)unNum+1, [clip objectForKey:@"clip_title"]];
        cell.dancer.text    = [clip objectForKey:@"music_title"];
        NSString *star1 = [clip objectForKey:@"clip_rate1"];
        NSString *star2 = [clip objectForKey:@"clip_rate2"];
        cell.starsView1.score = [star1 intValue];
        cell.starsView2.score = [star2 intValue];
        cell.commentCount   = [clip objectForKey:@"comment_count"];
        
        cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;

//        NSString *clipThumbnail = [clip objectForKey:@"clip_thumbnail_s"];
//        NSString *identifier = [NSString stringWithFormat:@"Cell%d",(int)indexPath.row];
        
        NSString *clipThumbnail = [clip objectForKey:@"clip_thumbnail"];
        [[NDCache sharedObject] assignCachedImage:clipThumbnail
                                  completionBlock:^(UIImage *image) {
                                      if (image != nil) {
                                          cell.thumbnail.image  = image;
                                      }
                                  }];
        return cell;
    }

    if ([self isPacksViewed] == YES) {
        static NSString *CellIdentifier = @"PackCell";
        UINib *cellNib = [UINib nibWithNibName:CellIdentifier bundle:nil];
        [self.tableView registerNib:cellNib forCellReuseIdentifier:CellIdentifier];
        
        PackCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

        NSString *packThumbnail = [[self.packs objectAtIndex:indexPath.row] objectForKey:@"thumbnail"];
        [[NDCache sharedObject] assignCachedImage:packThumbnail
                                  completionBlock:^(UIImage *image) {
                                      if (image != nil) {
                                          cell.thumbnail.image  = image;
                                      }
                                  }];
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self isPacksViewed] == YES) {
        return 90.;
    }
    return 70.;
}

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here, for example:
    // Create the next view controller.
    //    ClipDetailViewController *detailViewController = [[ClipDetailViewController alloc] initWithNibName:@"ClipDetailViewController" bundle:nil];
    //
    //    // Pass the selected object to the new view controller.
    //
    //    // Push the view controller.
    //    [self.navigationController pushViewController:detailViewController animated:YES];
    if ([self isClipsViewed] == YES) {
        if (indexPath.row == [self.clips count]) {
            ClipMoreCell *cell  = (ClipMoreCell*)[tableView cellForRowAtIndexPath:indexPath];
            [cell.activityIndicator startAnimating];
            [self getMoreClips];
            [cell.activityIndicator stopAnimating];
            return;
        }
        ClipCell *cell  = (ClipCell*)[tableView cellForRowAtIndexPath:indexPath];
        [self performSegueWithIdentifier:@"showDetail" sender:cell];
    }
    
    if ([self isPacksViewed] == YES) {
        PackCell *cell  = (PackCell*)[tableView cellForRowAtIndexPath:indexPath];
        [self performSegueWithIdentifier:@"showDetailPack" sender:cell];
    }
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

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"showCategories"]) {
        UINavigationController *navController = segue.destinationViewController;
        CategoriesViewController *categoryesViewController = (CategoriesViewController*)navController.topViewController;
        categoryesViewController.checkedCategoryId  = self.selectedCategoryId;
        categoryesViewController.delegate   = self;
    }
    
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSInteger unNum = [indexPath indexAtPosition: 1 ];
        NSDictionary *clip   = [self.clips objectAtIndex:unNum];
        NSString *strClipId = [clip objectForKey:@"clip_id"];
        NSNumber *clipId    = [NSNumber numberWithInteger:[strClipId intValue]];
        [[segue destinationViewController] setClipId:clipId];
    }
    
    if ([[segue identifier] isEqualToString:@"showDetailPack"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSInteger unNum = [indexPath indexAtPosition: 1 ];
        NSDictionary *clip   = [self.packs objectAtIndex:unNum];
        NSString *strClipId = [clip objectForKey:@"id"];
        NSNumber *packId    = [NSNumber numberWithInteger:[strClipId intValue]];
        [[segue destinationViewController] setPackId:packId];
    }
}

@end
