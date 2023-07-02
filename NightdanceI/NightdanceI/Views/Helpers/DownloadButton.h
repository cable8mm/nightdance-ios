//
//  DownloadButton.h
//  NightdanceI
//
//  Created by cable8mm on 2014. 1. 29..
//  Copyright (c) 2014년 Lee Samgu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Global.h"

@interface DownloadButton : UIButton
@property(nonatomic) BOOL isDownload;
@property(nonatomic) BOOL isDownloading;
@property(nonatomic) NSNumber *clipId;
@property(nonatomic) BOOL isColorful;
- (void)setStatus:(DownloadStatus) downloadStatus;
@end
