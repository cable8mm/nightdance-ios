//
//  SCManager.m
//  NightdanceI
//
//  Created by cable8mm on 2014. 1. 13..
//  Copyright (c) 2014년 Lee Samgu. All rights reserved.
//

#import "SCManager.h"
#include "../Global.h"
#import "SAManager.h"

@implementation SCManager

+(NSString*)getAuthUrl:(NSString*)filename param:(NSString*)pStr {
    NSString *urlString   = [[NSString alloc] initWithFormat:@"%@%@%@%@%@%@", API_ROOT_URL, filename, @"?token=", [SAManager getAccessToken], @"&", pStr];
    return urlString;
}

+(NSDictionary *)getUserInfo:(NSString *)username password:(NSString *)password {
    NSDictionary *userInfo;
//    NSString *urlString   = [[NSString alloc] initWithFormat:@"%@%@%@%@%@", API_ROOT_URL, @"login_as_nightdance.php?username=", username, @"&password=", password];
    NSString *urlString   = [SCManager getAuthUrl:@"login_as_nightdance.php" param:[NSString stringWithFormat:@"%@%@%@%@", @"username=", username, @"&password=", password]];
    NSLog(@"clipUrlString = %@", urlString);
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSData *data    = [[NSData alloc] initWithContentsOfURL:url];
    
    if (data == nil) {
        UIAlertView *alert =  [[UIAlertView alloc] initWithTitle:@"네트워크 에러"
                                                         message:@"네트워크가 원활하지 않습니다."
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];;
        [alert show];
        return nil;
    }
    
    NSError *error;
    userInfo  = [NSJSONSerialization
              JSONObjectWithData:data
              options:NSJSONReadingAllowFragments
              error:&error][@"response"][@"user"];
    
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    } else {
        NSLog(@"Success Parsing %@", userInfo);
    }
    
    return userInfo;
}

+(NSString*)getAccessToken {
    NSString *token;
    NSString *appKey = [SAManager getAppKey];
    NSString *urlString   = [[NSString alloc] initWithFormat:@"%@%@%@%@%@%@%@", API_ROOT_URL, @"get_access_token.php?consumer_key=", API_CONSUMER_KEY, @"&signature=", API_SIGNATURE, @"&app_key=", appKey];
    NSLog(@"clipUrlString = %@", urlString);
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSData *data    = [[NSData alloc] initWithContentsOfURL:url];

    if (data == nil) {
        UIAlertView *alert =  [[UIAlertView alloc] initWithTitle:@"네트워크 에러"
                                                         message:@"네트워크가 원활하지 않습니다."
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];;
        [alert show];
        return nil;
    }

    NSError *error;
    token  = [NSJSONSerialization
                 JSONObjectWithData:data
                 options:NSJSONReadingAllowFragments
                 error:&error][@"response"][@"token"];

    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    } else {
        NSLog(@"Success Parsing %@", token);
    }

    return token;
}

+(NSArray *)getComments:(int)clipId {
    NSArray *comments  = nil;
    NSString *clipUrlString   = [[NSString alloc] initWithFormat:@"%@%@%@%@%d", API_ROOT_URL, @"get_comments.php?token=", TOKEN, @"&id=", clipId];
    NSLog(@"clipUrlString = %@", clipUrlString);
    NSURL *clipUrl = [[NSURL alloc] initWithString:clipUrlString];
    NSData *clipData    = [[NSData alloc] initWithContentsOfURL:clipUrl];
    if (clipData == nil) {
        comments = nil;
        
        UIAlertView *alert =  [[UIAlertView alloc] initWithTitle:@"네트워크 에러"
                                                         message:@"네트워크가 원활하지 않습니다."
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];;
        [alert show];
        return nil;
    }
    NSError *error;
    comments  = [NSJSONSerialization
              JSONObjectWithData:clipData
              options:NSJSONReadingAllowFragments
              error:&error][@"response"][@"comments"];
    
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    } else {
        NSLog(@"Success Parsing %@", comments);
    }
    return comments;
}

+(NSArray *)getSearchClips:(NSString *)word {
    NSArray *clips  = nil;
    NSString *queryWord = [word stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *clipUrlString   = [[NSString alloc] initWithFormat:@"%@%@%@%@%@", API_ROOT_URL, @"search_clips.php?token=", TOKEN, @"&word=", queryWord];
    NSLog(@"clipUrlString = %@", clipUrlString);
    NSURL *clipUrl = [[NSURL alloc] initWithString:clipUrlString];
    NSData *clipData    = [[NSData alloc] initWithContentsOfURL:clipUrl];
    if (clipData == nil) {
        clips = nil;
        
        UIAlertView *alert =  [[UIAlertView alloc] initWithTitle:@"네트워크 에러"
                                                         message:@"네트워크가 원활하지 않습니다."
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];;
        [alert show];
        return nil;
    }
    NSError *error;
    clips  = [NSJSONSerialization
              JSONObjectWithData:clipData
              options:NSJSONReadingAllowFragments
              error:&error][@"response"][@"clips"];
    
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    } else {
        NSLog(@"Success Parsing %@", clips);
    }
    return clips;
}

