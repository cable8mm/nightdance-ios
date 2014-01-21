//
//  ClipCell.h
//  NightdanceI
//
//  Created by cable8mm on 2014. 1. 10..
//  Copyright (c) 2014년 Lee Samgu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StarsView.h"
//@class StarsView;

@interface ClipCell : UITableViewCell
@property (nonatomic, retain) IBOutlet UIImageView *thumbnail;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *dancer;
@property (nonatomic, weak) IBOutlet UILabel *star1;
@property (nonatomic, weak) IBOutlet UILabel *star2;
@property (nonatomic, retain) IBOutlet StarsView *starsView1;
@property (nonatomic, retain) IBOutlet StarsView *starsView2;
@end
