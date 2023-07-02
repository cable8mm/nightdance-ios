//
//  TicketCell.h
//  NightdanceI
//
//  Created by cable8mm on 2014. 2. 2..
//  Copyright (c) 2014년 Lee Samgu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TicketCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UIImageView *ivTicketThumbnail;
@property (nonatomic, weak) IBOutlet UILabel *lbTicketName;
@property (nonatomic, weak) IBOutlet UILabel *lbTicketPrice;
@property (nonatomic, weak) IBOutlet UILabel *lbTicketTerm;
@end
