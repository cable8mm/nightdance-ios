//
//  ClipsPacksViewController.h
//  NightdanceI
//
//  Created by cable8mm on 2014. 1. 13..
//  Copyright (c) 2014년 Lee Samgu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoriesViewController.h"

@interface ClipsPacksViewController : UITableViewController <BackDataDelegate> {
    int selectedCategoryId;
}
@property (nonatomic) int selectedCategoryId;

@end
