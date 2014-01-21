//
//  UserManager.h
//  NightdanceI
//
//  Created by cable8mm on 2014. 1. 20..
//  Copyright (c) 2014년 Lee Samgu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserManager : NSObject
+(void)login:(NSDictionary*)user;
+(BOOL)isLogin;
+(NSString *)getNickname;
+(int)getNcash;
+(void)logout;
@end
