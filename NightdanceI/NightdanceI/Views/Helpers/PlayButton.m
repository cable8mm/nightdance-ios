//
//  PlayButton.m
//  NightdanceI
//
//  Created by cable8mm on 2014. 1. 28..
//  Copyright (c) 2014년 Lee Samgu. All rights reserved.
//

#import "PlayButton.h"
#import <QuartzCore/QuartzCore.h>

@implementation PlayButton

- (id)initWithCoder:(NSCoder *)aDecoder {   // 76.x30.
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.titleLabel.textColor   = self.tintColor;
        self.backgroundColor    = [UIColor whiteColor];
        self.layer.cornerRadius = 3;
        self.titleLabel.layer.masksToBounds = YES;
        [self.layer setBorderColor:[self.tintColor CGColor]];
        [self.layer setBorderWidth: 1.0];
//        [self setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal|UIControlStateHighlighted|UIControlStateDisabled|UIControlStateSelected)];
        [self setTitleColor:self.tintColor forState:UIControlStateNormal];
        [self setTitleColor:self.tintColor forState:UIControlStateSelected];
        [self setTitle:@"강좌 시청" forState:UIControlStateNormal];
        [self setTitle:@"시청 중..." forState:UIControlStateSelected];
    }
    
    return self;
}

- (void)setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];
    if (enabled == NO) {
        self.layer.borderColor  = [[UIColor whiteColor] CGColor];
        self.backgroundColor    = [UIColor whiteColor];
        self.titleLabel.textColor   = [UIColor lightGrayColor];
    } else {
        self.layer.borderColor  = [[UIColor lightGrayColor] CGColor];
        self.backgroundColor    = [UIColor lightGrayColor];
        self.titleLabel.textColor   = [UIColor whiteColor];
    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}

@end
