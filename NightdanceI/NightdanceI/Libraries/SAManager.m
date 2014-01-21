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

+(void)syncForce {
    NSString *token     = [SCManager getAccessToken];
    [SAManager setAccessToken:token];
}

+(NSString *)getAccessToken {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults stringForKey:@"Token"];
    
    if (token != nil) {
        return token;
    }
    
    token   = [SCManager getAccessToken];
    [SAManager setAccessToken:token];
    
    return token;
}

+(void)setAccessToken:(NSString*)token {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:token forKey:@"Token"];
}

+(NSString*)getAppKey {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *appKey = [defaults stringForKey:@"AppKey"];
    
    if (appKey == nil) {
        appKey  = [SAManager genAppKey];
        [defaults setObject:@"AppKey" forKey:appKey];
        [defaults synchronize];
    }
    
    return appKey;
}

+(void)setAppKey {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *appKey = [defaults stringForKey:@"AppKey"];
    
    if (appKey == nil) {
        appKey  = [SAManager genAppKey];
        [defaults setObject:@"AppKey" forKey:appKey];
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
