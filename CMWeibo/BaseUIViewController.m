//
//  BaseUIViewController.m
//  CMWeibo
//
//  Created by Cameron on 13-3-21.
//  Copyright (c) 2013年 cm. All rights reserved.
//

#import "BaseUIViewController.h"
#import "AppDelegate.h"

@implementation BaseUIViewController

//override
- (void)setTitle:(NSString *)title
{
    [super setTitle:title];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.textColor = [UIColor blackColor];
    label.font = [UIFont boldSystemFontOfSize:18.0f];
    label.backgroundColor = [UIColor clearColor];
    label.text = title;
    [label sizeToFit];
    
    self.navigationItem.titleView = [label autorelease];
}

- (SinaWeibo *)sinaweibo
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    SinaWeibo *sinaweibo = appDelegate.sinaweibo;
    return sinaweibo;
}



@end
