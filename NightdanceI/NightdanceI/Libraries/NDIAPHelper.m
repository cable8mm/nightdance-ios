//
//  RageIAPHelper.m
//  In App Rage
//
//  Created by Ray Wenderlich on 9/5/12.
//  Copyright (c) 2012 Razeware LLC. All rights reserved.
//

#import "NDIAPHelper.h"

@implementation NDIAPHelper

+ (NDIAPHelper *)sharedInstance {
    static dispatch_once_t once;
    static NDIAPHelper * sharedInstance;
    dispatch_once(&once, ^{
        NSSet * productIdentifiers = [NSSet setWithObjects:
                                      @"FREE_TICKET_7",
                                      @"FREE_TICKET_30",
                                      nil];
        sharedInstance = [[self alloc] initWithProductIdentifiers:productIdentifiers];
        [sharedInstance setProductInfo];
    });
    return sharedInstance;
}

- (void)setProductInfo {
    if (_productsInfo == nil) {
        _productsInfo = @{
                         @"FREE_TICKET_7" : @{
                                 @"term" : [NSNumber numberWithInt:7],
                                 @"imageUrl" : @"http://mail.nightdance.co.kr/img11/my/ticket_day_s.gif"
                                 },
                         @"FREE_TICKET_30" : @{
                                 @"term" : [NSNumber numberWithInt:30],
                                 @"imageUrl" : @"http://mail.nightdance.co.kr/img11/my/ticket_mon_s.gif"
                                 }
                        };
    }
}

@end
