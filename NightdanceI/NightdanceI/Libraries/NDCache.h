//
//  NDCache.h
//  NightdanceI
//
//  Created by cable8mm on 2014. 1. 28..
//  Copyright (c) 2014년 Lee Samgu. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^NDCacheRequestCompletionBlock)(UIImage *sourceImage);
@interface NDCache : NSObject
@property (strong ,nonatomic) NSMutableDictionary *cachedImages;
+ (NDCache*)sharedObject;
- (void)assignCachedImage:(NSString*)urlString completionBlock:(NDCacheRequestCompletionBlock)completionBlock;
@end
