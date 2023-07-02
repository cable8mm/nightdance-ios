//
//  DownloadClip.m
//  NightdanceI
//
//  Created by cable8mm on 2014. 1. 27..
//  Copyright (c) 2014년 Lee Samgu. All rights reserved.
//

#import "DownloadClip.h"

@implementation DownloadClip

@synthesize status=_status, isFree=_isFree;

- (id)init {
    self = [super init];
    if (self) {
        self.progress   = [NSNumber numberWithFloat:0.];
        self.status = DownloadStatusReady;
    }
    return self;
}

// http://stackoverflow.com/questions/537044/storing-custom-objects-in-an-nsmutablearray-in-nsuserdefaults
- (id) initWithCoder: (NSCoder *)coder
{
    if (self = [super init])
    {
    	self.downloadTask = [coder decodeObjectForKey:@"downloadTask"];
    	self.clipTitle = [coder decodeObjectForKey:@"clipTitle"];
    	self.progress = [coder decodeObjectForKey:@"progress"];
    	self.filename = [coder decodeObjectForKey:@"filename"];
    	self.objStatus = [coder decodeObjectForKey:@"isDownload"];
    	self.clipId = [coder decodeObjectForKey:@"clipId"];
    	self.thumbnailString = [coder decodeObjectForKey:@"thumbnailString"];
        self.remainSeconds  = [coder decodeObjectForKey:@"remainSeconds"];
        self.makeSeconds    = [coder decodeObjectForKey:@"makeSeconds"];
        self.objIsFree    = [coder decodeObjectForKey:@"isFree"];
    }
    
    return self;
}

- (void) encodeWithCoder: (NSCoder *)coder
{
    [coder encodeObject:_downloadTask forKey:@"downloadTask"];
    [coder encodeObject:_clipTitle forKey:@"clipTitle"];
    [coder encodeObject:_progress forKey:@"progress"];
    [coder encodeObject:_filename forKey:@"filename"];
    [coder encodeObject:_objStatus forKey:@"isDownload"];
    [coder encodeObject:_clipId forKey:@"clipId"];
    [coder encodeObject:_thumbnailString forKey:@"thumbnailString"];
    [coder encodeObject:_remainSeconds forKey:@"remainSeconds"];
    [coder encodeObject:_makeSeconds forKey:@"makeSeconds"];
    [coder encodeObject:_objIsFree forKey:@"isFree"];
}

- (void) setIsFree:(BOOL)isFree {
    _isFree = isFree;
    _objIsFree  = [NSNumber numberWithBool:_isFree];
}

- (BOOL)isFree {
    return [_objIsFree boolValue];
}

- (DownloadStatus)status {
    return [_objStatus intValue];
}

- (void)setStatus:(DownloadStatus)status {
    _status = status;
    _objStatus  = [NSNumber numberWithInt:status];
}

- (NSURL*)getFileURL {
    NSString *documentsPath    = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString* fullFile = [documentsPath stringByAppendingPathComponent:self.filename];
    BOOL documentFileExists = [[NSFileManager defaultManager] fileExistsAtPath:fullFile];
    NSString *filePath;
    
    if (documentFileExists) {
        filePath        = [documentsPath stringByAppendingPathComponent:self.filename];
    } else {    
        NSString *cachesPath    = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
        filePath        = [cachesPath stringByAppendingPathComponent:self.filename];
    }
    
    NSURL *fileURL  = [NSURL fileURLWithPath:filePath];
    return fileURL;
}

-(void)removeFile {
//    NSString *documentsPath    = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
//    NSString *filePath        = [documentsPath stringByAppendingPathComponent:self.filename];
//    NSURL *fileURL  = [NSURL fileURLWithPath:filePath];
}

@end
