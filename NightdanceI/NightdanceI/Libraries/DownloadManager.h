//
//  DownloadManager.h
//  NightdanceI
//
//  Created by cable8mm on 2014. 1. 25..
//  Copyright (c) 2014년 Lee Samgu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DownloadClip.h"

@interface DownloadManager : NSObject <NSURLSessionDelegate, NSURLSessionTaskDelegate, NSURLSessionDownloadDelegate>
@property(nonatomic, retain) NSMutableArray *downloadClips;
@property (strong, nonatomic) NSURLSession *session;
@property (strong, nonatomic) NSURLSessionDataTask *dataTask;
+ (DownloadManager*)sharedObject;
- (void) addDownloadingClip:(int)clipId title:(NSString *)clipTitle url:(NSString*)downloadUrl thumbnail:(NSString*)thumbnail remain:(int)seconds isFree:(NSNumber *)isFree;
- (DownloadClip*)getDownloadClipFromDataTask:(NSURLSessionDownloadTask*)downloadTask;
- (DownloadClip*) getDownloadClip:(int)clipId;
- (NSURL*)getFileURLFromFile:(NSString*)filename;
- (NSURL*)getFileURLFromClipId:(int)clipId;
- (void) removeDownloadClip:(int)clipId;
- (BOOL) isDownloadClip:(int)clipId;
@end
