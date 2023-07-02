//
//  UserManager.m
//  NightdanceI
//
//  Created by cable8mm on 2014. 1. 20..
//  Copyright (c) 2014년 Lee Samgu. All rights reserved.
//

#import "UserManager.h"
#import "SDCloudUserDefaults.h"

@implementation UserManager

+(void)login:(NSDictionary*)user {
    NSInteger userId    = (NSInteger)[[user objectForKey:@"user_id"] intValue];
    NSInteger userNcash = (NSInteger)[[user objectForKey:@"user_mobile_ncash"] intValue];
    NSString *nickname = [user objectForKey:@"nickname"];
    NSMutableArray *scrapedClips = [user objectForKey:@"scraped_clips"];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"]; //this is the sqlite's format
    NSDate *ticketExpiryDate = [formatter dateFromString:[user objectForKey:@"ticket_expired"]];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:@"USER_DEFAULTS_USER_IS_LOGIN"];

    [defaults setInteger:userId forKey:@"USER_DEFAULTS_USER_ID"];
    [defaults setInteger:userNcash forKey:@"USER_DEFAULTS_USER_NCASH"];
    [defaults setObject:nickname forKey:@"USER_DEFAULTS_USER_NICKNAME"];
    [defaults setObject:scrapedClips forKey:@"USER_DEFAULTS_SCRAPED_CLIPS"];
    [SDCloudUserDefaults setObject:ticketExpiryDate forKey:@"USER_DEFAULTS_EXPIRY_DATE"];

    [defaults synchronize];
    [SDCloudUserDefaults synchronize];
    
    [UserManager expandExpiryDate:0];
    NSDictionary *aUserInfo = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithBool:YES], @"IS_LOGIN", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTI_USER_LOGINOUT"
                                                        object:nil
                                                      userInfo:aUserInfo];
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
    
    [defaults synchronize];
    
    // 아이클라우드 정보를 초기화 한다.
    [UserManager expandExpiryDate:-1];

    NSDictionary *aUserInfo = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithBool:NO], @"IS_LOGIN", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTI_USER_LOGINOUT"
                                                        object:nil
                                                      userInfo:aUserInfo];
}

+(NSArray *)getScrapedClips {
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    return [defaults arrayForKey:@"USER_DEFAULTS_SCRAPED_CLIPS"];
    return (NSArray*)[SDCloudUserDefaults objectForKey:@"USER_DEFAULTS_SCRAPED_CLIPS"];
}

+(void)addScrapedClip:(NSNumber *)clipId {
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSMutableArray *scrapedClips = [NSMutableArray arrayWithArray:[UserManager getScrapedClips]];
//    [scrapedClips addObject:clipId];
//    [defaults setObject:scrapedClips forKey:@"USER_DEFAULTS_SCRAPED_CLIPS"];
//    [defaults synchronize];
    NSMutableArray *scrapedClips    = [NSMutableArray arrayWithArray:[UserManager getScrapedClips]];
    [scrapedClips addObject:clipId];
    
    [SDCloudUserDefaults setObject:scrapedClips forKey:@"USER_DEFAULTS_SCRAPED_CLIPS"];
    [SDCloudUserDefaults synchronize];
    [UserManager setViewedScrapingClip:YES];
}

+(void)removeScrapedClip:(NSNumber *)clipId {
    NSMutableArray *scrapedClips    = [NSMutableArray arrayWithArray:[UserManager getScrapedClips]];

    for (NSNumber *eClipId in scrapedClips) {
        if ([eClipId intValue] == [clipId intValue]) {
            [scrapedClips removeObject:eClipId];
            [SDCloudUserDefaults setObject:scrapedClips forKey:@"USER_DEFAULTS_SCRAPED_CLIPS"];
            [SDCloudUserDefaults synchronize];
//            [UserManager setViewedScrapingClip:YES];
            return;
        }
    }
}

+(BOOL)isScrapedClip:(NSNumber *)clipId {
    NSArray *scrapedClips   = [UserManager getScrapedClips];
    if (scrapedClips == nil) {
        return NO;
    }
    
    for (NSNumber *eClipId in scrapedClips) {
        if ([eClipId isEqualToNumber:clipId]) {
            return YES;
        }
    }
    return NO;
}

+(NSString *)getNickname {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return ([defaults stringForKey:@"USER_DEFAULTS_USER_NICKNAME"] == nil)? @"Best Dancer" : [defaults stringForKey:@"USER_DEFAULTS_USER_NICKNAME"];
}

+(void)setNickname:(NSString *)nickname {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:nickname forKey:@"USER_DEFAULTS_USER_NICKNAME"];

    [defaults synchronize];
}

+(int)getNcash {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return (int)[defaults integerForKey:@"USER_DEFAULTS_USER_NCASH"];
}

