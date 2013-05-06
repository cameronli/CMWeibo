//
//  FollowUserViewController.m
//  CMWeibo
//
//  Created by Cameron on 13-5-5.
//  Copyright (c) 2013年 cm. All rights reserved.
//

#import "FollowUserViewController.h"
#import "UIImageView+WebCache.h"

@interface FollowUserViewController ()

@end

@implementation FollowUserViewController

- (id)initWithUserInfo:(NSDictionary *)userInfo type:(NSString *)type
{
    self = [super initWithNibName:@"FollowUserViewController" bundle:nil];
    if (self) {
        self.followType = type;
        self.userInfo = userInfo;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.followList = [[NSMutableArray alloc] init];
    
//    self.tableView = [[[PullTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain] autorelease];
//    self.tableView.dataSource = self;
//    self.tableView.delegate = self;
    
//    [self.view addSubview:self.tableView];
    
	[self loadFollowDataByUserId:[NSString stringWithFormat:@"%@",[self.userInfo objectForKey:@"id"]]];
}

#pragma mark -
#pragma mark load data
- (void)loadFollowDataByUserId:(NSString *)id
{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObject:id forKey:@"uid"];
    [param setObject:@"0" forKey:@"trim_status"];
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
    NSDictionary *followUserDic = (NSDictionary *)[result retain];
    if (self.followList == nil) {
        self.followList = [[NSMutableArray alloc] init];
        [self.followList addObjectsFromArray:[followUserDic objectForKey:@"users"]];
        [self refreshTable];
    } else {
        [self.followList removeLastObject];
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
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell.imageView setImageWithURL:[userInfo objectForKey:@"profile_image_url"] placeholderImage:[UIImage imageNamed:@"placeholder"] options:SDWebImageRefreshCached];
    cell.textLabel.text = [userInfo objectForKey:@"screen_name"];
    cell.detailTextLabel.text = @"@@@";//[userInfo objectForKey:@"aaaa"];
    
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return [tableView cellForRowAtIndexPath:indexPath].frame.size.height;
//}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//}

#pragma mark - 
#pragma mark PullTableViewDelegate
- (void)pullTableViewDidTriggerRefresh:(PullTableView*)pullTableView
{
    
}
- (void)pullTableViewDidTriggerLoadMore:(PullTableView*)pullTableView
{
    
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
