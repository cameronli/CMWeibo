//
//  MainController.h
//  CMWeibo
//
//  Created by Cameron on 13-3-21.
//  Copyright (c) 2013年 cm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SinaWeibo.h"

enum {
    CustomShowOrHideTabBarFromLeft = 0,
    CUstomShowOrHideTabBarFromBottom = 1
};
typedef NSUInteger CustomShowOrHideDirection;


@interface MainController : UITabBarController <SinaWeiboDelegate>
{
    UIView *_tabBarView;
    UIView *_tabBarBGSelectedShadow;
}

- (void)showTabBar:(CustomShowOrHideDirection)direction;

- (void)hideTabBar:(CustomShowOrHideDirection)direction;

@end
