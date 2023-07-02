//
//  DownloadManager.m
//  NightdanceI
//
//  Created by cable8mm on 2014. 1. 25..
//  Copyright (c) 2014년 Lee Samgu. All rights reserved.
//

#import "DownloadManager.h"
#import "AppDelegate.h"
#import "GlobalFunctions.h"

#define KEY_PREFIX  @"FILEPATH_"

@implementation DownloadManager

+ (DownloadManager*)sharedObject
{
    static dispatch_once_t once;
    static DownloadManager *sharedObject;
    dispatch_once(&once, ^{
        sharedObject = [[self alloc] init];
        // Session Initialize
        sharedObject.session = [sharedObject backgroundSession];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        NSData *dataRepresentingSavedArray = [defaults objectForKey:@"USER_DEFAULT_DOWNLOADED_CLIPS"];
        if (dataRepresentingSavedArray != nil)
        {
            NSArray *oldSavedArray = [NSKeyedUnarchiver unarchiveObjectWithData:dataRepresentingSavedArray];
            if (oldSavedArray != nil)
                sharedObject.downloadClips = [[NSMutableArray alloc] initWithArray:oldSavedArray];
            else
                sharedObject.downloadClips = [[NSMutableArray alloc] init];
        } else {
            sharedObject.downloadClips = [[NSMutableArray alloc] init];
        }
    });

    return sharedObject;
}

- (void) removeDownloadClip:(int)clipId {
    for (DownloadClip *downloadClip in self.downloadClips) {
        if ([downloadClip.clipId intValue] == clipId) {
            // 파일 지우기
//            NSString *documentsPath    = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
            NSString *documentsPath    = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];

            NSString *filename  = [[[downloadClip.downloadTask originalRequest] URL] lastPathComponent];
            NSString *finalPath        = [documentsPath stringByAppendingPathComponent:filename];
            NSFileManager *fileManager = [NSFileManager defaultManager];

            BOOL success;
            NSError *error;

            if ([fileManager fileExistsAtPath:finalPath]) {
                success = [fileManager removeItemAtPath:finalPath error:&error];
                NSAssert(success, @"removeItemAtPath error: %@", error);
            }

            // 다운로드 클립에서 삭제
            if ([downloadClip.downloadTask state] == NSURLSessionTaskStateRunning || [downloadClip.downloadTask state] == NSURLSessionTaskStateSuspended) {
                [downloadClip.downloadTask cancel];
            }
            [self.downloadClips removeObject:downloadClip];
            NSArray *userDefaultDownloadClips    = [self.downloadClips copy];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:userDefaultDownloadClips];
            [defaults setObject:data forKey:@"USER_DEFAULT_DOWNLOADED_CLIPS"];
            [defaults synchronize];
            return;
        }
    }
}

- (void) addDownloadingClip:(int)clipId title:(NSString *)clipTitle url:(NSString*)downloadUrl thumbnail:(NSString*)thumbnail remain:(int)seconds isFree:(NSNumber *)isFree {
    DownloadClip *downloadClip  = [[DownloadClip alloc] init];
    downloadClip.clipTitle  = clipTitle;
    downloadClip.clipId = [NSNumber numberWithInt:clipId];
    downloadClip.thumbnailString    = thumbnail;
    downloadClip.remainSeconds  = [NSNumber numberWithInt:seconds];
    downloadClip.makeSeconds    = [NSNumber numberWithInt:GetClockCount()];
    downloadClip.isFree = [isFree boolValue];
    
    NSURL *downloadURL = [NSURL URLWithString:downloadUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:downloadURL];
    downloadClip.downloadTask = [self.session downloadTaskWithRequest:request];
    [downloadClip.downloadTask resume];

    [self.downloadClips addObject:downloadClip];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTI_DOWNLOAD_CLIPS_START"
                                                        object:nil];
}

- (NSString*)genKey:(int)clipId {
    return [NSString stringWithFormat:@"%@%d", KEY_PREFIX, clipId];
}

- (NSURLSession *)backgroundSession {
#define kBackgroundId @"kr.co.nightdance.NightdanceI.BackgroundSession"
    static NSURLSession *session = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration backgroundSessionConfiguration:kBackgroundId];
        session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    });
    return session;
}

