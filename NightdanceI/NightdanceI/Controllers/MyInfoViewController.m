//
//  MyInfoViewController.m
//  NightdanceI
//
//  Created by cable8mm on 2014. 1. 20..
//  Copyright (c) 2014년 Lee Samgu. All rights reserved.
//

#import "MyInfoViewController.h"
#import "SCManager.h"
#import "UserManager.h"
#import "GlobalFunctions.h"
#import "SAManager.h"

typedef NS_ENUM(NSInteger, ButtonStatus) {
    ButtonStatusRefresh = 0,
    ButtonStatusLogOut   = 1,
};

@interface MyInfoViewController ()
@property(nonatomic, retain) IBOutlet UIBarButtonItem *upperRightButton;    // 회원가입 & 로그아웃
@property(nonatomic, retain) IBOutlet UITextField *textUsername;
@property(nonatomic, retain) IBOutlet UITextField *textPassword;
@property(nonatomic, retain) IBOutlet UIButton *logoutButton;

@property(nonatomic, retain) UITapGestureRecognizer *tap;
@property(nonatomic) BOOL isNetworkAvailable;
- (void)logout;
-(IBAction)closeKeyboard:(id)sender;
@end

@implementation MyInfoViewController

@synthesize textUsername, textPassword;

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    if (theTextField == self.textPassword) {
        [theTextField resignFirstResponder];
    } else if (theTextField == self.textUsername) {
        [self.textPassword becomeFirstResponder];
    }
    return YES;
}

-(IBAction)closeKeyboard:(id)sender {
    NSLog(@"키보드 닫기");
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

- (void)logout { // 네트워크 연결되지 않았다면 새로고침
    NSString *urlString = [SCManager getAuthUrl:@"logout_as_nightdance.php"];
    NSDictionary *jsonData  = [SCManager getJsonData:urlString];
    
    if (jsonData == nil) {
        UIAlertView *alert =  [[UIAlertView alloc] initWithTitle:@"네트워크 에러"
                                                         message:@"네트워크가 원활하지 않습니다. 다시 시도해 주세요."
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
        [alert show];
        return;
    } else {
        if ([jsonData[@"isLogout"] boolValue] == NO) {
            [[[UIAlertView alloc]initWithTitle:nil message:@"로그아웃 되지 않았습니다."
                                      delegate:nil
                             cancelButtonTitle:nil
                             otherButtonTitles:@"확인", nil] show];
            return;
        } else {
            [UserManager logout];
        }
    }
}

- (void) changedLoginStat:(BOOL)stat {
    if (stat) {
        self.upperRightButton.enabled = false;
        self.upperRightButton.title  = @"";
        
        [self.view removeGestureRecognizer:self.tap];
    } else {
        self.upperRightButton.enabled = true;
        self.upperRightButton.title  = @"회원 가입";
        
        [self.view removeGestureRecognizer:self.tap];
    }
    
    [self.tableView reloadData];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    
    /*
     Reduce the size of the text view so that it's not obscured by the keyboard.
     Animate the resize so that it's in sync with the appearance of the keyboard.
     */
    
    NSDictionary *userInfo = [notification userInfo];
    
    // Get the origin of the keyboard when it's displayed.
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    // Get the top of the keyboard as the y coordinate of its origin in self's view's
    // coordinate system. The bottom of the text view's frame should align with the top
    // of the keyboard's final position.
    //
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    CGFloat keyboardTop = keyboardRect.origin.y;
    CGRect newTextViewFrame = self.view.bounds;
    newTextViewFrame.size.height = keyboardTop - self.view.bounds.origin.y;
    
    // Get the duration of the animation.
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    // Animate the resize of the text view's frame in sync with the keyboard's appearance.
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    
//    self.textView.frame = newTextViewFrame;
    
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
    NSDictionary *userInfo = [notification userInfo];
    
    /*
     Restore the size of the text view (fill self's view).
     Animate the resize so that it's in sync with the disappearance of the keyboard.
     */
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    
//    self.textView.frame = self.view.bounds;
    
    [UIView commitAnimations];
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userUpdate:) name:@"NOTI_USER_UPDATE" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notiLogout:) name:@"NOTI_USER_LOGINOUT" object:nil];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.isNetworkAvailable = YES;
    
    NSString *urlString = [SCManager getAuthUrl:@"get_userinfo.php"];
    NSDictionary *jsonData  = [SCManager getJsonData:urlString];
    
    if (jsonData == nil) {
        self.isNetworkAvailable = NO;

        UIAlertView *alert =  [[UIAlertView alloc] initWithTitle:@"네트워크 에러"
                                                         message:@"네트워크가 원활하지 않습니다. 다시 시도해 주세요."
                                                        delegate:self
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
        [alert show];
    } else {
        NSDictionary *userinfo  = jsonData[@"user"];
        
        [UserManager setNcash:[userinfo objectForKey:@"user_mobile_ncash"]];
        [UserManager setNickname:[userinfo objectForKey:@"nickname"]];
    }
    
    self.tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(closeKeyboard:)];

    [self changedLoginStat:[UserManager isLogin]];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    if (![UserManager isLogin]) {
//        [self.textUsername becomeFirstResponder];
//    }
    
    [self.tableView reloadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];

}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if (section == 1) {
        if ([UserManager isLogin] == YES) {
            return @"로그아웃 하면 자동으로 활성화 됩니다.";
        } else {
            return @"iCloud가 활성화 되면, 즐겨찾기와 자유이용권 등의 정보가 자동으로 공유됩니다. 아이폰 설정에서 제어하실 수 있습니다.";
        }
    }
    return nil;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    // Footer should just be on the last section in the grouped table.
