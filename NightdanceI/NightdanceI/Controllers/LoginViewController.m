//
//  LoginViewController.m
//  NightdanceI
//
//  Created by cable8mm on 2014. 3. 15..
//  Copyright (c) 2014년 Lee Samgu. All rights reserved.
//

#import "LoginViewController.h"
#import "SCManager.h"
#import "UserManager.h"

@interface LoginViewController ()
@property(nonatomic, retain) IBOutlet UITextField *textUsername;
@property(nonatomic, retain) IBOutlet UITextField *textPassword;

- (IBAction)login:(id)sender;
@end

@implementation LoginViewController

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
    
    NSTimeInterval expireDateTimeStamp  = [UserManager getExpiryDateTimeStamp];
    NSInteger time = round(expireDateTimeStamp);
    
    NSString *params    = [NSString stringWithFormat:@"username=%@&password=%@&ticket_expired=%d", self.textUsername.text, self.textPassword.text, (int)time];
    NSString *urlString = [SCManager getAuthUrl:@"login_as_nightdance.php" param:params];
    NSDictionary *jsonData  = [SCManager getJsonData:urlString];
    
    if (jsonData == nil) {
        UIAlertView *alert =  [[UIAlertView alloc] initWithTitle:@"네트워크 에러"
                                                         message:@"네트워크가 원활하지 않습니다. 다시 시도해 주세요."
                                                        delegate:nil
                                               cancelButtonTitle:@"다시 시도"
                                               otherButtonTitles:nil];
        [alert show];
        return;
    } else {
        if ([jsonData[@"is_login"] boolValue]) {
            [UserManager login:jsonData[@"user"]];
            [self.navigationController popViewControllerAnimated: YES];
        } else {
            [[[UIAlertView alloc]initWithTitle:nil message:@"아이디와 패스워드가 올바르지 않습니다."
                                      delegate:nil
                             cancelButtonTitle:nil
                             otherButtonTitles:@"확인", nil] show];
            return;
        }
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
