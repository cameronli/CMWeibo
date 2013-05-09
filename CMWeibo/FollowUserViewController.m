//
//  FollowUserViewController.m
//  CMWeibo
//
//  Created by Cameron on 13-5-5.
//  Copyright (c) 2013年 cm. All rights reserved.
//

#import "FollowUserViewController.h"
#import "UIImageView+WebCache.h"
#import "FollowUserTableCell.h"
#import "UserInfoViewController.h"

@interface FollowUserViewController ()

@end

@implementation FollowUserViewController

- (id)initWithUserInfo:(NSDictionary *)userInfo type:(NSString *)type
{
    self = [super initWithNibName:@"FollowUserViewController" bundle:nil];
    if (self) {
        self.followType = type;
        self.userInfo = userInfo;
        if ([type isEqual:FOLLOWER_TYPE]) {
            self.title = @"粉丝列表";
        }
        if ([type isEqual:FOLLOWING_TYPE]) {
            self.title = @"关注列表";
        }
        self.page = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.followList = [[NSMutableArray alloc] init];
    
	[self loadFollowDataByUserId:[NSString stringWithFormat:@"%@",[self.userInfo objectForKey:@"id"]]];
}

#pragma mark -
#pragma mark load data
- (void)loadFollowDataByUserId:(NSString *)id
{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObject:id forKey:@"uid"];
    [param setObject:@"0" forKey:@"trim_status"];
    [param setObject:[NSString stringWithFormat:@"%d",self.page] forKey:@"cursor"];
    if ([self.followType isEqual: FOLLOWER_TYPE]) {
        [self.sinaweibo requestWithURL:@"friendships/followers.json" params:param httpMethod:@"GET" delegate:self];
    }
    if ([self.followType isEqual:FOLLOWING_TYPE]) {
        [self.sinaweibo requestWithURL:@"friendships/friends.json" params:param httpMethod:@"GET" delegate:self];
    }
}

#pragma mark - SinaWeiboRequest Delegate
//网络加载失败
- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"网络加载失败");
    self.tableView.pullTableIsLoadingMore = NO;
    self.tableView.pullTableIsRefreshing = NO;
}

//网络加载完成
- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    self.page += 50;
    NSDictionary *followUserDic = (NSDictionary *)[result retain];
    if (self.followList == nil) {
        self.followList = [[NSMutableArray alloc] init];
        [self.followList addObjectsFromArray:[followUserDic objectForKey:@"users"]];
        [self refreshTable];
    } else {
//        [self.followList removeLastObject];
        [self.followList addObjectsFromArray:[followUserDic objectForKey:@"users"]];
        [self loadMoreDataToTable];
    }
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.followList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *userInfo = [self.followList objectAtIndex:indexPath.row];
    static NSString *CellIdentifier = @"Cell";
    FollowUserTableCell *cell = (FollowUserTableCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[FollowUserTableCell alloc] initWithUserInfo:userInfo style:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    } else {
        cell.userInfo = userInfo;
    }
    
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserInfoViewController *userInfoViewController = [[[UserInfoViewController alloc] initWithUserInfo:[self.followList objectAtIndex:indexPath.row]] autorelease];
    [self.navigationController pushViewController:userInfoViewController animated:YES];
}

#pragma mark - 
#pragma mark PullTableViewDelegate
- (void)pullTableViewDidTriggerRefresh:(PullTableView*)pullTableView
{
    self.followList = nil;
    self.page = 0;
    [self loadFollowDataByUserId:[NSString stringWithFormat:@"%@",[self.userInfo objectForKey:@"id"]]];
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView*)pullTableView
{
    [self loadFollowDataByUserId:[NSString stringWithFormat:@"%@",[self.userInfo objectForKey:@"id"]]];
}

#pragma mark - Refresh and load more methods

- (void) refreshTable
{
    /*
     
     Code to actually refresh goes here.
     
     */
    self.tableView.pullLastRefreshDate = [NSDate date];
    self.tableView.pullTableIsRefreshing = NO;
}

- (void) loadMoreDataToTable
{
    /*
     
     Code to actually load more data goes here.
     
     */
    self.tableView.pullTableIsLoadingMore = NO;
}

#pragma mark - 
#pragma mark memory control
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_tableView release];
    [super dealloc];
}
@end
