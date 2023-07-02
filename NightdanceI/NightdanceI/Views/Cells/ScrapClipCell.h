//
//  ScrapClipCell.h
//  NightdanceI
//
//  Created by cable8mm on 2014. 1. 23..
//  Copyright (c) 2014년 Lee Samgu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScrapClipCell : UITableViewCell
@property (nonatomic, retain) IBOutlet UIImageView *thumbnail;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *dancer;
@property (nonatomic, weak) IBOutlet UILabel *song;
@property (nonatomic, retain) IBOutlet UILabel *scrapedLabel;
@end