- (DownloadClip*)getDownloadClipFromDataTask:(NSURLSessionDownloadTask*)downloadTask {
    for (DownloadClip *downloadClip in self.downloadClips) {
        if ([downloadClip.downloadTask isEqual:downloadTask]) {
            return downloadClip;
        }
    }
    return nil;
}

- (NSURL*)getFileURLFromFile:(NSString*)filename {
    for (DownloadClip *downloadClip in self.downloadClips) {
        if ([downloadClip.filename isEqual:filename]) {
            return [downloadClip getFileURL];
        }
    }
    return nil;
}

- (NSURL*)getFileURLFromClipId:(int)clipId {
    for (DownloadClip *downloadClip in self.downloadClips) {
        if ([downloadClip.clipId intValue] == clipId) {
            return [downloadClip getFileURL];
        }
    }
    return nil;
}

- (BOOL) isDownloadClip:(int)clipId {
    for (DownloadClip *downloadClip in self.downloadClips) {
        if ([downloadClip.clipId intValue] == clipId && downloadClip.status == DownloadStatusComplete) {
            return YES;
        }
    }
    return NO;
}

- (DownloadClip*) getDownloadClip:(int)clipId {
    for (DownloadClip *downloadClip in self.downloadClips) {
        if ([downloadClip.clipId intValue] == clipId) {
            return downloadClip;
        }
    }
    return nil;
}


#pragma mark NSURLSessionDelegate
- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (appDelegate.backgroundSessionCompletionHandler) {
        void (^completionHandler)() = appDelegate.backgroundSessionCompletionHandler;
        appDelegate.backgroundSessionCompletionHandler = nil;
        completionHandler();
    }
    NSLog(@"All tasks are finished");
}

#pragma mark NSURLSessionTaskDelegate
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    if (error == nil) {
        NSLog(@"Task: %@ completed successfully", task);
    } else {
        NSLog(@"Task: %@ completed with error: %@", task, [error localizedDescription]);
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTI_DOWNLOAD_CLIPS_END"
                                                        object:nil];
}

#pragma mark NSURLSessionDownloadDelegate
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    NSString *documentsPath    = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
//    NSString *documentsPath    = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *filename  = [[[downloadTask originalRequest] URL] lastPathComponent];
    NSString *finalPath        = [documentsPath stringByAppendingPathComponent:filename];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL success;
    NSError *error;
    if ([fileManager fileExistsAtPath:finalPath]) {
        success = [fileManager removeItemAtPath:finalPath error:&error];
        NSAssert(success, @"removeItemAtPath error: %@", error);
    }
    
    success = [fileManager moveItemAtURL:location toURL:[NSURL fileURLWithPath:finalPath] error:&error];
    NSLog(@"filename = %@, finalpath = %@", filename, finalPath);
    NSAssert(success, @"moveItemAtURL error: %@", error);
    DownloadClip* downloadClip  = [self getDownloadClipFromDataTask:downloadTask];
    downloadClip.filename   = filename;
    downloadClip.status = DownloadStatusComplete;
    
    NSArray *userDefaultDownloadClips    = [self.downloadClips copy];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:userDefaultDownloadClips];
    [defaults setObject:data forKey:@"USER_DEFAULT_DOWNLOADED_CLIPS"];
    [defaults synchronize];
    
    //NOTI_DOWNLOAD_CLIPS_COMPLETE
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTI_DOWNLOAD_CLIPS_COMPLETE"
                                                        object:nil];
    
    // NOTI_DOWNLOAD_CLIPS_END
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTI_DOWNLOAD_CLIP_END"
                                                        object:nil
                                                      userInfo:@{@"CLIP_ID": downloadClip.clipId}];

}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    DownloadClip* downloadClip  = [self getDownloadClipFromDataTask:downloadTask];
    downloadClip.status = DownloadStatusReceived;
    if (downloadTask == downloadClip.downloadTask) {
        double progress = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
//        NSLog(@"DownloadTask: %@ progress: %lf", downloadTask, progress);
        dispatch_async(dispatch_get_main_queue(), ^{
            downloadClip.progress   = [NSNumber numberWithFloat:progress];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTI_DOWNLOAD_CLIPS_UPDATED"
                                                                object:nil];
        });
    }
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
 didResumeAtOffset:(int64_t)fileOffset
expectedTotalBytes:(int64_t)expectedTotalBytes {
    
}
@end
