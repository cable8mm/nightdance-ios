//
//  SKProduct+LocalizedPrice.h
//  NightdanceI
//
//  Created by cable8mm on 2014. 1. 11..
//  Copyright (c) 2014년 Lee Samgu. All rights reserved.
//http://troybrant.net/blog/2010/01/in-app-purchases-a-full-walkthrough/

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

@interface SKProduct (LocalizedPrice)

@property (nonatomic, readonly) NSString *localizedPrice;

@end
