//
//  AppDelegate.m
//  NightdanceI
//
//  Created by cable8mm on 2013. 12. 10..
//  Copyright (c) 2013년 Lee Samgu. All rights reserved.
//

#import "AppDelegate.h"
#import "SAManager.h"
#import "SCManager.h"
#import <StoreKit/StoreKit.h>
#import "DownloadManager.h"
#import "UserManager.h"
#import "NetworkErrorViewController.h"
#import "SDCloudUserDefaults.h"

@implementation AppDelegate

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
	NSLog(@"My token is: %@", deviceToken);
    const unsigned *tokenBytes = [deviceToken bytes];
    NSString *hexToken = [NSString stringWithFormat:@"%08x%08x%08x%08x%08x%08x%08x%08x",
                          ntohl(tokenBytes[0]), ntohl(tokenBytes[1]), ntohl(tokenBytes[2]),
                          ntohl(tokenBytes[3]), ntohl(tokenBytes[4]), ntohl(tokenBytes[5]),
                          ntohl(tokenBytes[6]), ntohl(tokenBytes[7])];
    NSString *params    = [NSString stringWithFormat:@"device_token=%@", hexToken];
    NSString *urlString = [SCManager getAuthUrl:@"submit_device_token.php" param:params];
    [SCManager getJsonData:urlString];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
	NSLog(@"application:didFailToRegisterForRemoteNotificationsWithError: %@", error);
	if ([error code] != 3010) // 3010 is for the iPhone Simulator
	{
        // show some alert or otherwise handle the failure to register.
        NSString *params    = @"device_token=";
        NSString *urlString = [SCManager getAuthUrl:@"submit_device_token.php" param:params];
        [SCManager getJsonData:urlString];
	}
}

- (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier
  completionHandler:(void (^)())completionHandler {
    self.backgroundSessionCompletionHandler = completionHandler;
    //add notification
    NSLog(@"handleEventsForBackgroundURLSession identifier = %@", identifier);
    [self presentNotification];
}

-(void)presentNotification{
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    localNotification.alertBody = @"다운로드 완료!";
    localNotification.alertAction = @"다운로드 된 강좌 보기";
    //On sound
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    //increase the badge number of application plus 1
    localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
    [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeAlert];
    
    [SDCloudUserDefaults registerForNotifications];
    
    NSURL *receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
    NSData *receiptData = [NSData dataWithContentsOfURL:receiptURL];
    NSLog(@"receiptData = %@", [receiptData description]);
    
    [DownloadManager sharedObject];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    BOOL isTokenSync     = [SAManager syncForce];                 // 서버의 토큰 값을 강제로 싱크한다.
    
    if (isTokenSync) {
        NSString *urlString = [SCManager getAuthUrl:@"get_userinfo.php"];
        NSDictionary *jsonData  = [SCManager getJsonData:urlString];
        
        if (jsonData != nil) {
            NSDictionary *userinfo  = jsonData[@"user"];
            
            [UserManager setNcash:[userinfo objectForKey:@"user_mobile_ncash"]];
            [UserManager setNickname:[userinfo objectForKey:@"nickname"]];
        }
    } else {
        NetworkErrorViewController *networkErrorViewController = [[NetworkErrorViewController alloc] initWithNibName:@"NetworkErrorViewController" bundle:nil];
//        [self.window.rootViewController presentViewController:networkErrorViewController animated:YES completion:nil];
        self.window.rootViewController  = networkErrorViewController;
//        [self.window.rootViewController presentViewController:networkErrorViewController animated:YES completion:nil];
    }

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UITabBarController *mainViewController = [storyboard instantiateInitialViewController];
    self.window.rootViewController = mainViewController;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.

}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [UIApplication sharedApplication].applicationIconBadgeNumber  = 0;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
