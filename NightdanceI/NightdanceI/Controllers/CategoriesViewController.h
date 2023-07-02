//
//  CategoriesViewController.h
//  NightdanceI
//
//  Created by cable8mm on 2014. 1. 10..
//  Copyright (c) 2014년 Lee Samgu. All rights reserved.
//

@protocol BackDataDelegate
- (void)recieveData:(NSArray *)theData;
@end

#import <UIKit/UIKit.h>

@interface CategoriesViewController : UITableViewController <UIAlertViewDelegate> {
    int checkedCategoryId;
}

@property (nonatomic) int checkedCategoryId;
@property (nonatomic) id<BackDataDelegate> delegate;
-(void)setCheckedCategoryId:(int)categoryId;
@end
