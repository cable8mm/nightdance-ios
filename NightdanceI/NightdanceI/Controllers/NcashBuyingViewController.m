//
//  NcashBuyingViewController.m
//  NightdanceI
//
//  Created by cable8mm on 2014. 1. 21..
//  Copyright (c) 2014년 Lee Samgu. All rights reserved.
//

#import "NcashBuyingViewController.h"
#import "BuyNcashCell.h"
#import "SCManager.h"
#import "SKProduct+LocalizedPrice.h"

@interface SKProduct (Price)
- (NSComparisonResult)comparePrice:(SKProduct*)productB;
@end

@implementation SKProduct (Price)
- (NSComparisonResult)comparePrice:(SKProduct*)productB
{
    // Compare the product titles
    return [self.price compare:productB.price];
}
@end

@interface NcashBuyingViewController ()
@property(nonatomic, retain) NSArray *items;
@property(nonatomic, retain) NSArray *products;
-(IBAction)close:(id)sender;
-(void)pushBuyButton:(id)sender;
@end

@implementation NcashBuyingViewController

-(void)validateProductIdentifiers:(NSArray *)productIds {
    SKProductsRequest *productsRequest = [[SKProductsRequest alloc]
                                          initWithProductIdentifiers:[NSSet setWithArray:productIds]];
    productsRequest.delegate = self;
    [productsRequest start];
}

-(void)pushBuyButton:(id)sender {
    BuyNcashCell *buyNcashCell  = sender;
    NSLog(@"Tag = %d", (int)buyNcashCell.tag);
    [self requestProduct:(int)buyNcashCell.tag];
}

-(IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Purchase
- (void)requestProduct:(int)key
{
    if ([SKPaymentQueue canMakePayments]) {
        SKProduct *product  = [self.products objectAtIndex:key];
        SKMutablePayment *payment = [SKMutablePayment paymentWithProduct:product];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    } else {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"결제 진행 불가"
                                                          message:@"설정>일반>차단에서 \"App 내 구입\"을 활성화 해 주세요."
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];
    }
}

#pragma mark -
#pragma mark SKProductsRequestDelegate methods

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    self.products = [response.products sortedArrayUsingComparator:^NSComparisonResult(SKProduct *a, SKProduct *b) {
        int aNumber   = (int)[a.price intValue];
        int bNumber   = (int)[b.price intValue];
        
        return aNumber > bNumber;
    }];
    
    [self.tableView reloadData];
    
    for (NSString *invalidIdentifier in response.invalidProductIdentifiers) {
        // Handle any invalid product identifiers.
        NSLog(@"InAppPurchase Invalid product id: %@", invalidIdentifier);
    }
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error
{
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"상품 리스트를 서버로 부터 얻어오지 못했습니다."
                                                      message:nil
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    [message show];
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

//    NSString *urlString   =  [SCManager getAuthUrl:@"get_product_ids.php"];
//    NSDictionary *jsonData  = [SCManager getJsonData:urlString];
//
//    if (jsonData == nil) {
//        UIAlertView *alert =  [[UIAlertView alloc] initWithTitle:@"네트워크 에러"
//                                                         message:@"네트워크가 원활하지 않습니다. 다시 시도해 주세요."
//                                                        delegate:self
//                                               cancelButtonTitle:@"OK"
//                                               otherButtonTitles:nil];
//        [alert show];
//    } else {
        NSArray *productIds = [SCManager getProductIds];
        [self validateProductIdentifiers:productIds];
//    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self dismissViewControllerAnimated:YES completion:nil];
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
    return [self.products count];
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
        SKProduct *product  = [self.products objectAtIndex:indexPath.row];
        cell.tag    = indexPath.row;
        cell.titleLabel.text = [product localizedTitle];

        cell.buyButton.tag=indexPath.row;
        [cell.buyButton addTarget:self
                           action:@selector(pushBuyButton:)
                 forControlEvents:UIControlEventTouchDown];
        [cell.buyButton setTitle:[product localizedPrice] forState:UIControlStateNormal];
        cell.descriptionLabel.text  = [product localizedDescription];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

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
