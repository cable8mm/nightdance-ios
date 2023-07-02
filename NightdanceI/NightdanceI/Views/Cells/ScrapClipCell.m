//
//  ScrapClipCell.m
//  NightdanceI
//
//  Created by cable8mm on 2014. 1. 23..
//  Copyright (c) 2014년 Lee Samgu. All rights reserved.
//

#import "ScrapClipCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation ScrapClipCell

@synthesize song;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
//        self.song.autoresizingMask  = UIViewAutoresizingFlexibleWidth;
//        self.song.lineBreakMode = NSLineBreakByWordWrapping;
//        self.song.adjustsFontSizeToFitWidth   = NO;
//        self.song.numberOfLines   = 0;
//        [self.song sizeToFit];
    }
    return self;
}

-(void) setSong:(UILabel *)s {
    song = s;
    self.song.autoresizingMask  = UIViewAutoresizingFlexibleWidth;
    self.song.lineBreakMode = NSLineBreakByWordWrapping;
    self.song.adjustsFontSizeToFitWidth   = NO;
    self.song.numberOfLines   = 0;
    [self.song sizeToFit];
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

@end
