//
//  StarsView.h
//  NightdanceI
//
//  Created by cable8mm on 2014. 1. 10..
//  Copyright (c) 2014년 Lee Samgu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StarsView : UIView
@property (nonatomic) int score;
@property (nonatomic, retain) UIView *emptyStars;
@property (nonatomic, retain) UIView *fullStars;

- (void)setScore:(int)score;
@end
