//
//  NicknameViewController.m
//  NightdanceI
//
//  Created by cable8mm on 2014. 1. 31..
//  Copyright (c) 2014년 Lee Samgu. All rights reserved.
//

#import "NicknameViewController.h"
#import "UserManager.h"
#import "SCManager.h"

@interface NicknameViewController ()
@property(nonatomic, retain) IBOutlet UITextField *tfNickname;
-(IBAction)changeNickname:(id)sender;
@end

@implementation NicknameViewController

-(IBAction)changeNickname:(id)sender {
    NSString *inputString   = [self.tfNickname.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([inputString isEqualToString:@""]) {
        [[[UIAlertView alloc] initWithTitle:@"공백은 입력하실 수 없습니다."
                                   message:nil
                                  delegate:nil
                         cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
        return;
    }
    
    if ([UserManager isLogin] == NO) {
        [UserManager setNickname:inputString];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }

    
    NSString *nicknameString = [inputString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *params    = [NSString stringWithFormat:@"nickname=%@", nicknameString];
    NSString *urlString = [SCManager getAuthUrl:@"change_nickname.php" param:params];
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
        NSNumber *isChanged = jsonData[@"isChanged"];
        
        if ([isChanged boolValue] == NO) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"서버 오류"
                                                           message:@"닉네임이 변경되지 않았습니다."
                                                          delegate:nil
                                                 cancelButtonTitle:nil
                                                 otherButtonTitles:@"취소", nil];
            [alert show];
        } else {
            [UserManager setNickname:inputString];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

#pragma mark - iOS Delegate
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
    
    //            cell.detailTextLabel.text    = [UserManager getNickname];

    self.tfNickname.text = [UserManager getNickname];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tfNickname becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
