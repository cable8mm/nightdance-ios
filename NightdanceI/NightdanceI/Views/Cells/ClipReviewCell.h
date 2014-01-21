//
//  ClipReviewCell.h
//  NightdanceI
//
//  Created by cable8mm on 2014. 1. 9..
//  Copyright (c) 2014년 Lee Samgu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClipReviewCell : UITableViewCell
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *nickname;
@property (nonatomic, weak) IBOutlet UILabel *created;
@property (nonatomic, weak) IBOutlet UITextView *descriptionView;

@end
