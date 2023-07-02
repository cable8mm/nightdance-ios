//
//  ClipCell.m
//  NightdanceI
//
//  Created by cable8mm on 2014. 1. 10..
//  Copyright (c) 2014년 Lee Samgu. All rights reserved.
//

#import "ClipCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation ClipCell

- (id)initWithCoder:(NSCoder *)aDecoder {   // this is it!
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
//        [self setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
    self.thumbnail.layer.cornerRadius = 5;
    self.thumbnail.layer.masksToBounds = YES;
    [self.thumbnail.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [self.thumbnail.layer setBorderWidth: 1.0];
}

- (void)setCommentCount:(NSNumber *)commentCount {
    self.commentCountLabel.text = [NSString stringWithFormat:@"%@개", [commentCount stringValue]];
}
@end
