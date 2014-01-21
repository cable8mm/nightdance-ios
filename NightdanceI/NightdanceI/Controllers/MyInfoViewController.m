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

@interface MyInfoViewController ()
@property(nonatomic, retain) IBOutlet UIBarButtonItem *upperRightButton;    // 회원가입 & 로그아웃
@property(nonatomic, retain) IBOutlet UIBarButtonItem *upperLeftButton;    // 엔캐시 충전
@property(nonatomic, retain) IBOutlet UITextField *textUsername;
@property(nonatomic, retain) IBOutlet UITextField *textPassword;
@property(nonatomic, retain) IBOutlet UIView *loginView;
@property(nonatomic, retain) IBOutlet UIView *logoutView;
@property(nonatomic, retain) UITapGestureRecognizer *tap;
- (IBAction)login:(id)sender;
- (IBAction)logout:(id)sender;
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

- (IBAction)logout:(id)sender {
    [UserManager logout];
    [self changedLoginStat:NO];
}

- (IBAction)login:(id)sender {
    if ([self.textUsername.text isEqualToString:@""]) {
        [[[UIAlertView alloc]initWithTitle:nil message:@"아이디를 넣어주세요."
                                 delegate:nil
                        cancelButtonTitle:nil
                        otherButtonTitles:@"확인", nil] show];
        return;
    }
    
    if ([self.textPassword.text isEqualToString:@""]) {
        [[[UIAlertView alloc]initWithTitle:nil message:@"비밀번호를 넣어주세요."
                                  delegate:nil
                         cancelButtonTitle:nil
                         otherButtonTitles:@"확인", nil] show];
        return;
    }
    
    NSDictionary *userInfo  = [SCManager getUserInfo:self.textUsername.text password:self.textPassword.text];
    
    if (userInfo == nil) {
        [[[UIAlertView alloc]initWithTitle:nil message:@"아이디와 패스워드가 올바르지 않습니다."
                                  delegate:nil
                         cancelButtonTitle:nil
                         otherButtonTitles:@"확인", nil] show];
        return;
    }
    
    [UserManager login:userInfo];
    
    self.textPassword.text = @"";
    
    [self changedLoginStat:YES];
}

- (void) changedLoginStat:(BOOL)stat {
    if (stat) {
        self.loginView.hidden   = YES;
        self.tableView.tableHeaderView  = nil;
        self.logoutView.hidden  = NO;
        self.tableView.tableFooterView  = self.logoutView;
        
        self.upperRightButton.enabled = false;
        self.upperRightButton.title  = @"";
        self.upperLeftButton.enabled = true;
        self.upperLeftButton.title  = @"엔캐시 충전";
        
        [self.view removeGestureRecognizer:self.tap];
    } else {
        self.loginView.hidden   = NO;
        self.tableView.tableHeaderView  = self.loginView;
        self.logoutView.hidden  = YES;
        self.tableView.tableFooterView  = nil;
        
        self.upperRightButton.enabled = true;
        self.upperRightButton.title  = @"회원 가입";
        self.upperLeftButton.enabled = false;
        self.upperLeftButton.title  = @"";

        [self.view addGestureRecognizer:self.tap];
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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    self.tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(closeKeyboard:)];

    [self changedLoginStat:[UserManager isLogin]];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (![UserManager isLogin]) {
        [self.textUsername becomeFirstResponder];
    }
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if (![UserManager isLogin]) {
        return 0;
    }
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (![UserManager isLogin]) {
        return 0;
    }

    if (section == 0) {
        return 1;
    }
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == 0)
    {
        return @"기본 정보";
    }
    else if(section == 1)
    {
        return @"엔캐시 정보";
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    if (indexPath.section == 0 && indexPath.row == 0) {
        cell.textLabel.text         = @"닉네임";
        cell.detailTextLabel.text    = [UserManager getNickname];
    } else if (indexPath.section == 1 && indexPath.row == 0) {
        cell.textLabel.text         = @"소유한 엔캐시";
        cell.detailTextLabel.text = GetCommaNumber([UserManager getNcash]);
    }
    cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
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
