//
//  UserInfoViewController.m
//  CMWeibo
//
//  Created by Cameron on 13-4-29.
//  Copyright (c) 2013年 cm. All rights reserved.
//

#import "UserInfoViewController.h"
#import "UIImageView+WebCache.h"
#import "ImageShowViewController.h"
#import "AppDelegate.h"
#import "FollowUserViewController.h"

@interface UserInfoViewController ()

@end

static NSString *recevieDataType;

@implementation UserInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}


- (id)initWithUserInfo:(NSDictionary *)userInfo
{
    _userInfo = [userInfo retain];
    self = [super init];
    if (self) {
        [self setUserHeadView];
        [self.userWeiboListTableView setTableHeaderView:self.headView];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil userInfo:(NSDictionary *)userInfo
{
    _userInfo = [userInfo retain];
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"个人主页";
    }
    return self;
}




- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setUserHeadView];
    [self.userWeiboListTableView setTableHeaderView:self.headView];
    
    [self loadWeiboData];
}


- (void)setUserHeadView
{
    [self.userImage setImageWithURL:[self.userInfo objectForKey:@"avatar_large"] placeholderImage:[UIImage imageNamed:@"placeholder"] options:SDWebImageRefreshCached];
    [self.userNickName setText:[self.userInfo objectForKey:@"screen_name"]];
    [self.userTotalWeiboCount setText:[NSString stringWithFormat:@"%@",[self.userInfo objectForKey:@"statuses_count"]]];
    [self.followingCountButton setTitle:[NSString stringWithFormat:@"%@",[self.userInfo objectForKey:@"friends_count"]] forState:UIControlStateNormal];
    [self.followerCountButton setTitle:[NSString stringWithFormat:@"%@",[self.userInfo objectForKey:@"followers_count"]] forState:UIControlStateNormal];
}

- (IBAction)getFollowingUser:(id)sender {
//    [self loadFollowingByUserId:[NSString stringWithFormat:@"%@",[self.userInfo objectForKey:@"id"]]];
    FollowUserViewController *followView = [[[FollowUserViewController alloc] initWithUserInfo:self.userInfo type:FOLLOWING_TYPE] autorelease];
    [self.navigationController pushViewController:followView animated:YES];
}

- (IBAction)getFollowerUser:(id)sender {
    [self loadFollowerByUserId:[NSString stringWithFormat:@"%@",[self.userInfo objectForKey:@"id"]]];
}


#pragma mark - load data
- (void)loadWeiboData
{
    recevieDataType = RECEVIE_WEIBO_DATA;
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObject:@"20" forKey:@"count"];
    [param setValue:[NSString stringWithFormat:@"%@",[self.userInfo objectForKey:@"screen_name"]] forKey:@"screen_name"];
    if (self.userWeiboList != nil) {
        NSDictionary *lastWeibo = [self.userWeiboList lastObject];
        NSString *lastWeiboId = [NSString stringWithFormat:@"%@",[lastWeibo objectForKey:@"id"]];
        [param setValue:lastWeiboId forKey:@"max_id"];
    }
    NSLog(@"%@",param);
    [self.sinaweibo requestWithURL:@"statuses/user_timeline.json" params:param httpMethod:@"GET" delegate:self];
}

- (void)loadUserInfoDataWithUserNickName:(NSString *)userNickName
{
    recevieDataType = RECEVIE_USER_DATA;
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObject:userNickName forKey:@"screen_name"];
    [self.sinaweibo requestWithURL:@"users/show.json" params:param httpMethod:@"GET" delegate:self];
}

//获取关注用户信息
- (void)loadFollowingByUserId:(NSString *)id
{
    recevieDataType = RECEVIE_FOLLOWING_DATA;
}

//获取粉丝信息
- (void)loadFollowerByUserId:(NSString *)id
{
    recevieDataType = RECEVIE_FOLLOWER_DATA;
}

