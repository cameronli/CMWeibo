//
//  UserWeiboTableViewCell.h
//  CMWeibo
//
//  Created by Cameron on 13-5-2.
//  Copyright (c) 2013年 cm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"


@protocol UserWeiboTableViewCellDelegate <NSObject>

@required
- (void)imageShowByUrl:(NSString *)imageUrl;
- (void)userInfoShow:(NSString *)userNickname;
- (void)topicShowByTopicContent:(NSString *)topicName;
- (void)openWebPageByUrl:(NSString *)url;

@end

@interface UserWeiboTableViewCell : UITableViewCell<UIWebViewDelegate>

@property (nonatomic, assign)id<UserWeiboTableViewCellDelegate> delegate;
@property (retain, nonatomic) NSDictionary *weiboContent;

#pragma mark -
#pragma mark - WeiboUI
@property (nonatomic, retain)UILabel *userNickNameLabel;
@property (nonatomic, retain)UIImageView *retweetImage;
@property (nonatomic, retain)UILabel *retweetLabel;
@property (nonatomic, retain)UIImageView *commentImage;
@property (nonatomic, retain)UILabel *commentLabel;
@property (nonatomic, retain)UIWebView *weiboContentLabel;
@property (nonatomic, retain)UIImageView *weiboImage;
@property (nonatomic, retain)UIView *retweetContentView;
@property (nonatomic, retain)UILabel *createdTimeLabel;
@property (nonatomic, retain)UILabel *weiboSourceLabel;

- (id)initWithWeiboData:(NSDictionary *)weiboContent style:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
