//
//  BuyNcashCell.h
//  NightdanceI
//
//  Created by cable8mm on 2014. 1. 21..
//  Copyright (c) 2014년 Lee Samgu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BuyNcashCell : UITableViewCell {
    UIButton *buyButton;
}

@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) IBOutlet UIButton *buyButton;
@property (nonatomic, retain) IBOutlet UILabel *descriptionLabel;

@end
