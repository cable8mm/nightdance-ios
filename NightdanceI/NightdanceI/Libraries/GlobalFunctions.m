//
//  GlobalFunctions.m
//  NightdanceI
//
//  Created by cable8mm on 2014. 1. 20..
//  Copyright (c) 2014년 Lee Samgu. All rights reserved.
//

#import "GlobalFunctions.h"
#include <sys/time.h>

// http://stackoverflow.com/questions/2233824/how-to-add-commas-to-number-every-3-digits-in-objective-c
NSString *GetCommaNumber(int number) {
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    NSString *formatted = [formatter stringFromNumber:[NSNumber numberWithInteger:number]];

    return formatted;
}

NSString *GetHMFromSeconds(int seconds) {
    int hours = (int)floorf(seconds / 3600);
    int minutes = (int)ceilf((seconds % 3600) / 60);
    
    return [NSString stringWithFormat:@"%i 시간 %i 분", hours, minutes];
}

int GetClockCount()
{
	struct timeval gettick;
	gettimeofday(&gettick, NULL);
//	return (unsigned int)(gettick.tv_sec * 1000 + gettick.tv_usec / 1000);
    return (int)gettick.tv_sec;
}