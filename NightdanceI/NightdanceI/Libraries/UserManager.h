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
+(void)setNickname:(NSString *)nickname;
+(int)getNcash;
+(void)setNcash:(NSNumber*)ncash;
+(void)logout;
+(void)addNcash:(NSNumber*)ncash;
+(BOOL)isViewedPurchasingClip;
+(void)setViewedPurchasingClip:(BOOL)b;
+(BOOL)isViewedScrapingClip;
+(void)setViewedScrapingClip:(BOOL)b;
+(NSArray *)getScrapedClips;
+(void)addScrapedClip:(NSNumber *)clipId;
+(void)removeScrapedClip:(NSNumber *)clipId;
+(BOOL)isScrapedClip:(NSNumber *)clipId;
+(void)expandExpiryDate:(int)days;
+(NSString *)getExpiryDateString;
+(float)daysRemainingOnSubscription;
+(BOOL)canPlayClip;
+(NSTimeInterval)getExpiryDateTimeStamp;
@end
