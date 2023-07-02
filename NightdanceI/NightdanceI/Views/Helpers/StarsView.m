//
//  StarsView.m
//  NightdanceI
//
//  Created by cable8mm on 2014. 1. 10..
//  Copyright (c) 2014년 Lee Samgu. All rights reserved.
//

#import "StarsView.h"

@implementation StarsView

@synthesize emptyStars, fullStars, score;

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.emptyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0., 2., 74., 14.)];
        self.emptyLabel.font    = [UIFont systemFontOfSize:12.];
        self.emptyLabel.textColor   = [UIColor grayColor];
        self.emptyLabel.text    = @"점수 없음";
        self.emptyStars = [[UIView alloc] initWithFrame:CGRectMake(0., 0., 74., 14.)];
        self.fullStars = [[UIView alloc] initWithFrame:CGRectMake(0., 0., 74., 14.)];
        self.fullStars.clipsToBounds    = YES;
        
        for (int i=0; i < 5; i++) {
            UIImageView *emptyStarImage  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"StarEmpty.png"]];
            emptyStarImage.center   = CGPointMake(7. + i * 14., 7.);
            [self.emptyStars addSubview:emptyStarImage];
            
            UIImageView *fullStarImage  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"StarFull.png"]];
            fullStarImage.center   = CGPointMake(7. + i * 14., 7.);
            [self.fullStars addSubview:fullStarImage];
        }
        
        [self addSubview:self.emptyLabel];
        [self addSubview:self.emptyStars];
        [self addSubview:self.fullStars];
    }
    return self;
}

- (void)setScore:(int)v {
    if (v < 1) {
        self.emptyStars.hidden  = YES;
        self.fullStars.hidden  = YES;
        self.emptyLabel.hidden  = NO;
    } else {
        self.emptyStars.hidden  = NO;
        self.fullStars.hidden  = NO;
        self.emptyLabel.hidden  = YES;
    }
    float scoreWidth    = (float)v * 7.;
    [self.fullStars setFrame:CGRectMake(0., 0., scoreWidth, 14.)];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
