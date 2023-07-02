//
//  SAManager.m
//  NightdanceI
//
//  Created by cable8mm on 2014. 1. 19..
//  Copyright (c) 2014년 Lee Samgu. All rights reserved.
//

#import "SAManager.h"
#import "SCManager.h"

@interface SAManager ()
@property (nonatomic, retain) NSString *appKey;
@end

@implementation SAManager

+(NSString*)genAppKey {
    return [[NSUUID UUID] UUIDString];
}

+(BOOL)syncForce {
    NSString *token     = [SAManager getAccessToken];
    if (token == nil) {
        return NO;
    }
    NSString *url    = [SCManager getAuthUrl:@"is_valid_access_token.php"];
    NSDictionary *response = [SCManager getJsonData:url];
    
    if ([response[@"is_valid"] boolValue]) {
        [SAManager setAccessToken:token];
    } else {
        NSString *accessToken   = [SCManager getAccessToken];
        [SAManager setAccessToken:accessToken];
    }
    
    return YES;
}

+(NSString *)getAccessToken {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults stringForKey:@"Token"];
    NSLog(@"SavedToken = %@", token);
    if (token != nil) {
        return token;
    }
    
    token   = [SCManager getAccessToken];
    
    if (token == nil) {
        return nil;
    }
    
    [SAManager setAccessToken:token];
    return token;
}

+(void)setAccessToken:(NSString*)token {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:token forKey:@"Token"];
    [defaults synchronize];
    NSLog(@"Set Token = %@", token);
}

+(NSString*)getAppKey {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *appKey = [defaults stringForKey:@"AppKey"];
    
    if (appKey == nil) {
        appKey  = [SAManager genAppKey];
        [defaults setObject:appKey forKey:@"AppKey"];
        [defaults synchronize];
    }
    
    return appKey;
}

+(void)setAppKey {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *appKey = [defaults stringForKey:@"AppKey"];
    
    if (appKey == nil) {
        appKey  = [SAManager genAppKey];
        [defaults setObject:appKey forKey:@"AppKey"];
        [defaults synchronize];
    }
}

-(id)initWithUUID:(NSString*)key {
    self = [super init];
    if (self) {
        // Initialization code
        self.appKey   = key;
    }
    return self;
}

@end
