//
//  WeiboTableViewCell.h
//  CMWeibo
//
//  Created by Cameron on 13-3-28.
//  Copyright (c) 2013年 cm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
#import "IFTweetLabel.h"

@protocol WeiboTableViewCellDelegate <NSObject>

@required
- (void)imageShowByUrl:(NSString *)imageUrl;
- (void)userInfoShow:(NSString *)userNickname;
- (void)topicShowByTopicContent:(NSString *)topicName;
- (void)openWebPageByUrl:(NSString *)url;

@end

@interface WeiboTableViewCell : UITableViewCell <UIWebViewDelegate>
{
    id<WeiboTableViewCellDelegate> delegate;
}
//微博内容
@property (nonatomic, assign)id<WeiboTableViewCellDelegate> delegate;
@property (nonatomic, retain)NSDictionary *weiboContent;
@property (nonatomic, retain)UIImageView *userImage;
@property (nonatomic, retain)UILabel *userNickName;
@property (nonatomic, retain)UIImageView *isVIPImage;
@property (nonatomic, retain)UIImageView *retweetImage;
@property (nonatomic, retain)UILabel *retweetLabel;
@property (nonatomic, retain)UIImageView *commentImage;
@property (nonatomic, retain)UILabel *commentLabel;
@property (nonatomic, retain)UIWebView *weiboContentLabel;
//@property (nonatomic, retain)UIWebView *weiboContentWebView;//cancel
@property (nonatomic, retain)UIImageView *weiboImage;
@property (nonatomic, retain)UILabel *createdTimeLabel;
@property (nonatomic, retain)UILabel *weiboSourceLabel;
@property (nonatomic, retain)UIView *retweetContentView;

- (id)initWithWeiboData:(NSDictionary *)weiboContent style:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

- (void)setHeight;

@end
