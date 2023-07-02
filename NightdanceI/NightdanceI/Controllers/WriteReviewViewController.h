//
//  WriteReviewViewController.h
//  NightdanceI
//
//  Created by cable8mm on 2014. 2. 17..
//  Copyright (c) 2014년 Lee Samgu. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CommentDataDelegate
- (void)addComment:(NSString *)comment;
@end

@interface WriteReviewViewController : UIViewController <UITextViewDelegate>
@property (strong, nonatomic) NSNumber *clipId;
@property (nonatomic) id<CommentDataDelegate> delegate;
@end
