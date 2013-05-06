//
//  WeiboDetailViewController.m
//  CMWeibo
//
//  Created by Cameron on 13-5-4.
//  Copyright (c) 2013年 cm. All rights reserved.
//

#import "WeiboDetailViewController.h"
#import "UserInfoViewController.h"
#import "ImageShowViewController.h"
#import "AppDelegate.h"

@interface WeiboDetailViewController ()

@end

static NSString *recevieDataType;

@implementation WeiboDetailViewController


- (id)initWithWeiboContent:(NSDictionary *)weiboContent nibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"微博正文";
        self.weiboContent = weiboContent;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    WeiboTableViewCell *headView = [[WeiboTableViewCell alloc] initWithWeiboData:self.weiboContent style:UITableViewCellStyleDefault reuseIdentifier:nil];
    headView.delegate = self;
    
    [self.weiboCommentTableView setTableHeaderView:headView];
    [self loadWeiboCommentWithWeiboId:[NSString stringWithFormat:@"%@",[self.weiboContent objectForKey:@"id"]]];
}

#pragma mark - load data

- (void)loadUserInfoDataWithUserNickName:(NSString *)userNickName
{
    recevieDataType = RECEVIE_USER_DATA;
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObject:userNickName forKey:@"screen_name"];
    [self.sinaweibo requestWithURL:@"users/show.json" params:param httpMethod:@"GET" delegate:self];
}

- (void)loadWeiboCommentWithWeiboId:(NSString *)id
{
    recevieDataType = RECEVIE_COMMENT_DATA;
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObject:id forKey:@"id"];
    if (self.weiboCommentList != nil) {
        NSDictionary *lastComment = [self.weiboCommentList lastObject];
        [param setObject:[NSString stringWithFormat:@"%@",[lastComment objectForKey:@"id"]] forKey:@"max_id"];
    }
    [self.sinaweibo requestWithURL:@"comments/show.json" params:param httpMethod:@"GET" delegate:self];
}



#pragma mark - SinaWeiboRequest Delegate
//网络加载失败
- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"网络加载失败");
    self.weiboCommentTableView.pullTableIsLoadingMore = NO;
    self.weiboCommentTableView.pullTableIsRefreshing = NO;
}

//网络加载完成
- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    if ([recevieDataType isEqualToString:RECEVIE_WEIBO_DATA]) {
        
    }
    if ([recevieDataType isEqualToString:RECEVIE_USER_DATA]) {
        NSDictionary *userInfo = (NSDictionary *)[result retain];
        UserInfoViewController *userInfoViewController = [[[UserInfoViewController alloc] initWithNibName:@"UserInfoViewController" bundle:nil userInfo:userInfo] autorelease];
        [self.navigationController pushViewController:userInfoViewController animated:YES];
    }
    if ([recevieDataType isEqualToString:RECEVIE_COMMENT_DATA]) {
        NSDictionary *commentListresult = (NSDictionary *)result;
        NSArray *commentList = [commentListresult objectForKey:@"comments"];
        if (self.weiboCommentList == nil) {
            self.weiboCommentList = [[NSMutableArray alloc] init];
            [self.weiboCommentList addObjectsFromArray:commentList];
            [self refreshTable];
        } else {
            [self.weiboCommentList removeLastObject];
            [self.weiboCommentList addObjectsFromArray:commentList];
            [self loadMoreDataToTable];
        }
        [self.weiboCommentTableView reloadData];
    }
}

#pragma mark -
#pragma mark memory Control
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_weiboCommentTableView release];
    [super dealloc];
}

#pragma mark -
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.weiboCommentList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //该微博评论内容
    NSDictionary *weiboCommentContent = [self.weiboCommentList objectAtIndex:indexPath.row];
    
    static NSString *CellIdentifier = @"Cell";
    WeiboCommentTableViewCell *cell = (WeiboCommentTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[WeiboCommentTableViewCell alloc] initWithWeiboCommentContent:weiboCommentContent style:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        //选择显示风格
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.delegate = self;
    } else {
        cell.weiboCommentContent = weiboCommentContent;
    }
    return cell;
}

#pragma mark - WeiboCommentTableViewCellDelegate
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

#pragma mark -
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.weiboCommentTableView == tableView) {
        [self.weiboCommentList objectAtIndex:indexPath.row];
    }
}

#pragma mark -
#pragma mark - PullTableViewDelegate
- (void)pullTableViewDidTriggerRefresh:(PullTableView*)pullTableView
{
    self.weiboCommentList = nil;
    [self loadWeiboCommentWithWeiboId:[NSString stringWithFormat:@"%@",[self.weiboContent objectForKey:@"id"]]];
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView*)pullTableView
{
    [self loadWeiboCommentWithWeiboId:[NSString stringWithFormat:@"%@",[self.weiboContent objectForKey:@"id"]]];
}

#pragma mark - Refresh and load more methods

- (void) refreshTable
{
    /*
     
     Code to actually refresh goes here.
     
     */
    self.weiboCommentTableView.pullLastRefreshDate = [NSDate date];
    self.weiboCommentTableView.pullTableIsRefreshing = NO;
}

- (void) loadMoreDataToTable
{
    /*
     
     Code to actually load more data goes here.
     
     */
    self.weiboCommentTableView.pullTableIsLoadingMore = NO;
}
@end