#pragma mark - SinaWeiboRequestDelegate
- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"%@",error);
    NSLog(@"网络加载失败");
    self.userWeiboListTableView.pullTableIsLoadingMore = NO;
    self.userWeiboListTableView.pullTableIsRefreshing = NO;
}

- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    if ([recevieDataType isEqualToString:RECEVIE_WEIBO_DATA]) {
        NSDictionary *weiboDic = (NSDictionary *)[result retain];
        if (self.userWeiboList == nil) {
            self.userWeiboList = [[NSMutableArray alloc] init];
            [self.userWeiboList addObjectsFromArray:[weiboDic objectForKey:@"statuses"]];
            [self refreshTable];
        } else {
            [self.userWeiboList removeLastObject];
            [self.userWeiboList addObjectsFromArray:[weiboDic objectForKey:@"statuses"]];
            [self loadMoreDataToTable];
        }
        [self.userWeiboListTableView reloadData];
    }
    if ([recevieDataType isEqualToString:RECEVIE_USER_DATA]) {
        NSLog(@"%@",result);
        NSDictionary *userInfo = (NSDictionary *)[result retain];
        //        UserInfoViewController *userInfoViewController = [[UserInfoViewController alloc] initWithUserInfo:userInfo];
        UserInfoViewController *userInfoViewController = [[UserInfoViewController alloc] initWithNibName:@"UserInfoViewController" bundle:nil userInfo:userInfo];
        [self.navigationController pushViewController:userInfoViewController animated:YES];
    }
    if ([recevieDataType isEqualToString:RECEVIE_COMMENT_DATA]) {
        
    }
}

#pragma mark - memory Control

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_headView release];
    [_userWeiboListTableView release];
    [_userImage release];
    [_userNickName release];
    [_userTotalWeiboCount release];
    [_followingCountButton release];
    [_followerCountButton release];
    [super dealloc];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.userWeiboList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //该微博内容
    NSDictionary *weiboContent = [self.userWeiboList objectAtIndex:indexPath.row];
    
    static NSString *CellIdentifier = @"Cell";
    UserWeiboTableViewCell *cell = (UserWeiboTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UserWeiboTableViewCell alloc] initWithWeiboData:weiboContent style:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        //选择显示风格
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.delegate = self;
    } else {
        cell.weiboContent = weiboContent;
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

#pragma mark - UserWeiboTableViewCellDelegate
- (void)imageShowByUrl:(NSString *)imageUrl
{
    ImageShowViewController *imageShowVC = [[[ImageShowViewController alloc] initWithImageUrl:imageUrl] autorelease];
    imageShowVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:imageShowVC animated:YES];
    //    [imageShowVC release];
    AppDelegate *mainDelegate = [[UIApplication sharedApplication] delegate];
    [mainDelegate.main hideTabBar:CustomShowOrHideTabBarFromLeft];
    NSLog(@"%@",imageUrl);
}

- (void)userInfoShow:(NSString *)userNickname
{
    [self loadUserInfoDataWithUserNickName:[userNickname stringByReplacingOccurrencesOfString:@"@" withString:@""]];
}

- (void)topicShowByTopicContent:(NSString *)topicName
{
    NSLog(@"%@",topicName);
}

- (void)openWebPageByUrl:(NSString *)url
{
    NSLog(@"%@",url);
}


#pragma mark - PullTableViewDelegate
- (void)pullTableViewDidTriggerRefresh:(PullTableView*)pullTableView
{
    self.userWeiboList = nil;
    [self loadWeiboData];
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView*)pullTableView
{
    [self loadWeiboData];
}

#pragma mark - Refresh and load more methods

- (void) refreshTable
{
    /*
     
     Code to actually refresh goes here.
     
     */
    self.userWeiboListTableView.pullLastRefreshDate = [NSDate date];
    self.userWeiboListTableView.pullTableIsRefreshing = NO;
}

- (void) loadMoreDataToTable
{
    /*
     
     Code to actually load more data goes here.
     
     */
    self.userWeiboListTableView.pullTableIsLoadingMore = NO;
}

@end
