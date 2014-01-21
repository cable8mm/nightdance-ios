//
//  SKProduct+LocalizedPrice.m
//  NightdanceI
//
//  Created by cable8mm on 2014. 1. 11..
//  Copyright (c) 2014년 Lee Samgu. All rights reserved.
//

#import "SKProduct+LocalizedPrice.h"

@implementation SKProduct (LocalizedPrice)

- (NSString *)localizedPrice
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [numberFormatter setLocale:self.priceLocale];
    NSString *formattedString = [numberFormatter stringFromNumber:self.price];
//    [numberFormatter release];
    return formattedString;
}

@end
