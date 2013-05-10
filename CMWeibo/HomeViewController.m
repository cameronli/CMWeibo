//
//  HomeViewController.m
//  CMWeibo
//
//  Created by Cameron on 13-3-22.
//  Copyright (c) 2013年 cm. All rights reserved.
//

#import "HomeViewController.h"
#import "IFTweetLabel.h"
#import "ImageShowViewController.h"
#import "AppDelegate.h"
#import "UserInfoViewController.h"
#import "WeiboDetailViewController.h"
#import "UploadWeiboViewController.h"



static NSString *recevieDataType;

@interface HomeViewController (){
    UIBarButtonItem *_logout;
    UIBarButtonItem *_uploadWeibo;
    UIBarButtonItem *_bind;
}


@end

@implementation HomeViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.title = @"首页";
        self.view.backgroundColor = [UIColor redColor];
        //判断是否认证
        if (self.sinaweibo.isAuthValid) {
            //加载微博列表数据
            [self loadWeiboData];
        } else {
            [self.sinaweibo logIn];
        }
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //注销按钮
    _logout = [[UIBarButtonItem alloc] initWithTitle:@"注销" style:UIBarButtonItemStyleBordered target:self action:@selector(logoutAction:)];
    
    UIButton *customBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    customBarButton.frame = CGRectMake(0, 0, [UIImage imageNamed:@"navigationbar_comment"].size.width, [UIImage imageNamed:@"navigationbar_comment"].size.height);
    [customBarButton setImage:[UIImage imageNamed:@"navigationbar_comment"] forState:UIControlStateNormal];
    [customBarButton addTarget:self action:@selector(uploadWeibo:) forControlEvents:UIControlEventTouchUpInside];
    
    _uploadWeibo = [[UIBarButtonItem alloc] initWithCustomView:customBarButton];
    
    
    //绑定账号按钮
    _bind = [[UIBarButtonItem alloc] initWithTitle:@"绑定账号" style:UIBarButtonItemStyleBordered target:self action:@selector(bindAction:)];
    
    [self setUIBarButtonItem];
    
}

- (void)setUIBarButtonItem
{
    if ([self.sinaweibo isAuthValid]) {
        self.navigationItem.leftBarButtonItem = _logout;
        self.navigationItem.rightBarButtonItem = _uploadWeibo;
    } else {
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.rightBarButtonItem = _bind;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}


#pragma mark - load Data
- (void)loadWeiboData
{
    recevieDataType = RECEVIE_WEIBO_DATA;
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObject:@"20" forKey:@"count"];
    if (_weiboList != nil) {
        NSDictionary *lastWeibo = [_weiboList lastObject];
        NSString *lastWeiboId = [NSString stringWithFormat:@"%@",[lastWeibo objectForKey:@"id"]];//(NSString *)[lastWeibo objectForKey:@"id"];
        [param setValue:lastWeiboId forKey:@"max_id"];
    }
    NSLog(@"%@",param);
    [self.sinaweibo requestWithURL:@"statuses/home_timeline.json" params:param httpMethod:@"GET" delegate:self];
}

- (void)loadUserInfoDataWithUserNickName:(NSString *)userNickName
{
    recevieDataType = RECEVIE_USER_DATA;
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObject:userNickName forKey:@"screen_name"];
    [self.sinaweibo requestWithURL:@"users/show.json" params:param httpMethod:@"GET" delegate:self];
}

#pragma mark - SinaWeiboRequest Delegate
//网络加载失败
- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"网络加载失败");
    weiboListTableView.pullTableIsLoadingMore = NO;
    weiboListTableView.pullTableIsRefreshing = NO;
}

//网络加载完成
- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    if ([recevieDataType isEqualToString:RECEVIE_WEIBO_DATA]) {
        NSDictionary *weiboDic = (NSDictionary *)[result retain];
        if (_weiboList == nil) {
            _weiboList = [[NSMutableArray alloc] init];
            [_weiboList addObjectsFromArray:[weiboDic objectForKey:@"statuses"]];
            [self refreshTable];
        } else {
            [_weiboList removeLastObject];
            [_weiboList addObjectsFromArray:[weiboDic objectForKey:@"statuses"]];
            [self loadMoreDataToTable];
        }
        [weiboListTableView reloadData];
    }
    if ([recevieDataType isEqualToString:RECEVIE_USER_DATA]) {
        NSLog(@"%@",result);
        NSDictionary *userInfo = (NSDictionary *)[result retain];
//        UserInfoViewController *userInfoViewController = [[UserInfoViewController alloc] initWithUserInfo:userInfo];
        UserInfoViewController *userInfoViewController = [[[UserInfoViewController alloc] initWithNibName:@"UserInfoViewController" bundle:nil userInfo:userInfo] autorelease];
        [self.navigationController pushViewController:userInfoViewController animated:YES];
    }
    if ([recevieDataType isEqualToString:RECEVIE_COMMENT_DATA]) {
        
    }
}


#pragma mark - Action
- (void)bindAction:(UIBarButtonItem *)button
{
    [self.sinaweibo logIn];
}

- (void)logoutAction:(UIBarButtonItem *)button
{
    [self.sinaweibo logOut];
}

- (void)uploadWeibo:(UIButton *)button
{
    UploadWeiboViewController *upload = [[UploadWeiboViewController alloc] init];
//    upload.
    [self presentViewController:upload animated:YES completion:nil];
}

#pragma mark - Memory Manager

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [weiboListTableView release];
    [weiboListTableView release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

#pragma mark - UITableViewDataSource Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_weiboList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //该微博内容
    NSDictionary *weiboContent = [_weiboList objectAtIndex:indexPath.row];
    
    static NSString *CellIdentifier = @"Cell";
    WeiboTableViewCell *cell = (WeiboTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    WeiboTableViewCell *cell = (WeiboTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[WeiboTableViewCell alloc] initWithWeiboData:weiboContent style:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        //选择显示风格
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.delegate = self;
    } else {
        cell.weiboContent = weiboContent;
    }
    return cell;
}

#pragma mark -
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [_weiboList objectAtIndex:indexPath.row];
    WeiboDetailViewController *weiboDetailView = [[[WeiboDetailViewController alloc] initWithWeiboContent:dic nibName:@"WeiboDetailViewController" bundle:nil] autorelease];
    [self.navigationController pushViewController:weiboDetailView animated:YES];
//    NSDictionary *userDic = [dic objectForKey:@"user"];
//    NSLog(@"%@",[_weiboList objectAtIndex:indexPath.row]);
//    NSLog(@"%@",[userDic objectForKey:@"verified_reason"]);
}


//cell高度设置
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

#pragma mark -
#pragma mark - WeiboTableViewCell Delegate
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

- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView
{
//    [self performSelector:@selector(refreshTable) withObject:nil afterDelay:3.0f];
    _weiboList = nil;
    [self loadWeiboData];
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView
{
    [self loadWeiboData];
//    [self performSelector:@selector(loadMoreDataToTable) withObject:nil afterDelay:3.0f];
}

#pragma mark - Refresh and load more methods

- (void) refreshTable
{
    /*
     
     Code to actually refresh goes here.
     
     */
    weiboListTableView.pullLastRefreshDate = [NSDate date];
    weiboListTableView.pullTableIsRefreshing = NO;
}

- (void) loadMoreDataToTable
{
    /*
     
     Code to actually load more data goes here.
     
     */
    weiboListTableView.pullTableIsLoadingMore = NO;
}

@end
