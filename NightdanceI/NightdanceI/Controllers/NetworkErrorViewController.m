//
//  NetworkErrorViewController.m
//  NightdanceI
//
//  Created by cable8mm on 2014. 2. 21..
//  Copyright (c) 2014년 Lee Samgu. All rights reserved.
//

#import "NetworkErrorViewController.h"
#import "AppDelegate.h"
#import "SAManager.h"
#import "SCManager.h"
#import "UserManager.h"

@interface NetworkErrorViewController ()
- (IBAction)refreshNetwork:(id)sender;
@end

@implementation NetworkErrorViewController

- (IBAction)refreshNetwork:(id)sender {
    NSLog(@"NetworkErrorViewController refreshNetwork");
    AppDelegate *appDelegate    = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    BOOL isTokenSync     = [SAManager syncForce];                 // 서버의 토큰 값을 강제로 싱크한다.
    
    if (isTokenSync) {
        NSString *urlString = [SCManager getAuthUrl:@"get_userinfo.php"];
        NSDictionary *jsonData  = [SCManager getJsonData:urlString];
        
        if (jsonData != nil) {
            NSDictionary *userinfo  = jsonData[@"user"];
            
            [UserManager setNcash:[userinfo objectForKey:@"user_mobile_ncash"]];
            [UserManager setNickname:[userinfo objectForKey:@"nickname"]];
        }
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UITabBarController *mainViewController = [storyboard instantiateInitialViewController];
        appDelegate.window.rootViewController = mainViewController;
    } else {
        UIAlertView *alert =  [[UIAlertView alloc] initWithTitle:@"네트워크 에러"
                                                         message:@"네트워크가 원활하지 않습니다. 다시 시도해 주세요."
                                                        delegate:self
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
        [alert show];
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

//    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
//                                                                                      action:@selector(handleSingleTap:)];
//    [self.view addGestureRecognizer:singleTapGestureRecognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
