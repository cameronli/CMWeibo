//
//  UINavigationBar+NavigationSetBackGoundCategory.m
//  CMWeibo
//
//  Created by Cameron on 13-3-22.
//  Copyright (c) 2013年 cm. All rights reserved.
//

#import "UINavigationBar+NavigationSetBackGoundCategory.h"

@implementation UINavigationBar (NavigationSetBackGoundCategory)

- (void)drawRect:(CGRect)rect
{
    UIImage *img = [UIImage imageNamed:@"navigationbar_background"];
    [img drawInRect:rect];
}

@end
