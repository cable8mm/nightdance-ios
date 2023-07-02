//
//  NDCache.m
//  NightdanceI
//
//  Created by cable8mm on 2014. 1. 28..
//  Copyright (c) 2014년 Lee Samgu. All rights reserved.
//

#import "NDCache.h"

@implementation NDCache
+ (NDCache*)sharedObject
{
    static dispatch_once_t once;
    static NDCache *sharedObject;
    dispatch_once(&once, ^{
        sharedObject = [[self alloc] init];
        sharedObject.cachedImages   = [[NSMutableDictionary alloc] init];
    });
    return sharedObject;
}

- (void)assignCachedImage:(NSString*)urlString completionBlock:(NDCacheRequestCompletionBlock)completionBlock {
    if (urlString == nil) {
        return;
    }
    if([self.cachedImages objectForKey:urlString] != nil){
        if (completionBlock != nil) {
            UIImage *showImage = [self.cachedImages valueForKey:urlString];
            completionBlock(showImage);
        }
    }else{
        char const * s = [urlString  UTF8String];
        dispatch_queue_t queue = dispatch_queue_create(s, 0);
        dispatch_async(queue, ^{
            UIImage *img = nil;
            NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:urlString]];
            img = [[UIImage alloc] initWithData:data];
            [self.cachedImages setValue:img forKey:urlString];
            if (completionBlock != nil) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIImage *showImage = [self.cachedImages valueForKey:urlString];
                    completionBlock(showImage);
                });
            }
        });
    }
}

@end