+(NSDictionary *)getClip:(int)key {
    NSDictionary *clip  = nil;
    NSString *clipUrlString   = [[NSString alloc] initWithFormat:@"%@%@%@%@%d", API_ROOT_URL, @"get_clip.php?token=", TOKEN, @"&id=", key];
    NSLog(@"clipUrlString = %@", clipUrlString);
    NSURL *clipUrl = [[NSURL alloc] initWithString:clipUrlString];
    NSData *clipData    = [[NSData alloc] initWithContentsOfURL:clipUrl];
    if (clipData == nil) {
        clip = nil;
        
        UIAlertView *alert =  [[UIAlertView alloc] initWithTitle:@"네트워크 에러"
                                                         message:@"네트워크가 원활하지 않습니다."
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];;
        [alert show];
        return nil;
    }
    NSError *error;
    clip  = [NSJSONSerialization
              JSONObjectWithData:clipData
              options:NSJSONReadingAllowFragments
              error:&error][@"response"][@"clip"];
    
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    } else {
        NSLog(@"Success Parsing %@", clip);
    }
    return clip;
}

+(NSArray *)getClips {
    NSArray *clips  = [self getClips:0];
    return clips;
}

+(NSArray*)getRelatedClips:(int)clipId {
    NSArray *clips  = nil;
    NSString *clipUrlString   = [[NSString alloc] initWithFormat:@"%@%@%@%@%d", API_ROOT_URL, @"get_clip.php?token=", TOKEN, @"&id=", clipId];
    NSLog(@"clipUrlString = %@", clipUrlString);
    NSURL *clipUrl = [[NSURL alloc] initWithString:clipUrlString];
    NSData *clipData    = [[NSData alloc] initWithContentsOfURL:clipUrl];
    if (clipData == nil) {
        clips = nil;
        
        UIAlertView *alert =  [[UIAlertView alloc] initWithTitle:@"네트워크 에러"
                                                         message:@"네트워크가 원활하지 않습니다."
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];;
        [alert show];
        return nil;
    }
    NSError *error;
    clips  = [NSJSONSerialization
             JSONObjectWithData:clipData
             options:NSJSONReadingAllowFragments
             error:&error][@"response"][@"clips"];
    
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    } else {
        NSLog(@"Success Parsing %@", clips);
    }
    return clips;
}

+(NSArray *)getClips:(int)rowCount {
    NSArray *clips  = nil;
    NSString *clipUrlString   = [[NSString alloc] initWithFormat:@"%@%@%@%@%d", API_ROOT_URL, @"get_clips.php?token=", TOKEN, @"&row_count=", rowCount];
    NSLog(@"clipUrlString = %@", clipUrlString);
    NSURL *clipUrl = [[NSURL alloc] initWithString:clipUrlString];
    NSData *clipData    = [[NSData alloc] initWithContentsOfURL:clipUrl];
    if (clipData == nil) {
        clips = nil;
        
        UIAlertView *alert =  [[UIAlertView alloc] initWithTitle:@"네트워크 에러"
                                                         message:@"네트워크가 원활하지 않습니다."
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];;
        [alert show];
        return nil;
    }
    NSError *error;
    clips  = [NSJSONSerialization
              JSONObjectWithData:clipData
              options:NSJSONReadingAllowFragments
              error:&error][@"response"][@"clips"];
    
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    } else {
        NSLog(@"Success Parsing %@", clips);
    }
    return clips;
}

+(NSArray*)getPackages {
    NSArray *packages  = nil;
    NSString *clipUrlString   = [[NSString alloc] initWithFormat:@"%@%@%@", API_ROOT_URL, @"get_packages.php?token=", TOKEN];
    NSLog(@"clipUrlString = %@", clipUrlString);
    NSURL *clipUrl = [[NSURL alloc] initWithString:clipUrlString];
    NSData *clipData    = [[NSData alloc] initWithContentsOfURL:clipUrl];
    if (clipData == nil) {
        packages = nil;
        
        UIAlertView *alert =  [[UIAlertView alloc] initWithTitle:@"네트워크 에러"
                                                         message:@"네트워크가 원활하지 않습니다."
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];;
        [alert show];
        return nil;
    }
    NSError *error;
    packages  = [NSJSONSerialization
              JSONObjectWithData:clipData
              options:NSJSONReadingAllowFragments
              error:&error][@"reponse"][@"packages"];
    
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    } else {
        NSLog(@"Success Parsing %@", packages);
    }
    return packages;
}
+(NSDictionary*)getPackage:(int)packId {
    NSDictionary *pack;
    NSString *packUrlString   = [[NSString alloc] initWithFormat:@"%@%@%d%@%@", API_ROOT_URL, @"get_package.php?id=", packId, @"&token=", TOKEN];
    NSURL *packUrl = [[NSURL alloc] initWithString:packUrlString];
    NSData *packData    = [[NSData alloc] initWithContentsOfURL:packUrl];
    if (packData == nil) {
        pack = nil;
        
        UIAlertView *alert =  [[UIAlertView alloc] initWithTitle:@"네트워크 에러"
                                                         message:@"네트워크가 원활하지 않습니다."
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];;
        [alert show];
        return nil;
    }
    NSError *error;
    pack  = [NSJSONSerialization
                 JSONObjectWithData:packData
                 options:NSJSONReadingAllowFragments
                 error:&error][@"response"][@"package"];
    
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    } else {
        NSLog(@"Success Parsing %@", pack);
    }
    return pack;
}
@end
