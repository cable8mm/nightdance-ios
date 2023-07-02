//
//  SDCloudUserDefaults.m
//
//  Created by Stephen Darlington on 01/09/2011.
//  Copyright (c) 2011 Wandle Software Limited. All rights reserved.
//

#import "SDCloudUserDefaults.h"
#import "UserManager.h"

@implementation SDCloudUserDefaults

static id notificationObserver;

+(NSString*)stringForKey:(NSString*)aKey {
    return [SDCloudUserDefaults objectForKey:aKey];
}

+(BOOL)boolForKey:(NSString*)aKey {
    return [[SDCloudUserDefaults objectForKey:aKey] boolValue];
}

+(id)objectForKey:(NSString*)aKey {
    if ([UserManager isLogin] == YES) {
        return [[NSUserDefaults standardUserDefaults] objectForKey:aKey];
    }
    
    NSUbiquitousKeyValueStore* cloud = [NSUbiquitousKeyValueStore defaultStore];
    id retv = [cloud objectForKey:aKey];
    if (!retv) {
        retv = [[NSUserDefaults standardUserDefaults] objectForKey:aKey];
        [cloud setObject:retv forKey:aKey];
    }
    return retv;
}

+(NSInteger)integerForKey:(NSString*)aKey {
    return [[SDCloudUserDefaults objectForKey:aKey] integerValue];
}

+(void)setString:(NSString*)aString forKey:(NSString*)aKey {
    [SDCloudUserDefaults setObject:aString forKey:aKey];
}

+(void)setBool:(BOOL)aBool forKey:(NSString*)aKey {
    [SDCloudUserDefaults setObject:[NSNumber numberWithBool:aBool] forKey:aKey];
}

+(void)setObject:(id)anObject forKey:(NSString*)aKey {
    if ([UserManager isLogin] == NO) {
        [[NSUbiquitousKeyValueStore defaultStore] setObject:anObject forKey:aKey];
    }
    [[NSUserDefaults standardUserDefaults] setObject:anObject forKey:aKey];
}

+(void)setInteger:(NSInteger)anInteger forKey:(NSString*)aKey {
    [SDCloudUserDefaults setObject:[NSNumber numberWithInteger:anInteger]
                            forKey:aKey];
}

+(void)removeObjectForKey:(NSString*)aKey {
    if ([UserManager isLogin] == NO) {
        [[NSUbiquitousKeyValueStore defaultStore] removeObjectForKey:aKey];
    }
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:aKey];
}

+(void)synchronize {
    if ([UserManager isLogin] == NO) {
        [[NSUbiquitousKeyValueStore defaultStore] synchronize];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void)registerForNotifications {
    @synchronized(notificationObserver) {
        if (notificationObserver) {
            return;
        }
        
        notificationObserver = [[NSNotificationCenter defaultCenter] addObserverForName:@"NSUbiquitousKeyValueStoreDidChangeExternallyNotification"
                                                                                 object:[NSUbiquitousKeyValueStore defaultStore]
                                                                                  queue:nil
                                                                             usingBlock:^(NSNotification* notification) {
                                                                                 if ([UserManager isLogin] == YES) {
                                                                                     return;
                                                                                 }
                                                                                 NSDictionary* userInfo = [notification userInfo];
                                                                                 NSNumber* reasonForChange = [userInfo objectForKey:NSUbiquitousKeyValueStoreChangeReasonKey];
                                                                                 
                                                                                 // If a reason could not be determined, do not update anything.
                                                                                 if (!reasonForChange)
                                                                                     return;
                                                                                 
                                                                                 // Update only for changes from the server.
                                                                                 NSInteger reason = [reasonForChange integerValue];
                                                                                 if ((reason == NSUbiquitousKeyValueStoreServerChange) ||
                                                                                     (reason == NSUbiquitousKeyValueStoreInitialSyncChange)) {
                                                                                     NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
                                                                                     NSUbiquitousKeyValueStore* cloud = [NSUbiquitousKeyValueStore defaultStore];
                                                                                     NSArray* changedKeys = [userInfo objectForKey:NSUbiquitousKeyValueStoreChangedKeysKey];
                                                                                     for (NSString* key in changedKeys) {
                                                                                         [defaults setObject:[cloud objectForKey:key] forKey:key];
                                                                                     }
                                                                                     [[NSNotificationCenter defaultCenter] postNotificationName:@"ICLOUD_UPDATED" object:nil];
                                                                                 }
                                                                             }];
    }
    
}

+(void)removeNotifications {
    @synchronized(notificationObserver) {
        [[NSNotificationCenter defaultCenter] removeObserver:notificationObserver];
        notificationObserver = nil;
    }
}

@end