//
//  ClipDetailCell.m
//  NightdanceI
//
//  Created by cable8mm on 2014. 1. 9..
//  Copyright (c) 2014년 Lee Samgu. All rights reserved.
//

#import "ClipDetailCell.h"

@implementation ClipDetailCell

@synthesize artist, genreTitle, difficulty, sex, clipRate1, clipRate2, descriptionView, titleLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
