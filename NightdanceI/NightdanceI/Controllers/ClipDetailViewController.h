//
//  ClipDetailViewController.h
//  NightdanceI
//
//  Created by cable8mm on 2013. 12. 15..
//  Copyright (c) 2013년 Lee Samgu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WriteReviewViewController.h"

@class ClipPlayerViewController;

@interface ClipDetailViewController : UITableViewController <UIWebViewDelegate, UIAlertViewDelegate, CommentDataDelegate> {
    UIImageView *thumbnail;
    NSNumber *clipId;
    ClipPlayerViewController *_moviePlayer;
}
@property (strong, nonatomic) NSNumber *clipId;

- (BOOL)shouldAutorotate;
- (NSUInteger)supportedInterfaceOrientations;
@end

NSString *GetSexString(int i);