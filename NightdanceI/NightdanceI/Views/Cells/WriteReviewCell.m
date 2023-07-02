//
//  WriteReviewCell.m
//  NightdanceI
//
//  Created by cable8mm on 2014. 2. 17..
//  Copyright (c) 2014년 Lee Samgu. All rights reserved.
//

#import "WriteReviewCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation WriteReviewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {   // this is it!
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    self.titleLabel.textColor   = self.tintColor;
//    if (selected) {
//        self.titleLabel.textColor   = [UIColor whiteColor];
//        self.titleLabel.backgroundColor    = self.tintColor;
//        self.titleLabel.layer.cornerRadius = 5;
//        self.titleLabel.layer.masksToBounds = YES;
//        [self.titleLabel.layer setBorderColor:[self.tintColor CGColor]];
//        [self.titleLabel.layer setBorderWidth: 1.0];
//    } else {
//        self.titleLabel.textColor   = self.tintColor;
//        self.titleLabel.backgroundColor    = [UIColor whiteColor];
//        self.titleLabel.layer.cornerRadius = 5;
//        self.titleLabel.layer.masksToBounds = YES;
//        [self.titleLabel.layer setBorderColor:[self.tintColor CGColor]];
//        [self.titleLabel.layer setBorderWidth: 1.0];
//    }
}

@end
