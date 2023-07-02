//
//  WishBarButtonItem.m
//  NightdanceI
//
//  Created by cable8mm on 2014. 1. 29..
//  Copyright (c) 2014년 Lee Samgu. All rights reserved.
//

#import "WishBarButtonItem.h"
#import "UserManager.h"

@implementation WishBarButtonItem
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.enabled    = YES;
    }
    
    return self;
}

- (void)setIsLogin:(BOOL)v {
    _isLogin    = v;
    
    if (v) {
        self.title  = NSLocalizedString(@"찜하기", nil);
        return;
    }
    self.title  = NSLocalizedString(@"로그인", nil);
    self.enabled    = YES;
}

@end
