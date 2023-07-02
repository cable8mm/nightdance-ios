//
//  RageIAPHelper.h
//  In App Rage
//
//  Created by Ray Wenderlich on 9/5/12.
//  Copyright (c) 2012 Razeware LLC. All rights reserved.
//

#import "IAPHelper.h"

@interface NDIAPHelper : IAPHelper

+ (NDIAPHelper *)sharedInstance;
- (void)setProductInfo;
@end
