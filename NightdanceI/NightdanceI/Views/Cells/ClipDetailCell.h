//
//  ClipDetailCell.h
//  NightdanceI
//
//  Created by cable8mm on 2014. 1. 9..
//  Copyright (c) 2014년 Lee Samgu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StarsView.h"

@interface ClipDetailCell : UITableViewCell
@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) IBOutlet UILabel *song;
@property (nonatomic, retain) IBOutlet UILabel *artist;
@property (nonatomic, weak) IBOutlet UILabel *genreTitle;  // 장르
@property (nonatomic, weak) IBOutlet UILabel *difficulty;   // 난이도
@property (nonatomic, weak) IBOutlet UILabel *sex;          // 적합 성별
@property (nonatomic, weak) IBOutlet StarsView *clipRate1;    // 작품성
@property (nonatomic, weak) IBOutlet StarsView *clipRate2;    // 실용성
@property (nonatomic, weak) IBOutlet UITextView *descriptionView;    // 강의 내용
@end
