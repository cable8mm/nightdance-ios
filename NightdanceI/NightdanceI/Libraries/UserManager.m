//
//  UserManager.m
//  NightdanceI
//
//  Created by cable8mm on 2014. 1. 20..
//  Copyright (c) 2014년 Lee Samgu. All rights reserved.
//

#import "UserManager.h"

@implementation UserManager

+(void)login:(NSDictionary*)user {
    NSInteger userId    = (NSInteger)[[user objectForKey:@"user_id"] intValue];
    NSInteger userNcash = (NSInteger)[[user objectForKey:@"user_ncash"] intValue];
    NSString *nickname = [user objectForKey:@"nickname"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:userId forKey:@"USER_DEFAULTS_USER_ID"];
    [defaults setInteger:userNcash forKey:@"USER_DEFAULTS_USER_NCASH"];
    [defaults setObject:nickname forKey:@"USER_DEFAULTS_USER_NICKNAME"];
    [defaults setBool:YES forKey:@"USER_DEFAULTS_USER_IS_LOGIN"];
    
    [defaults synchronize];
}

+(BOOL)isLogin {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults boolForKey:@"USER_DEFAULTS_USER_IS_LOGIN"];
}

+(void)logout {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults removeObjectForKey:@"USER_DEFAULTS_USER_ID"];
    [defaults removeObjectForKey:@"USER_DEFAULTS_USER_NCASH"];
    [defaults removeObjectForKey:@"USER_DEFAULTS_USER_NICKNAME"];
    [defaults setBool:NO forKey:@"USER_DEFAULTS_USER_IS_LOGIN"];
}

+(NSString *)getNickname {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults stringForKey:@"USER_DEFAULTS_USER_NICKNAME"];
}

+(int)getNcash {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return (int)[defaults integerForKey:@"USER_DEFAULTS_USER_NCASH"];
}

@end
