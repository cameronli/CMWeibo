//
//  FollowUserViewController.h
//  CMWeibo
//
//  Created by Cameron on 13-5-5.
//  Copyright (c) 2013年 cm. All rights reserved.
//

#import "BaseUIViewController.h"
#import "PullTableView.h"

#define FOLLOWER_TYPE @"followerType"
#define FOLLOWING_TYPE @"followingType"

@interface FollowUserViewController : BaseUIViewController<SinaWeiboRequestDelegate,UITableViewDataSource, UITableViewDelegate, PullTableViewDelegate>

@property (nonatomic, retain)NSDictionary *userInfo;
@property (nonatomic, retain)NSMutableArray *followList;
@property (nonatomic, retain)NSString *followType;
@property (nonatomic)int page;

@property (retain, nonatomic) IBOutlet PullTableView *tableView;


- (id)initWithUserInfo:(NSDictionary *)userInfo type:(NSString *)type;

@end
