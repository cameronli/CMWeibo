//
//  ImageShowViewController.h
//  CMWeibo
//
//  Created by Cameron on 13-4-15.
//  Copyright (c) 2013年 cm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageShowViewController : UIViewController<UIScrollViewDelegate>
{
    UIImageView *_imageView;
}

@property (nonatomic, assign)NSString *imageUrl;

- (id)initWithImageUrl:(NSString *)imageUrl;

@end