+(void)setNcash:(NSNumber*)ncash {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:ncash forKey:@"USER_DEFAULTS_USER_NCASH"];
    
    [defaults synchronize];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTI_USER_UPDATE"
                                                        object:nil];
}

+(void)addNcash:(NSNumber*)ncash {
    int ownNcash   = [self getNcash] + [ncash intValue];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithInt:ownNcash] forKey:@"USER_DEFAULTS_USER_NCASH"];
    
    [defaults synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTI_USER_UPDATE"
                                                        object:nil];
}

+(BOOL)isViewedPurchasingClip {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults boolForKey:@"USER_DEFAULTS_USER_VIEWED_PURCHASING_CLIP"];
}

+(void)setViewedPurchasingClip:(BOOL)b {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithBool:b] forKey:@"USER_DEFAULTS_USER_VIEWED_PURCHASING_CLIP"];
    [defaults synchronize];
}

+(BOOL)isViewedScrapingClip {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults boolForKey:@"USER_DEFAULTS_USER_VIEWED_SCRAPING_CLIP"];
}

+(void)setViewedScrapingClip:(BOOL)b {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithBool:b] forKey:@"USER_DEFAULTS_USER_VIEWED_SCRAPING_CLIP"];
    [defaults synchronize];
}

+(NSTimeInterval)getExpiryDateTimeStamp {
    NSDate *expiryDate  = (NSDate*)[SDCloudUserDefaults objectForKey:@"USER_DEFAULTS_EXPIRY_DATE"];
    if (expiryDate == nil) {
        return 0;
    }
    
    return [expiryDate timeIntervalSince1970];
}

+(NSString*)getExpiryDateString {
    NSDate *expiryDate  = (NSDate*)[SDCloudUserDefaults objectForKey:@"USER_DEFAULTS_EXPIRY_DATE"];
    if (expiryDate == nil || [UserManager daysRemainingOnSubscription] == 0.) {
        return @"당겨서 새로고침";
    }
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
//    [dateFormat setDateFormat:@"dd/MM/yyyy"];
    NSLocale *currentLocale = [NSLocale currentLocale];
    [dateFormat setDateStyle:NSDateFormatterMediumStyle];
    [dateFormat setTimeStyle:NSDateFormatterShortStyle];
    [dateFormat setLocale:currentLocale];
    
    return [NSString stringWithFormat:@"유효 기간 : %@\n(약 %.1f 일 남음)",[dateFormat stringFromDate:expiryDate],[self daysRemainingOnSubscription]];
}

+(BOOL)canPlayClip {
    if ([UserManager daysRemainingOnSubscription] > 0.) {
        return YES;
    }
    return NO;
}

+(float)daysRemainingOnSubscription {
    NSDate *expiryDate  = (NSDate*)[SDCloudUserDefaults objectForKey:@"USER_DEFAULTS_EXPIRY_DATE"];
    if (expiryDate == nil) {
        return 0.;
    }

    NSTimeInterval timeInt = [expiryDate timeIntervalSinceDate:[NSDate date]]; //Is this too complex and messy?
    float days = timeInt / 60 / 60 / 24;
    
    return days >= 0.? days : 0.;
}

+(void)expandExpiryDate:(int)days {
    if (days == -1) {
        [SDCloudUserDefaults setObject:nil forKey:@"USER_DEFAULTS_EXPIRY_DATE"];
        [SDCloudUserDefaults synchronize];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"EXPIRY_DATE_UPDATED" object:nil userInfo:@{@"EXPIRY_DATE_UPDATED":[NSNumber numberWithInt:days]}];
        return;
    }
    NSDate *expiryDate  = (NSDate*)[SDCloudUserDefaults objectForKey:@"USER_DEFAULTS_EXPIRY_DATE"];
    if (expiryDate == nil) {
        expiryDate  = [NSDate date];
    }

    NSDateFormatter *dateformatter = [NSDateFormatter new];
    [dateformatter setDateFormat:@"dd MM yyyy"];
    NSTimeInterval timeInt = [[dateformatter dateFromString:[dateformatter stringFromDate:expiryDate]] timeIntervalSinceDate: [dateformatter dateFromString:[dateformatter stringFromDate:[NSDate date]]]]; //Is this too complex and messy?
    float remainingDays = timeInt / 60 / 60 / 24;
    
    if (remainingDays < 0.) {
        remainingDays   = 0.;
    }
    
    float finalRemainingDays  = remainingDays + (float)days;
    NSDate *expandExpiryDate = [NSDate dateWithTimeInterval:finalRemainingDays*24*60*60 sinceDate:[NSDate date]];
    [SDCloudUserDefaults setObject:expandExpiryDate forKey:@"USER_DEFAULTS_EXPIRY_DATE"];
    [SDCloudUserDefaults synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"EXPIRY_DATE_UPDATED" object:nil userInfo:@{@"EXPIRY_DATE_UPDATED":[NSNumber numberWithInt:days]}];
}

@end
