//
//  Global.h
//  NightdanceI
//
//  Created by cable8mm on 2013. 12. 15..
//  Copyright (c) 2013년 Lee Samgu. All rights reserved.
//

#ifndef NightdanceI_Global_h
#define NightdanceI_Global_h

#define API_ROOT_URL  @"http://m.nightdance.co.kr/api/"
#define IMAGE_SERVER_PREFIX  @"http://mail.nightdance.co.kr/img/lecture/"
#define TOKEN @"ANT52ad59921eed0"
// Shared Secret = c3474a7e82384f9f8dc45136eea5d528
#define API_CONSUMER_KEY @"iphone"
#define API_SIGNATURE   @"dkdlvhs239"
typedef NS_ENUM(NSUInteger, DownloadStatus) {
    DownloadStatusReady     = 0,
    DownloadStatusReceived  = 1,
    DownloadStatusComplete  = 2
};
#endif
