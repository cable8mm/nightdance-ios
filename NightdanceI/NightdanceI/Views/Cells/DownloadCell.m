//
//  DownloadCell.m
//  NightdanceI
//
//  Created by cable8mm on 2014. 1. 27..
//  Copyright (c) 2014년 Lee Samgu. All rights reserved.
//

#import "DownloadCell.h"
#import "DownloadManager.h"
#import "GlobalFunctions.h"

@implementation DownloadCell

- (id)initWithCoder:(NSCoder *)aDecoder {   // this is it!
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(progressUpdated:) name:@"NOTI_DOWNLOAD_CLIPS_UPDATED" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(complete:) name:@"NOTI_DOWNLOAD_CLIPS_COMPLETE" object:nil];
        
//        UIImage *playImage  = [UIImage imageNamed:@"btn_play_small_focus.png"];
//        UIButton *accessoryButton   = [UIButton buttonWithType:UIButtonTypeCustom];
////        accessoryButton.frame   = CGRectMake(0.0, 0.0, playImage.size.width, playImage.size.height);
//        accessoryButton.frame   = CGRectMake(0.0, 0.0, 50.,65.);
//        accessoryButton.backgroundColor = [UIColor lightGrayColor];
//        accessoryButton.imageView.exclusiveTouch    = YES;
//        [accessoryButton setImage:playImage forState:UIControlStateNormal];
//        [accessoryButton setImage:playImage forState:UIControlStateHighlighted];
//        [accessoryButton setImage:playImage forState:UIControlStateDisabled];
//        [accessoryButton setImage:playImage forState:UIControlStateSelected];
//        self.accessoryView  = accessoryButton;
        self.downloadButton.hidden  = YES;
        [self isDownload:NO];
    }
    return self;
}

// 
- (void)remainSeconds:(int) v {
    if (v == -1) {
        self.remainLabel.text   = @"기간 제한 없음";
        return;
    }
        
    DownloadClip *downloadClip  = [[DownloadManager sharedObject].downloadClips objectAtIndex:self.indexpathRow];

    int currentClockSecond  = GetClockCount();
    int currentRemainSeconds    = (v - (currentClockSecond-[downloadClip.makeSeconds intValue]));
    
    if (currentRemainSeconds < 0) {
        currentRemainSeconds    = 0;
    }
    
    NSString *HMString  = GetHMFromSeconds(currentRemainSeconds);
    self.remainLabel.text   = [NSString stringWithFormat:@"Remain Time : %@", HMString];
}

- (void)isDownload:(BOOL)v {
    self.isDownload = v;
    
    if (self.isDownload == YES) {   // 다운로드 끝
        self.progressView.hidden    = YES;
        self.remainLabel.hidden     = NO;
        self.downloadButton.enabled = YES;
    } else {
        self.progressView.hidden    = NO;
        self.remainLabel.hidden     = YES;
        self.downloadButton.enabled = NO;
    }
}

- (void) progressUpdated:(NSNotification *) notification {
    DownloadClip *downloadClip  = [[DownloadManager sharedObject].downloadClips objectAtIndex:self.indexpathRow];
    self.progressView.progress  = [downloadClip.progress floatValue];
}

- (void) complete:(NSNotification *) notification {
    DownloadClip *downloadClip  = [[DownloadManager sharedObject].downloadClips objectAtIndex:self.indexpathRow];
    downloadClip.status = DownloadStatusComplete;
    [self isDownload:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
    self.thumbnail.layer.cornerRadius = 5;
    self.thumbnail.layer.masksToBounds = YES;
    [self.thumbnail.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [self.thumbnail.layer setBorderWidth: 1.0];
}

-(void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
