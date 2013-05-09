//
//  HomeViewController.h
//  CMWeibo
//
//  Created by Cameron on 13-3-22.
//  Copyright (c) 2013年 cm. All rights reserved.
//

#import "BaseUIViewController.h"
#import "WeiboTableViewCell.h"
#import "EGORefreshTableHeaderView.h"
#import "PullTableView.h"

@interface HomeViewController : BaseUIViewController <SinaWeiboRequestDelegate, UITableViewDelegate, UITableViewDataSource, WeiboTableViewCellDelegate, PullTableViewDelegate>
{
    IBOutlet PullTableView *weiboListTableView;
    BOOL _reloading;
}

@property (nonatomic, retain)NSMutableArray *weiboList;


- (void)loadWeiboData;
- (void)setUIBarButtonItem;

@end
