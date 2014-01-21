//
//  SettingsViewController.m
//  NightdanceI
//
//  Created by cable8mm on 2014. 1. 14..
//  Copyright (c) 2014년 Lee Samgu. All rights reserved.
//

#import "SettingsViewController.h"
#import "WebViewController.h"
#import "AccountViewController.h"

NSString *templateReviewURL = @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=393499958";
NSString *templateReviewURLiOS7 = @"itms-apps://itunes.apple.com/app/idAPP_ID";


@interface SettingsViewController ()
- (IBAction)writeReview:(id)sender;
@end

@implementation SettingsViewController

- (IBAction)writeReview:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"리뷰를 써 주셔서 저희에게 힘을 주세요." delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"작성하러 가기", nil];
    [alert show];
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)presentAppStoreForID:(NSNumber *)appStoreID withDelegate:(id<SKStoreProductViewControllerDelegate>)delegate withURL:(NSURL *)appStoreURL
{
    if(NSClassFromString(@"SKStoreProductViewController")) { // Checks for iOS 6 feature.
        
        SKStoreProductViewController *storeController = [[SKStoreProductViewController alloc] init];
        storeController.delegate = delegate; // productViewControllerDidFinish
        
        // Example app_store_id (e.g. for Words With Friends)
        // [NSNumber numberWithInt:322852954];
        
        NSDictionary *productParameters = @{ SKStoreProductParameterITunesItemIdentifier : appStoreID };
        
        [storeController loadProductWithParameters:productParameters completionBlock:^(BOOL result, NSError *error) {
            if (result) {
                [self presentViewController:storeController animated:YES completion:nil];
            } else {
                [[[UIAlertView alloc] initWithTitle:@"Uh oh!" message:@"There was a problem displaying the app" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
            }
        }];
        
        
    } else { // Before iOS 6, we can only open the URL
        [[UIApplication sharedApplication] openURL:appStoreURL];
    }
}

- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController
{
    if (viewController)
    { [viewController dismissViewControllerAnimated:YES completion:nil]; }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == 0)
    {
        return @"기본 정보";
    }
    else if(section == 1)
    {
        return @"알림 설정";
    }
    else if(section == 2)
    {
        return @"개인 정보";
    }
    else
    {
        return @"";
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if(section == 2)
    {
        return @"나이트댄스 웹사이트의 아이디로 로그인을 하면 찜리스트를 공유하고, 덧글을 작성할 수 있습니다.";
    }

    return @"";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0) {
        return 3;
    }
    
    if (section == 1) {
        return 2;
    }
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    if (indexPath.section == 0 && indexPath.row == 0) {
        cell.textLabel.text = @"현재 버전";
        cell.detailTextLabel.text    = @"1.0";
        cell.accessoryType  = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    } else if (indexPath.section == 0 && indexPath.row == 1) {
        cell.textLabel.text = @"최신 버전";
        cell.detailTextLabel.text    = @"1.0";
        cell.accessoryType  = UITableViewCellAccessoryNone;
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    } else if (indexPath.section == 0 && indexPath.row == 2) {
        cell.textLabel.text = @"도움말";
        cell.detailTextLabel.text    = @"";
    } else if (indexPath.section == 1 && indexPath.row == 0) {
        cell.textLabel.text = @"동영상 업데이트";
        cell.detailTextLabel.text    = @"";
        cell.selectionStyle  = UITableViewCellSelectionStyleNone;
        UISwitch *switchview = [[UISwitch alloc] initWithFrame:CGRectZero];
        cell.accessoryView = switchview;
    } else if (indexPath.section == 1 && indexPath.row == 1) {
        cell.textLabel.text = @"새 버전 업데이트";
        cell.detailTextLabel.text    = @"";
        cell.selectionStyle  = UITableViewCellSelectionStyleNone;
        UISwitch *switchview = [[UISwitch alloc] initWithFrame:CGRectZero];
        cell.accessoryView = switchview;
    } else {
        cell.textLabel.text = @"나이트댄스 계정";
        cell.detailTextLabel.text    = @"없음";
    }
    return cell;
}

// http://stackoverflow.com/questions/12475568/appstore-as-modal-view-in-ios6
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 2)
    {
        NSLog(@"도움말 탭");
        WebViewController *helpViewController   = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
        helpViewController.title    = @"도움말";
        helpViewController.requestURL   =@"http://www.naver.com";
        
        [self.navigationController pushViewController:helpViewController animated:YES];
    }
    
    if (indexPath.section == 2 && indexPath.row == 0) {
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:templateReviewURL]];
        AccountViewController *accountViewController    = [[AccountViewController alloc] initWithNibName:@"AccountViewController" bundle:nil];
        accountViewController.title = @"나이트댄스 계정";
        [self.navigationController pushViewController:accountViewController animated:YES];
    }
    
    if (indexPath.section == 0 && indexPath.row == 1) {
        NSURL *url  = [NSURL URLWithString:@"https://itunes.apple.com/kr/app/neibeo-naver/id393499958?l=en&mt=8"];
        [self presentAppStoreForID:[NSNumber numberWithInt:393499958] withDelegate:self withURL:(NSURL *)url];
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
//    if ([[segue identifier] isEqualToString:@"showHelp"]) {
//        WebViewController *helpViewController = [segue destinationViewController];
////        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
//        //        NSDate *object = [[NSDate alloc] init];
////        NSInteger unNum = [indexPath indexAtPosition: 1 ];
////        NSDictionary *clip   = [self->clips objectAtIndex:unNum];
////        NSString *strClipId = [clip objectForKey:@"clip_id"];
////        NSNumber *clipId    = [NSNumber numberWithInteger:[strClipId intValue]];
////        [[segue destinationViewController] setClipId:clipId];
//    }

}

@end
