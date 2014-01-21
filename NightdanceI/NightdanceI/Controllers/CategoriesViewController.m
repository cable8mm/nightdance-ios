//
//  CategoriesViewController.m
//  NightdanceI
//
//  Created by cable8mm on 2014. 1. 10..
//  Copyright (c) 2014년 Lee Samgu. All rights reserved.
//

#import "CategoriesViewController.h"
#include "../Global.h"

@interface CategoriesViewController ()
@property (nonatomic, retain) NSMutableArray *categories;
- (IBAction)close:(id)sender;
@end

@implementation CategoriesViewController

@synthesize categories;

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
    
    NSString *clipUrlString   = [[NSString alloc] initWithFormat:@"%@%@%@", API_ROOT_URL, @"get_categories.php?token=", TOKEN];
    NSURL *clipUrl = [[NSURL alloc] initWithString:clipUrlString];
    NSData *clipData    = [[NSData alloc] initWithContentsOfURL:clipUrl];
    NSError *error;
    NSDictionary *dicCategories  = [NSJSONSerialization
                         JSONObjectWithData:clipData
                         options:NSJSONReadingAllowFragments
                         error:&error];
    
    self->categories = [[NSMutableArray alloc] init];
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    } else {
        NSDictionary *allCategory = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"99", @"전체 강좌", @"all", nil]
                                                                forKeys:[NSArray arrayWithObjects:@"id", @"name", @"path", nil]];
        [self->categories addObject:allCategory];
        for (id key in [dicCategories allKeys]) {
            if ([key integerValue] > 0 || [key length] < 3) {
                [self->categories addObject:[dicCategories objectForKey:key]];
            }
        }
        NSLog(@"Success Parsing %@", self->categories);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
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
    cell.textLabel.text = [category objectForKey:@"name"];
    return cell;
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
