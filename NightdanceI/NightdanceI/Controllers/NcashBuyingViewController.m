//
//  NcashBuyingViewController.m
//  NightdanceI
//
//  Created by cable8mm on 2014. 1. 21..
//  Copyright (c) 2014년 Lee Samgu. All rights reserved.
//

#import "NcashBuyingViewController.h"
#import "BuyNcashCell.h"

@interface NcashBuyingViewController ()
@property(nonatomic, retain) NSArray *items;
-(IBAction)close:(id)sender;
-(void)pushBuyButton:(id)sender withEvent: (UIEvent *) event;
@end

@implementation NcashBuyingViewController

-(void)pushBuyButton:(id)sender withEvent: (UIEvent *) event {
    BuyNcashCell *buyNcashCell  = sender;
    NSLog(@"Tag = %d", buyNcashCell.tag);
}

-(IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

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
    
    self.items  = [NSArray arrayWithObjects:
                   [NSArray arrayWithObjects:@"1,000 엔캐시", @"$0.99", nil],
                   [NSArray arrayWithObjects:@"2,000 엔캐시", @"$1.99", nil],
                   [NSArray arrayWithObjects:@"3,000 엔캐시", @"$2.99", nil],
                   [NSArray arrayWithObjects:@"4,000 엔캐시", @"$3.99", nil],
                   [NSArray arrayWithObjects:@"5,000 엔캐시", @"$4.99", nil],
                   [NSArray arrayWithObjects:@"10,000 + 1,000 엔캐시", @"$9.99", nil],
                   [NSArray arrayWithObjects:@"20,000 + 3,000 엔캐시", @"$19.99", nil],
                   [NSArray arrayWithObjects:@"30,000 + 5,000 엔캐시", @"$29.99", nil],
                   [NSArray arrayWithObjects:@"50,000 + 10,000 엔캐시", @"$49.99", nil],
                   nil];
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
    return [self.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BuyNcashCell";
    BuyNcashCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        NSArray *nib    = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = (BuyNcashCell*)[nib objectAtIndex:0];

        // Configure the cell...
        [cell.buyButton becomeFirstResponder];
        cell.tag    = indexPath.row;
        cell.titleLabel.text = [[self.items objectAtIndex:indexPath.row] objectAtIndex:0];
        [cell.buyButton setTitle:[[self.items objectAtIndex:indexPath.row] objectAtIndex:1] forState:UIControlStateNormal];

        [cell.buyButton addTarget:self action:@selector(pushBuyButton:withEvent:) forControlEvents:UIControlEventTouchUpInside];
//        UIButton *button=[UIButton buttonWithType:UIButtonTypeRoundedRect];
//        button.tag=indexPath.row;
//        [button addTarget:self
//                   action:@selector(pushBuyButton:) forControlEvents:UIControlEventTouchDown];
//        [button setTitle:@"cellButton" forState:UIControlStateNormal];
//        button.frame = CGRectMake(80.0, 0.0, 160.0, 40.0);
//        [cell.contentView addSubview:button];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"didSelectIndexPathRow = %d", (int)indexPath.row);
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
