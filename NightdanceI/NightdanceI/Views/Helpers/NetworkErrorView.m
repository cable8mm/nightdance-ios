//
//  NetworkErrorView.m
//  NightdanceI
//
//  Created by cable8mm on 2014. 2. 21..
//  Copyright (c) 2014년 Lee Samgu. All rights reserved.
//

#import "NetworkErrorView.h"

@implementation NetworkErrorView

- (IBAction)refresh:(id)sender {
    NSLog(@"NetworkErrorView refresh");
    if (self.delegate != nil) {
        [self.delegate networkRefresh];
    }
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        [self setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
        
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
@end
