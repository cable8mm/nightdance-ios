//
//  DownloadButton.m
//  NightdanceI
//
//  Created by cable8mm on 2014. 1. 29..
//  Copyright (c) 2014년 Lee Samgu. All rights reserved.
//

#import "DownloadButton.h"

@implementation DownloadButton

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.titleLabel.textColor   = self.tintColor;
        self.backgroundColor    = [UIColor whiteColor];
        self.layer.cornerRadius = 3;
        self.titleLabel.layer.masksToBounds = YES;
        [self.layer setBorderColor:[self.tintColor CGColor]];
        [self.layer setBorderWidth: 1.0];
        
        [self setTitle:@"다운로드" forState:UIControlStateNormal];
        [self setTitle:@"다운로드" forState:UIControlStateDisabled];
        [self setTitle:@"다운로드" forState:UIControlStateHighlighted];
        [self setTitle:@"다운로드 중" forState:UIControlStateSelected];
        
        self.layer.borderColor  = self.tintColor.CGColor;
        [self setTitleColor:self.tintColor forState:UIControlStateNormal];
        [self setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];

        self.isDownloading  = NO;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didCompleteDownload:) name:@"NOTI_DOWNLOAD_CLIP_END" object:nil];

    }

    return self;
}

- (void) didCompleteDownload:(NSNotification *) notification {
    NSDictionary *userInfo  = [notification userInfo];
    if ([[userInfo objectForKey:@"CLIP_ID"] isEqualToNumber:self.clipId]) {
        self.isDownload = YES;
    }
}

- (void)setStatus:(DownloadStatus) downloadStatus {
    switch (downloadStatus) {
        case DownloadStatusReady:
        self.isDownload = NO;
        break;
        case DownloadStatusReceived:
        self.isDownloading  = YES;
        break;
        case DownloadStatusComplete:
        self.isDownload = YES;
        break;
        
        default:
        break;
    }
}

- (void)setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];
    self.isColorful = enabled;
}

-(void)setIsDownloading:(BOOL)isDownloading {
    if (isDownloading == YES) {
        [self setTitle:@"다운로드 중" forState:UIControlStateNormal];
        self.isColorful = NO;
    }
}

- (void)setIsColorful:(BOOL)isColorful {
    if (isColorful) {
        self.userInteractionEnabled = YES;
        self.layer.borderColor  = self.tintColor.CGColor;
        [self setTitleColor:self.tintColor forState:UIControlStateNormal];
        [self setTitleColor:self.tintColor forState:UIControlStateHighlighted];
        [self setTitleColor:self.tintColor forState:UIControlStateDisabled];
        [self setTitleColor:self.tintColor forState:UIControlStateSelected];
    } else {
        self.layer.borderColor  = [[UIColor lightGrayColor] CGColor];
        [self setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [self setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
        [self setTitleColor:[UIColor lightGrayColor] forState:UIControlStateSelected];
        self.userInteractionEnabled = NO;
    }
}

- (void)setIsDownload:(BOOL)download {
    _isDownload = download;
    
    if (download) {
        [self setTitle:@"다운로드 됨" forState:UIControlStateNormal];
        self.isColorful = NO;
    } else {
        [self setTitle:@"다운로드" forState:UIControlStateNormal];
        self.isColorful = YES;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
