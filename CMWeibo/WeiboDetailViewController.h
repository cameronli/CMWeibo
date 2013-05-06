//
//  WeiboDetailViewController.h
//  CMWeibo
//
//  Created by Cameron on 13-5-4.
//  Copyright (c) 2013年 cm. All rights reserved.
//

#import "BaseUIViewController.h"
#import "PullTableView.h"
#import "WeiboCommentTableViewCell.h"
#import "WeiboTableViewCell.h"

@interface WeiboDetailViewController : BaseUIViewController<SinaWeiboRequestDelegate,UITableViewDataSource, UITableViewDelegate, PullTableViewDelegate, WeiboCommentTableViewCellDelegate, WeiboTableViewCellDelegate>

@property (nonatomic, retain)NSDictionary *weiboContent;
@property (nonatomic, retain)NSMutableArray *weiboCommentList;
@property (retain, nonatomic) IBOutlet PullTableView *weiboCommentTableView;

#pragma mark -
#pragma mark - method
- (id)initWithWeiboContent:(NSDictionary *)weiboContent nibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;

@end
