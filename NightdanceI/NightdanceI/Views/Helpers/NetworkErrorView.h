//
//  NetworkErrorView.h
//  NightdanceI
//
//  Created by cable8mm on 2014. 2. 21..
//  Copyright (c) 2014년 Lee Samgu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NetworkErrorViewDelegate
- (void)networkRefresh;
@end

@interface NetworkErrorView : UIView
@property(nonatomic, retain) id<NetworkErrorViewDelegate> delegate;
- (IBAction)refresh:(id)sender;
@end
