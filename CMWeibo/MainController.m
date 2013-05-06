//
//  MainController.m
//  CMWeibo
//
//  Created by Cameron on 13-3-21.
//  Copyright (c) 2013年 cm. All rights reserved.
//

#import "MainController.h"
#import "UIView+UIViewExt.h"
#import "HomeViewController.h"
#import "MessageViewController.h"
#import "ProfileViewController.h"
#import "DiscoverViewController.h"
#import "MoreViewController.h"
#import "BaseUINavigationController.h"
#import "AppDelegate.h"

@implementation MainController

- (id)init
{
    self = [super init];
    if (self) {
        self.tabBar.frame = CGRectMake(0, ScreenHeight - 44, 320, 44);
        UIView *transitionView = [[self.view subviews] objectAtIndex:0];
        transitionView.height= ScreenHeight - 44;
        [self.tabBar setHidden:YES];
        
        
        AppDelegate *appD = [[UIApplication sharedApplication] delegate];
        [appD _initSinaWeibo:self];
        
        
        [self _initViewController];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self _initTabBarView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)_initViewController
{
    HomeViewController *home = [[HomeViewController alloc] init];
    MessageViewController *message = [[MessageViewController alloc] init];
    ProfileViewController *personal = [[ProfileViewController alloc] init];
    DiscoverViewController *square = [[DiscoverViewController alloc] init];
    MoreViewController *more = [[MoreViewController alloc] init];
    
    NSArray *controllers = @[home, message, personal, square, more];
    NSMutableArray *navigations = [NSMutableArray arrayWithCapacity:5];
    for (UIViewController *controller in controllers) {
        BaseUINavigationController *navigation = [[BaseUINavigationController alloc] initWithRootViewController:controller];
        [navigations addObject:navigation];
        [navigation release];
    }
    self.viewControllers = navigations;
}

- (void)_initTabBarView
{
    _tabBarView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight - 44 - 20, 320, 44)];
    _tabBarView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tabbar_background"]];
    [self.view addSubview:_tabBarView];
    _tabBarBGSelectedShadow = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 64, 44)];
    _tabBarBGSelectedShadow.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tabbar_slider"]];
    [_tabBarView addSubview:_tabBarBGSelectedShadow];
    
    NSArray *tabBarButtonNames = @[@"tabbar_home", @"tabbar_message_center", @"tabbar_profile", @"tabbar_discover", @"tabbar_more"];
    NSArray *tabBarButtonHighlightedNames = @[@"tabbar_home_highlighted", @"tabbar_message_center_highlighted", @"tabbar_profile_highlighted", @"tabbar_discover_highlighted", @"tabbar_more_highlighted"];
    NSArray *tabBarButtonSelectedNames = @[@"tabbar_home_selected", @"tabbar_message_center_selected", @"tabbar_profile_selected", @"tabbar_discover_selected", @"tabbar_more_selected"];
    
    for (int i = 0; i < 5; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake((64-30)/2 + i*64, (49-30)/2, 30, 30);
        button.tag = i+1;
        [button setImage:[UIImage imageNamed:tabBarButtonNames[i]] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:tabBarButtonHighlightedNames[i]] forState:UIControlStateHighlighted];
        [button setImage:[UIImage imageNamed:tabBarButtonSelectedNames[i]] forState:UIControlStateSelected];

        
        [button addTarget:self action:@selector(selectedTab:) forControlEvents:UIControlEventTouchUpInside];
        if (i==0) {
            button.selected = YES;
        }
        [_tabBarView addSubview:button];
    }
    

}

- (void)selectedTab:(UIButton *)button
{
    if (button.selected) {
        
    } else {
        for (int i = 1; i < 6; i++) {
            if (i != button.tag) {
                UIButton *btn = (UIButton *)[_tabBarView viewWithTag:i];
                btn.selected = NO;
            }
        }
        self.selectedIndex = button.tag-1;
        button.selected = YES;
        _tabBarBGSelectedShadow.frame = CGRectMake((button.tag-1) * 64, 0, 64, 44);
    }
    NSLog(@"%p",button);
}

- (void)storeAuthData
{
//    SinaWeibo *sinaweibo = [self sinaweibo];
//    
//    
}

- (void)showTabBar:(CustomShowOrHideDirection)direction
{
    if (direction == CustomShowOrHideTabBarFromLeft) {
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:0.3];
        _tabBarView.frame = CGRectMake(0, ScreenHeight - 44 - 20, 320, 44);
        [UIView commitAnimations];
    }
    if (direction == CUstomShowOrHideTabBarFromBottom) {
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:0.3];
        _tabBarView.frame = CGRectMake(0, ScreenHeight - 44 - 20, 320, 44);
        [UIView commitAnimations];
    }
}

- (void)hideTabBar:(CustomShowOrHideDirection)direction
{
    if (direction == CustomShowOrHideTabBarFromLeft) {
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:0.3];
        _tabBarView.frame = CGRectMake(-320, ScreenHeight - 44 - 20, 320, 44);
        [UIView commitAnimations];
    }
    if (direction == CUstomShowOrHideTabBarFromBottom) {
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:0.3];
        _tabBarView.frame = CGRectMake(0, ScreenHeight - 20, 320, 44);
        [UIView commitAnimations];
    }
}

#pragma mark - SinaWeribo delegate
- (void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo
{
    NSDictionary *authData = [NSDictionary dictionaryWithObjectsAndKeys:
                              sinaweibo.accessToken, @"AccessTokenKey",
                              sinaweibo.expirationDate, @"ExpirationDateKey",
                              sinaweibo.userID, @"UserIDKey",
                              sinaweibo.refreshToken, @"refresh_token", nil];
    [[NSUserDefaults standardUserDefaults] setObject:authData forKey:@"SinaWeiboAuthData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)sinaweiboDidLogOut:(SinaWeibo *)sinaweibo
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SinaWeiboAuthData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)sinaweiboLogInDidCancel:(SinaWeibo *)sinaweibo
{
    NSLog(@"sinaweiboLogInDidCancel");
}


@end
