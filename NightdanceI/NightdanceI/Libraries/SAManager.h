//
//  SAManager.h
//  NightdanceI
//
//  Created by cable8mm on 2014. 1. 19..
//  Copyright (c) 2014년 Lee Samgu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SAManager : NSObject
-(id)initWithUUID:(NSString*)appKey;
+(NSString*)genAppKey;
+(NSString*)getAppKey;
+(void)setAppKey;
+(NSString *)getAccessToken;
+(void)setAccessToken:(NSString*)token;
+(void)syncForce;
@end
