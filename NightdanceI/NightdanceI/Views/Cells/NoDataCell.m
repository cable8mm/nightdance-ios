//
//  NoDataCell.m
//  NightdanceI
//
//  Created by cable8mm on 2014. 1. 18..
//  Copyright (c) 2014년 Lee Samgu. All rights reserved.
//

#import "NoDataCell.h"

@implementation NoDataCell

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
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end
