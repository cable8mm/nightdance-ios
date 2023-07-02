//
//  RegistrationViewController.m
//  NightdanceI
//
//  Created by cable8mm on 2014. 1. 20..
//  Copyright (c) 2014년 Lee Samgu. All rights reserved.
//

#import "RegistrationViewController.h"
#import "SCManager.h"
#import "NSString+StringEmpty.h"

@interface RegistrationViewController ()
@property (nonatomic, retain) IBOutlet UITextField *textUsername;
@property (nonatomic, retain) IBOutlet UITextField *textPassword;
@property (nonatomic, retain) IBOutlet UITextField *textNickname;
-(IBAction)close:(id)sender;
-(IBAction)registration:(id)sender;
@end

@implementation RegistrationViewController

-(IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)registration:(id)sender {
    if ([self.textUsername.text isStringEmpty] || [self.textPassword.text isStringEmpty] || [self.textNickname.text isStringEmpty]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"오류"
                                                       message:@"모든 필드를 입력해 주세요."
                                                      delegate:nil
                                             cancelButtonTitle:nil
                                             otherButtonTitles:@"취소", nil];
        [alert show];

        return;
    }
    
    NSString *nicknameString = [self.textNickname.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *params    = [NSString stringWithFormat:@"username=%@&password=%@&nickname=%@", self.textUsername.text, self.textPassword.text, nicknameString];
    NSString *urlString = [SCManager getAuthUrl:@"submit_account.php" param:params];
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
        if ([jsonData[@"isRegistrated"] boolValue]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"가입 완료"
                                                           message:@"가입하신 계정으로 로그인 해 주세요."
                                                          delegate:self
                                                 cancelButtonTitle:nil
                                                 otherButtonTitles:@"로그인", nil];
            alert.tag   = 1;
            [alert show];
        } else {
            NSString *errorMessage  = jsonData[@"message"];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"오류"
                                                           message:errorMessage
                                                          delegate:nil
                                                 cancelButtonTitle:nil
                                                 otherButtonTitles:@"완료", nil];
            [alert show];
        }
    }
}

#pragma mark - AlertView Callbacks
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 1) {
        if (buttonIndex == 0) { // 로그인
            [self close:nil];
        }
    }
}


-(IBAction)closeKeyboard:(id)sender {
    NSLog(@"키보드 닫기");
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    if (theTextField == self.textPassword) {
        [theTextField resignFirstResponder];
    } else if (theTextField == self.textUsername) {
        [self.textPassword becomeFirstResponder];
    }
    return YES;
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
    
    UIScrollView * scrollView = (UIScrollView*)self.view;
    scrollView.frame = (CGRect){scrollView.frame.origin, CGSizeMake(320, 480)};
    scrollView.contentSize = CGSizeMake(320, 1000);
    scrollView.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(closeKeyboard:)];
    
    [self.view addGestureRecognizer:tap];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.textUsername becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
