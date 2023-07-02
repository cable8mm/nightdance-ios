//
//  ClipTableViewController.m
//  NightdanceI
//
//  Created by cable8mm on 2013. 12. 15..
//  Copyright (c) 2013년 Lee Samgu. All rights reserved.
//

#import "ClipTableViewController.h"
#include "../Global.h"
#import "ClipDetailViewController.h"
#import "ClipCell.h"
#import "StarsView.h"
#import "SCManager.h"
#import "NDCache.h"

@interface ClipTableViewController ()
@property (nonatomic, retain) NSArray *clips;
@property (strong ,nonatomic) NSMutableDictionary *cachedImages;
@end

@implementation ClipTableViewController

@synthesize clips;

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
    // http://www.intertech.com/Blog/basic-json-parsing-in-ios/
    
//    self.title  = @"Weekly 20";
    UINib *cellNib = [UINib nibWithNibName:@"ClipCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:@"ClipCell"];
    
    self.cachedImages = [[NSMutableDictionary alloc] init];

    if (self.clips == nil) {
        self.clips  = [NSMutableArray arrayWithArray:[SCManager getClips]];
        [self.tableView reloadData];
    }
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
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
    return [self->clips count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ClipCell";
    
    // - (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier

    ClipCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[ClipCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSInteger unNum = [indexPath indexAtPosition: 1 ];
    NSDictionary *clip   = [self->clips objectAtIndex:unNum];
    cell.titleLabel.text = [NSString stringWithFormat:@"%d. %@",(int)unNum+1, [clip objectForKey:@"clip_title"]];
    cell.dancer.text    = [clip objectForKey:@"music_title"];
    NSString *star1 = [clip objectForKey:@"clip_rate1"];
    NSString *star2 = [clip objectForKey:@"clip_rate2"];
    cell.starsView1.score = [star1 intValue];
    cell.starsView2.score = [star2 intValue];
    cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;

    NSString *clipThumbnail = [clip objectForKey:@"clip_thumbnail"];
//    NSString *identifier = [NSString stringWithFormat:@"Cell%d",(int)indexPath.row];
    
    [[NDCache sharedObject] assignCachedImage:clipThumbnail
                              completionBlock:^(UIImage *image) {
                                  cell.thumbnail.image  = image;
                              }];
    
//    if([self.cachedImages objectForKey:identifier] != nil){
//        cell.thumbnail.image = [self.cachedImages valueForKey:identifier];
//    }else{
//        char const * s = [identifier  UTF8String];
//        dispatch_queue_t queue = dispatch_queue_create(s, 0);
//        dispatch_async(queue, ^{
//            UIImage *img = nil;
//            NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:clipThumbnail]];
//            img = [[UIImage alloc] initWithData:data];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                if ([tableView indexPathForCell:cell].row == indexPath.row) {
//                    [self.cachedImages setValue:img forKey:identifier];
//                    cell.thumbnail.image = [self.cachedImages valueForKey:identifier];
//                }
//            });
//        });
//    }
    
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

#pragma mark - Table view delegate

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
    ClipCell *cell  = (ClipCell*)[tableView cellForRowAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"showDetail" sender:cell];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
//        NSDate *object = [[NSDate alloc] init];
        NSInteger unNum = [indexPath indexAtPosition: 1 ];
        NSDictionary *clip   = [self->clips objectAtIndex:unNum];
        NSString *strClipId = [clip objectForKey:@"clip_id"];
        NSNumber *clipId    = [NSNumber numberWithInteger:[strClipId intValue]];
        [[segue destinationViewController] setClipId:clipId];
    }
}

@end
