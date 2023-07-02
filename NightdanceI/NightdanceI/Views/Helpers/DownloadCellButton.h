//
//  DownloadCellButton.h
//  NightdanceI
//
//  Created by cable8mm on 2014. 2. 19..
//  Copyright (c) 2014년 Lee Samgu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DownloadCellButton : UIButton
@property (nonatomic) BOOL isFreezing;
- (void)timeout;
@end
