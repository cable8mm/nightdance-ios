//
//  NcashesViewController.m
//  NightdanceI
//
//  Created by cable8mm on 2014. 1. 31..
//  Copyright (c) 2014년 Lee Samgu. All rights reserved.
//

#import "NcashesViewController.h"
#import "SCManager.h"
#import "GlobalFunctions.h"
#import "ClipDetailViewController.h"

@interface NcashesViewController ()
@property (nonatomic, retain) NSArray *chargeList;
@end

@implementation NcashesViewController

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
    NSString *urlString = [SCManager getAuthUrl:@"get_charge_list.php"];
    NSDictionary *jsonData  = [SCManager getJsonData:urlString];
    
    if (jsonData == nil) {
        UIAlertView *alert =  [[UIAlertView alloc] initWithTitle:@"네트워크 에러"
                                                         message:@"네트워크가 원활하지 않습니다. 다시 시도해 주세요."
                                                        delegate:self
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
        [alert show];
    } else {
        self.chargeList = jsonData[@"chargeList"];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self.navigationController popViewControllerAnimated:YES];
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
    return [self.chargeList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    NSDictionary *ncash = [self.chargeList objectAtIndex:indexPath.row];
    cell.textLabel.text = [ncash objectForKey:@"log_time"];
    int logPayment    = [[ncash objectForKey:@"log_payment"] intValue];
    
    if (logPayment < 0) {
        cell.textLabel.textColor    = [UIColor redColor];
    } else {
        cell.textLabel.textColor    = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
    }
    
    NSString *logMethod = [ncash objectForKey:@"log_method"];
    if ([logMethod isEqualToString:@"c"]) {
        cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    } else {
        cell.accessoryType  = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.detailTextLabel.text   = [NSString stringWithFormat:@"%@ (%@%@) / %@ 코인",[ncash objectForKey:@"desc_name"], [ncash objectForKey:@"log_method"], [ncash objectForKey:@"log_method_detail"], GetCommaNumber(logPayment)];
    
    return cell;
}

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
    NSDictionary *ncash = [self.chargeList objectAtIndex:indexPath.row];
    NSString *logMethod = [ncash objectForKey:@"log_method"];
    if ([logMethod isEqualToString:@"c"] == NO) {
        return;
    }

    UITableViewCell *cell  = (UITableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"showDetail" sender:cell];
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
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    return NO;
}

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSInteger unNum = [indexPath indexAtPosition: 1 ];
        NSDictionary *charge   = [self.chargeList objectAtIndex:unNum];
        NSNumber *clipId    = [charge objectForKey:@"log_method_detail"];
        [[segue destinationViewController] setClipId:clipId];
    }

}

@end
