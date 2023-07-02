//
//  CategoriesViewController.m
//  NightdanceI
//
//  Created by cable8mm on 2014. 1. 10..
//  Copyright (c) 2014년 Lee Samgu. All rights reserved.
//

#import "CategoriesViewController.h"
#include "../Global.h"
#import "SCManager.h"
#import "ClipsPacksViewController.h"

@interface CategoriesViewController ()
@property (nonatomic, retain) NSMutableArray *categories;
@property (nonatomic, retain) NSIndexPath *checkedIndexPath;
@property(nonatomic) BOOL isNetworkAvailable;
- (IBAction)close:(id)sender;
@end

@implementation CategoriesViewController

@synthesize categories, checkedCategoryId, checkedIndexPath, delegate;

- (void) setIsNetworkAvailable:(BOOL)v {
    if (_isNetworkAvailable == v) {
        return;
    }
    
    _isNetworkAvailable = v;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//- (id)initWithStyle:(UITableViewStyle)style
//{
//    self = [super initWithStyle:style];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.extendedLayoutIncludesOpaqueBars   = YES;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    NSString *urlString   =  [SCManager getAuthUrl:@"get_categories.php"];
    NSDictionary *jsonData  = [SCManager getJsonData:urlString];
    
    if (jsonData == nil) {
        UIAlertView *alert =  [[UIAlertView alloc] initWithTitle:@"네트워크 에러"
                                                         message:@"네트워크가 원활하지 않습니다. 다시 시도해 주세요."
                                                        delegate:self
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
        [alert show];

    } else {
        self->categories = [[NSMutableArray alloc] init];
        NSDictionary *allCategory = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"99", @"전체 강좌", @"all", nil]
                                                                forKeys:[NSArray arrayWithObjects:@"id", @"name", @"path", nil]];
        [self->categories addObject:allCategory];
        [self->categories addObjectsFromArray:[jsonData objectForKey:@"categories"]];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)close:(id)sender {
    NSDictionary *category  = [self.categories objectAtIndex:self.checkedIndexPath.row];
    NSArray *receive    = [NSArray arrayWithObjects:[NSNumber numberWithInt:self.checkedCategoryId]
                           , [category objectForKey:@"name"]
                           , nil];
    [self.delegate recieveData:receive];
    [self dismissViewControllerAnimated:YES completion:nil];
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
    return [self->categories count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    NSInteger k = indexPath.row;
    NSDictionary *category   = [self->categories objectAtIndex:k];
//    NSString *categoryName  = [NSString stringWithFormat:@"%@ [%d개]", [category objectForKey:@"name"], 40];
    cell.textLabel.text = [category objectForKey:@"name"];
    cell.tag    = [[category objectForKey:@"id"] intValue];
    if(self.checkedCategoryId == cell.tag)
    {
        self.checkedIndexPath   = indexPath;
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if(self.checkedCategoryId != cell.tag)
    {
        UITableViewCell* uncheckCell = [tableView
                                        cellForRowAtIndexPath:self.checkedIndexPath];
        uncheckCell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    self.checkedCategoryId  = (int)cell.tag;
    self.checkedIndexPath    = indexPath;
    
    [self close:self];
//    NSArray *receive    = [NSArray arrayWithObject:[NSNumber numberWithInt:self.checkedCategoryId]];
//    [self.delegate recieveData:receive];
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

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
