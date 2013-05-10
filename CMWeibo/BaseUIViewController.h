//
//  BaseUIViewController.h
//  CMWeibo
//
//  Created by Cameron on 13-3-21.
//  Copyright (c) 2013年 cm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SinaWeibo.h"

#define RECEVIE_WEIBO_DATA @"weiboData"
#define RECEVIE_USER_DATA @"userData"
#define RECEVIE_COMMENT_DATA @"commentData"
#define RECEVIE_FOLLOWER_DATA @"followerData"
#define RECEVIE_FOLLOWING_DATA @"followingData"
#define RECEVIE_UPDATE_WEIBO_RESULT @"updateWeiboResult"

@interface BaseUIViewController : UIViewController

- (SinaWeibo *)sinaweibo;

@end