//    if ([UserManager isLogin]) {
//        return self.loginView;
//    }
//    else {
//        return nil;
//    }
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Accessors
- (void) setIsNetworkAvailable:(BOOL)isNetworkAvailable {
    _isNetworkAvailable = isNetworkAvailable;
    
    if (isNetworkAvailable) {
        [self.logoutButton setTitle:@"로그아웃" forState:UIControlStateNormal];
        [self.logoutButton setTitle:@"로그아웃" forState:UIControlStateHighlighted];
        self.logoutButton.tag   = ButtonStatusLogOut;
    } else {
        [self.logoutButton setTitle:@"새로 고침" forState:UIControlStateNormal];
        [self.logoutButton setTitle:@"새로 고침" forState:UIControlStateHighlighted];
        self.logoutButton.tag   = ButtonStatusRefresh;
    }
}

#pragma mark - Notification Observers

//NSDictionary *aUserInfo = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithBool:NO], @"IS_LOGIN", nil];
//[[NSNotificationCenter defaultCenter] postNotificationName:@"NOTI_USER_LOGINOUT"
//                                                    object:nil
//                                                  userInfo:aUserInfo];

- (void) notiLogout:(NSNotification *) notification {
    NSNumber *isLogin  = [[notification userInfo] objectForKey:@"IS_LOGIN"];
    
    [self changedLoginStat:[isLogin boolValue]];
}

- (void) userUpdate:(NSNotification *) notification {
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0) {
        if ([UserManager isLogin]) {    // 로그인 시 닉네임 나옴
            return 2;
        } else {
            return 1;
        }
        
    } else if(section == 1) {
        return 2;
    }
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == 0)
    {
        return @"계정 관리";
    } else if(section == 1) {
        return @"앱 정보";
    }
    else
    {
        return @"";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Configure the cell...
    if (indexPath.section == 0 && indexPath.row == 0) {
        static NSString *CellIdentifier = @"NcashCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        cell.textLabel.text         = @"상태";
        cell.detailTextLabel.text = ([UserManager isLogin])? @"로그인 됨" : @"로그인 되지 않음";
        NSLog(@"UserManager getNcash = %@", cell.detailTextLabel.text);
        if (self.isNetworkAvailable == NO) {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType  = UITableViewCellAccessoryNone;
        } else {
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            
            cell.accessoryType  = ([UserManager isLogin])? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryDisclosureIndicator;
        }
        
        return cell;
    } else if (indexPath.section == 0 && indexPath.row == 1) {
        static NSString *CellIdentifier = @"NicknameCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        cell.textLabel.text         = @"닉네임";
        cell.detailTextLabel.text = ([UserManager isLogin])? [UserManager getNickname] : @"로그인 되지 않음";
        if (self.isNetworkAvailable == NO) {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType  = UITableViewCellAccessoryNone;
        } else {
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
        }
        return cell;
    } else if (indexPath.section == 1 && indexPath.row == 0) {
        static NSString *CellIdentifier = @"InfoCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        cell.textLabel.text         = @"앱 고유번호";
        cell.detailTextLabel.text   = [SAManager getAppKey];

        cell.accessoryType  = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
    } else if (indexPath.section == 1 && indexPath.row == 1) {
        static NSString *CellIdentifier = @"InfoCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        cell.textLabel.text         = @"iCloud";
        if([NSUbiquitousKeyValueStore defaultStore]) {
            if ([UserManager isLogin] == YES) {
                cell.detailTextLabel.text   = @"비활성화";
            } else {
                cell.detailTextLabel.text   = @"활성화";
            }
        } else {
            cell.detailTextLabel.text   = @"비활성화";
        }
        
        cell.accessoryType  = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
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

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0 && [UserManager isLogin]) {    // 로그아웃
        UIAlertView *alert =  [[UIAlertView alloc] initWithTitle:@"로그아웃 하시겠습니까?"
                                                         message:@"모든 정보는 초기화 됩니다."
                                                        delegate:self
                                               cancelButtonTitle:@"취소"
                                               otherButtonTitles:@"로그아웃", nil];
        alert.tag   = 1;
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (alertView.tag) {
        case 1:
        {
            if (buttonIndex == 1) {
                [self logout];
            }
        }
            break;
            
        default:
            break;
    }
    
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
 }

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:@"showLogin"]) {
        return [UserManager isLogin] == NO;
    }

    return self.isNetworkAvailable;
}

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showNickname"]) {
//        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
//        DownloadClip *downloadClip  = [[DownloadManager sharedObject].downloadClips objectAtIndex:indexPath.row];
//        [[segue destinationViewController] setClipId:downloadClip.clipId];
    }
}

@end
