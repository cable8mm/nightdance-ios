//
//  AppDelegate.h
//  NightdanceI
//
//  Created by cable8mm on 2013. 12. 10..
//  Copyright (c) 2013년 Lee Samgu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (copy) void (^backgroundSessionCompletionHandler)();

@end
