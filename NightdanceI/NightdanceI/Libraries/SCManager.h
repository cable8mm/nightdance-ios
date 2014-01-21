//
//  SCManager.h
//  NightdanceI
//
//  Created by cable8mm on 2014. 1. 13..
//  Copyright (c) 2014년 Lee Samgu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCManager : NSObject
+(NSDictionary *)getClip:(int)key;
+(NSArray *)getSearchClips:(NSString *)word;
+(NSArray *)getClips;
+(NSArray *)getClips:(int)rowCount;
+(NSArray*)getPackages;
+(NSDictionary*)getPackage:(int)packId;
+(NSArray *)getComments:(int)clipId;
+(NSString*)getAccessToken;
+(NSDictionary *)getUserInfo:(NSString *)username password:(NSString *)password;
@end
