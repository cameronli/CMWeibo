//
//  ImageShowViewController.m
//  CMWeibo
//
//  Created by Cameron on 13-4-15.
//  Copyright (c) 2013年 cm. All rights reserved.
//

#import "ImageShowViewController.h"
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"

@interface ImageShowViewController ()

@end

@implementation ImageShowViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        [super.navigationController setNavigationBarHidden:YES animated:YES];
        UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-20)];
        _imageView = [[UIImageView alloc] init];
        [_imageView setImageWithURL:[NSURL URLWithString:self.imageUrl]
                  placeholderImage:[UIImage imageNamed:@"placeholder"]
                           options:SDWebImageRefreshCached
                          progress:^(NSUInteger receivedSize, long long expectedSize){
                              
                          }
                         completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType){
//                             NSLog(@"%f,%f",image.size.height,image.size.width);
                             
                             CGSize size = CGSizeMake(320, _imageView.image.size.height*320/_imageView.image.size.width);
                             _imageView.frame = CGRectMake(0, 460/2-size.height/2>0?460/2-size.height/2:0, size.width, size.height);
                             scroll.contentSize = _imageView.frame.size;
                             scroll.minimumZoomScale = 1;
                             scroll.maximumZoomScale = _imageView.image.size.width>320?_imageView.image.size.width/320:1;
                         }];
        _imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(back:)];
        [_imageView addGestureRecognizer:imageTap];
        [imageTap release];
        
        [scroll addSubview:_imageView];
        scroll.delegate = self;
        [self.view addSubview:scroll];
    }
    return self;
}

- (id)initWithImageUrl:(NSString *)imageUrl
{
    self.imageUrl = imageUrl;
    self = [super init];
    
    return self;
}

- (void)back:(UITapGestureRecognizer *)tap
{
    AppDelegate *mainDelegate = [[UIApplication sharedApplication] delegate];
    [mainDelegate.main showTabBar:CustomShowOrHideTabBarFromLeft];
    self.navigationController.hidesBottomBarWhenPushed = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [_imageView release];
    [super dealloc];
}

#pragma -mark UIScrollView Delegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    _imageView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                 scrollView.contentSize.height * 0.5 + offsetY);
//    NSLog(@"%f",scrollView.zoomScale);
    if (scrollView.zoomScale < 0.55) {
        [self back:nil];
    }
}

@end
