//
//  SCManager.h
//  NightdanceI
//
//  Created by cable8mm on 2014. 1. 13..
//  Copyright (c) 2014년 Lee Samgu. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol SCManagerDelegate
-(void)didCompleteJsonData:(NSDictionary*)data tag:(NSString*)tagString;
@end

@interface SCManager : NSObject
@property (nonatomic) id<SCManagerDelegate> delegate;
+(SCManager*)sharedObject;
+(NSDictionary *)getClip:(int)key;
+(NSArray *)getSearchClips:(NSString *)word;
+(NSArray *)getClips;
+(NSArray *)getClips:(int)rowCount;
+(NSArray*)getPackages;
+(NSDictionary*)getPackage:(int)packId;
+(NSArray *)getComments:(int)clipId;
+(NSString*)getAccessToken;
+(NSDictionary *)getUserInfo:(NSString *)username password:(NSString *)password;
+(NSArray*)getProductIds;
+(NSDictionary*)getJsonData:(NSString*)urlString;
+(NSString*)getAuthUrl:(NSString*)filename;
+(NSString*)getAuthUrl:(NSString*)filename param:(NSString*)pStr;
+(NSDictionary*)getJsonPostData:(NSString*)urlString post:(NSDictionary*)postObject;
@end
