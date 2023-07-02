//
//  DownloadClip.h
//  NightdanceI
//
//  Created by cable8mm on 2014. 1. 27..
//  Copyright (c) 2014년 Lee Samgu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Global.h"

@interface DownloadClip : NSObject
@property(nonatomic, retain) NSURLSessionDownloadTask *downloadTask;
@property(nonatomic, retain) NSString *clipTitle;
@property(nonatomic, retain) NSString *thumbnailString;
@property(nonatomic, retain) NSNumber *remainSeconds;
@property(nonatomic, retain) NSNumber *makeSeconds;
@property(nonatomic) NSNumber *progress;
@property(nonatomic, retain) NSString *filename;    // 요놈이 키
@property(nonatomic) DownloadStatus status;
@property(nonatomic) NSNumber *objStatus;
@property(nonatomic) NSNumber *clipId;
@property(nonatomic) NSNumber *objIsFree;
@property(nonatomic) BOOL isFree;
- (NSURL*)getFileURL;
@end
