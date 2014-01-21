//
//  ClipDetailViewController.h
//  NightdanceI
//
//  Created by cable8mm on 2013. 12. 15..
//  Copyright (c) 2013년 Lee Samgu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>

@class ClipPlayerViewController;

@interface ClipDetailViewController : UITableViewController <UIWebViewDelegate, SKProductsRequestDelegate> {
    UIImageView *thumbnail;
    NSNumber *clipId;
    ClipPlayerViewController *_moviePlayer;
    
    SKProduct *proUpgradeProduct;
    SKProductsRequest *productsRequest;
}
@property (strong, nonatomic) NSNumber *clipId;

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;
- (BOOL)shouldAutorotate;
- (NSUInteger)supportedInterfaceOrientations;
- (void)requestProUpgradeProductData;

@end

NSString *GetSexString(int i);