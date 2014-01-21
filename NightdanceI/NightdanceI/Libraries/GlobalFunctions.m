//
//  GlobalFunctions.m
//  NightdanceI
//
//  Created by cable8mm on 2014. 1. 20..
//  Copyright (c) 2014년 Lee Samgu. All rights reserved.
//

#import "GlobalFunctions.h"

// http://stackoverflow.com/questions/2233824/how-to-add-commas-to-number-every-3-digits-in-objective-c
NSString *GetCommaNumber(int number) {
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    NSString *formatted = [formatter stringFromNumber:[NSNumber numberWithInteger:number]];

    return formatted;
}