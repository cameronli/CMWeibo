//
//  UserInfoViewController.h
//  CMWeibo
//
//  Created by Cameron on 13-4-29.
//  Copyright (c) 2013年 cm. All rights reserved.
//

#import "BaseUIViewController.h"
#import "PullTableView.h"
#import "UserWeiboTableViewCell.h"

@interface UserInfoViewController : BaseUIViewController<SinaWeiboRequestDelegate,UITableViewDataSource, UITableViewDelegate, PullTableViewDelegate, UserWeiboTableViewCellDelegate>


@property (retain, nonatomic) IBOutlet PullTableView *userWeiboListTableView;
@property (retain, nonatomic) IBOutlet UIView *headView;

#pragma mark - headView property
@property (retain, nonatomic) IBOutlet UIImageView *userImage;
@property (retain, nonatomic) IBOutlet UILabel *userNickName;
@property (retain, nonatomic) IBOutlet UILabel *userTotalWeiboCount;
@property (retain, nonatomic) IBOutlet UIButton *followingCountButton;
@property (retain, nonatomic) IBOutlet UIButton *followerCountButton;

#pragma mark - data
@property (retain, nonatomic) NSDictionary *userInfo;
@property (retain, nonatomic) NSMutableArray *userWeiboList;


- (id)initWithUserInfo:(NSDictionary *)userInfo;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil userInfo:(NSDictionary *)userInfo;

- (IBAction)getFollowingUser:(id)sender;
- (IBAction)getFollowerUser:(id)sender;


@end
