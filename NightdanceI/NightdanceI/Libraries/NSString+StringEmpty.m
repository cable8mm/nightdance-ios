//
//  NSString+StringEmpty.m
//  NightdanceI
//
//  Created by cable8mm on 2014. 2. 12..
//  Copyright (c) 2014년 Lee Samgu. All rights reserved.
//

#import "NSString+StringEmpty.h"

@implementation NSString (StringEmpty)
- (BOOL)isStringEmpty {
    if([self length] == 0) { //string is empty or nil
        return YES;
    }
    
    if(![[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]) {
        //string is all whitespace
        return YES;
    }
    
    return NO;
}
@end
