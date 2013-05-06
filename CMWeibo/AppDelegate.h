//
//  AppDelegate.h
//  CMWeibo
//
//  Created by Cameron on 13-3-21.
//  Copyright (c) 2013年 cm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainController.h"

@class DDMenuController;
@class SinaWeibo;
@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
//    SinaWeibo *sinaweibo;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) DDMenuController *menuCtrl;
@property (nonatomic, retain) MainController *main;
@property (nonatomic, retain) SinaWeibo *sinaweibo;

- (void)_initSinaWeibo:(MainController *)main;

@end
