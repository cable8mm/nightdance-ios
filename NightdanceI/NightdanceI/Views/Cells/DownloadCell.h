//
//  DownloadCell.h
//  NightdanceI
//
//  Created by cable8mm on 2014. 1. 27..
//  Copyright (c) 2014년 Lee Samgu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DownloadCellButton.h"

@interface DownloadCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *remainLabel;
@property (nonatomic, weak) IBOutlet UIProgressView *progressView;
@property (nonatomic, weak) IBOutlet UILabel *statusLabel;
@property (nonatomic) int indexpathRow;
@property (nonatomic) BOOL isDownload;
@property (nonatomic, retain) IBOutlet UIImageView *thumbnail;
@property (nonatomic, retain) IBOutlet DownloadCellButton *downloadButton;
- (void)isDownload:(BOOL)v;
- (void)remainSeconds:(int) v;
@end
