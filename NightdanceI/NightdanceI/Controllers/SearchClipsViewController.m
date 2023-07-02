//
//  SearchClipsViewController.m
//  NightdanceI
//
//  Created by cable8mm on 2014. 1. 11..
//  Copyright (c) 2014년 Lee Samgu. All rights reserved.
//

#import "SearchClipsViewController.h"
#include "../Global.h"
#include "SCManager.h"
#import "ClipCell.h"
#import "ClipDetailViewController.h"
#import "NDCache.h"
#import "ClipMoreCell.h"

@interface SearchClipsViewController ()
@property(nonatomic, retain) NSString *queryString;
@property(strong, retain) NSMutableArray *clips;
@property (nonatomic) int pageNumber;
@property (nonatomic) BOOL isNext;
@end

@implementation SearchClipsViewController

@synthesize queryString, clips, clipSearchBar;

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
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

    self.pageNumber = 0;
    self.isNext = YES;
    
    UINib *cellNib = [UINib nibWithNibName:@"ClipCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:@"ClipCell"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    searchBar.showsScopeBar = YES;
    [searchBar sizeToFit];
    [searchBar setShowsCancelButton:YES animated:YES];
    
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    searchBar.showsScopeBar = NO;
    [searchBar sizeToFit];
    [searchBar setShowsCancelButton:NO animated:YES];
    
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.text  = @"";
    [searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    self.pageNumber = 0;
    // Do the search...
    self.queryString    = searchBar.text;
    if (self.clips != nil) {
        [self.clips removeAllObjects];
        self.clips  = nil;
    }
    self.clips  = [[NSMutableArray alloc] init];
    [self getMoreClips];
}

- (void) getMoreClips {
    self.pageNumber++;
    NSString *queryWord = [self.queryString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *params = [NSString stringWithFormat:@"word=%@&page=%d", queryWord, self.pageNumber];
    NSString *urlString = [SCManager getAuthUrl:@"search_clips.php" param:params];
    
    NSDictionary *jsonData  = [SCManager getJsonData:urlString];
    
    if (jsonData != nil) {
        [self.clips addObjectsFromArray:jsonData[@"clips"]];
        self.isNext = [jsonData[@"is_next"] boolValue];
        
        [self.tableView reloadData];
        
        if ([self.clips count] == 0) {
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"검색 결과 없음"
                                                              message:@"다른 검색어를 넣어보세요."
                                                             delegate:nil
                                                    cancelButtonTitle:nil
                                                    otherButtonTitles:@"확인", nil];
            [message show];
        }
    } else {
        UIAlertView *alert =  [[UIAlertView alloc] initWithTitle:@"네트워크 에러"
                                                         message:@"네트워크가 원활하지 않습니다. 다시 시도해 주세요."
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
        [alert show];
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
    if ([self.clips count] == 0) {
        return 0;
    }
    
    if (self.isNext) {
        return [self.clips count] + 1;
    } else {
        return [self.clips count];
    }

    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
    cell.commentCount = [clip objectForKey:@"comment_count"];

    cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;

    
//    NSInteger unNum = [indexPath indexAtPosition: 1 ];
//    NSDictionary *clip   = [self->clips objectAtIndex:unNum];
//    cell.titleLabel.text = [clip objectForKey:@"clip_title"];
//    cell.dancer.text    = [clip objectForKey:@"music_title"];
//    NSString *star1 = [clip objectForKey:@"clip_rate1"];
//    NSString *star2 = [clip objectForKey:@"clip_rate2"];
//    cell.starsView1.score = [star1 intValue];
//    cell.starsView2.score = [star2 intValue];
//    cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
    
    NSString *clipThumbnail = [clip objectForKey:@"clip_thumbnail"];
    [[NDCache sharedObject] assignCachedImage:clipThumbnail
                              completionBlock:^(UIImage *image) {
                                  cell.thumbnail.image  = image;
                              }];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.;
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

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSInteger unNum = [indexPath indexAtPosition: 1 ];
        NSDictionary *clip   = [self->clips objectAtIndex:unNum];
        NSString *strClipId = [clip objectForKey:@"clip_id"];
        NSNumber *clipId    = [NSNumber numberWithInteger:[strClipId intValue]];
        [[segue destinationViewController] setClipId:clipId];
    }
}
@end
