//
//  TicketsViewController.m
//  NightdanceI
//
//  Created by cable8mm on 2014. 2. 2..
//  Copyright (c) 2014년 Lee Samgu. All rights reserved.
//

#import "TicketsViewController.h"
#import "SCManager.h"
#import "TicketCell.h"
#import "NDCache.h"
#import "GlobalFunctions.h"
#import "UserManager.h"
#import "NDIAPHelper.h"

@interface TicketsViewController () {
    NSArray *_products;
    NSNumberFormatter * _priceFormatter;
}
@property(nonatomic, retain) NSArray *ticketList;
@property(nonatomic, retain) NSIndexPath *selectedIndexPath;
@property(nonatomic) BOOL isNetworkAvailable;

@end

@implementation TicketsViewController

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
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(reload) forControlEvents:UIControlEventValueChanged];
    [self reload];
    [self.refreshControl beginRefreshing];
    
    _priceFormatter = [[NSNumberFormatter alloc] init];
    [_priceFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [_priceFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    
    NSString *urlString = [SCManager getAuthUrl:@"get_tickets.php"];
    NSDictionary *jsonData  = [SCManager getJsonData:urlString];
    
    self.isNetworkAvailable = jsonData != nil;
    
    if (self.isNetworkAvailable) {
        self.ticketList = jsonData[@"tickets"];
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

- (void)viewWillAppear:(BOOL)animated {
    //
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(expiryDateUpdated:) name:@"EXPIRY_DATE_UPDATED" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:IAPHelperProductPurchasedNotification object:nil];
    // NOTI_USER_LOGINOUT
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)expiryDateUpdated:(NSNotification *)notification {
    NSDictionary *userInfo  = [notification userInfo];
    
    NSString *message   = [NSString stringWithFormat:@"%@일 자유이용권이 구입되었습니다.", userInfo[@"EXPIRY_DATE_UPDATED"]];
    [self.tableView reloadData];
    [[[UIAlertView alloc] initWithTitle:message
                               message:nil
                              delegate:nil
                     cancelButtonTitle:@"확인"
                      otherButtonTitles:nil] show];
}

- (void)productPurchased:(NSNotification *)notification {
    
    NSString * productIdentifier = notification.object;
    [_products enumerateObjectsUsingBlock:^(SKProduct * product, NSUInteger idx, BOOL *stop) {
        if ([product.productIdentifier isEqualToString:productIdentifier]) {
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:idx inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            *stop = YES;
        }
    }];
}

- (void)reload {
    _products = nil;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    [[NDIAPHelper sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
        if (success) {
            _products = products;
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
        }
        [self.refreshControl endRefreshing];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - AlertView Callbacks
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == -1) {
        [self.navigationController popViewControllerAnimated:YES];
         return;
    }
    if (alertView.tag == 1 && buttonIndex == 1) { // 구입
        NSDictionary *ticketInfo    = [self.ticketList objectAtIndex:self.selectedIndexPath.row];

        NSString *params    = [NSString stringWithFormat:@"type=t&number=%@", [ticketInfo objectForKey:@"ticket_id"]];
        NSString *urlString = [SCManager getAuthUrl:@"submit_stat.php" param:params];
        NSDictionary *jsonData  = [SCManager getJsonData:urlString];
        
        BOOL isBuying   = [jsonData[@"is_buying"] boolValue];
        NSNumber *userNcash = jsonData[@"user"][@"user_mobile_ncash"];
        [UserManager setNcash:userNcash];
        
        NSString *message   = (isBuying == YES)? @"자유이용권이 구입되었습니다." : @"엔캐쉬 부족으로 구입하지 못했습니다.";
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil
                                                       message:message
                                                      delegate:self
                                             cancelButtonTitle:nil
                                             otherButtonTitles:@"확인", nil];
        alert.tag   = 2;
        [alert show];
        return;
    } else if(alertView.tag == 3 && buttonIndex == 1) {
        [self.tabBarController setSelectedIndex:4];
        [self.tableView deselectRowAtIndexPath:self.selectedIndexPath animated:YES];
        return;
    }else {
        [self.tableView deselectRowAtIndexPath:self.selectedIndexPath animated:YES];
        return;
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
//    return [self.ticketList count];
    return _products.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TicketCell";
    TicketCell *cell = (TicketCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        NSArray *nib    = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = (TicketCell*)[nib objectAtIndex:0];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    
    SKProduct * product = (SKProduct *) _products[indexPath.row];
    cell.lbTicketName.text = product.localizedTitle;

    [_priceFormatter setLocale:product.priceLocale];
    cell.lbTicketPrice.text = [_priceFormatter stringFromNumber:product.price];

    NSNumber *term    = [[NDIAPHelper sharedInstance] getProductInfo:product.productIdentifier][@"term"];
    cell.lbTicketTerm.text  = [NSString stringWithFormat:@"%@ 일", term];

    NSString *imageUrl    = [[NDIAPHelper sharedInstance] getProductInfo:product.productIdentifier][@"imageUrl"];
    [[NDCache sharedObject] assignCachedImage:imageUrl
                              completionBlock:^(UIImage *image) {
                                  cell.ivTicketThumbnail.image  = image;
                              }];

    if ([[NDIAPHelper sharedInstance] productPurchased:product.productIdentifier]) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }

    return cell;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 60)];
        [headerView setBackgroundColor:[UIColor whiteColor]];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 2, tableView.bounds.size.width - 20, 60)];
        label.text = [UserManager getExpiryDateString];
        label.textColor = [UIColor blackColor];
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor clearColor];
        [headerView addSubview:label];
        return headerView;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 66.0f;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if (self.isNetworkAvailable && _products.count != 0) {
        return @"자유이용권을 구입하면 아이클라우드로 연결 된 모든 디바이스에서 동영상을 시청할 수 있습니다.";
    } else {
        return nil;
    }
}

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SKProduct *product = _products[indexPath.row];
    NSLog(@"Ticket Buying %@...", product.productIdentifier);
    [[NDIAPHelper sharedInstance] buyProduct:product];
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
