//
//  DownloadCellButton.m
//  NightdanceI
//
//  Created by cable8mm on 2014. 2. 19..
//  Copyright (c) 2014년 Lee Samgu. All rights reserved.
//

#import "DownloadCellButton.h"

@implementation DownloadCellButton

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.titleLabel.textColor   = self.tintColor;
        self.backgroundColor    = [UIColor whiteColor];
        self.layer.cornerRadius = 3;
        self.titleLabel.layer.masksToBounds = YES;
        [self.layer setBorderColor:[self.tintColor CGColor]];
        [self.layer setBorderWidth: 1.0];

        [self setTitle:@"강좌 시청" forState:UIControlStateNormal];
        [self setTitle:@"다운로드 중" forState:UIControlStateDisabled];
        [self setTitle:@"시청하기" forState:UIControlStateHighlighted];
        [self setTitle:@"시청 중..." forState:UIControlStateSelected];

        self.layer.borderColor  = self.tintColor.CGColor;
        [self setTitleColor:self.tintColor forState:UIControlStateNormal];
        [self setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        
        self.isFreezing = NO;
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code

    }
    return self;
}

- (void)setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];
    if (enabled == NO) {
        self.layer.borderColor  = [[UIColor lightGrayColor] CGColor];
        self.titleLabel.textColor   = [UIColor lightGrayColor];
    } else {
        self.layer.borderColor  = self.tintColor.CGColor;
        self.titleLabel.textColor   = self.tintColor;
    }
}

- (void)timeout {
    [self setTitle:@"기간 만료" forState:UIControlStateDisabled];
    self.enabled    = NO;
}

- (void)setIsFreezing:(BOOL)isFreezing {
    if (_isFreezing == isFreezing) {
        return;
    }
    
    if (isFreezing) {
        self.layer.borderColor  = [[UIColor lightGrayColor] CGColor];
        self.titleLabel.textColor   = [UIColor lightGrayColor];
        self.userInteractionEnabled = NO;
    } else {
        self.layer.borderColor  = self.tintColor.CGColor;
        self.titleLabel.textColor   = self.tintColor;
        self.userInteractionEnabled = YES;
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

@end
