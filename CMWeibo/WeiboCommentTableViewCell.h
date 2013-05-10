//
//  WeiboCommentTableViewCell.h
//  CMWeibo
//
//  Created by Cameron on 13-5-4.
//  Copyright (c) 2013年 cm. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WeiboCommentTableViewCellDelegate <NSObject>

@required
- (void)imageShowByUrl:(NSString *)imageUrl;
- (void)userInfoShow:(NSString *)userNickname;
- (void)topicShowByTopicContent:(NSString *)topicName;
- (void)openWebPageByUrl:(NSString *)url;
- (void)revertClick:(NSString *)revertUserName;

@end

@interface WeiboCommentTableViewCell : UITableViewCell<UIWebViewDelegate>

@property (nonatomic, assign)id<WeiboCommentTableViewCellDelegate> delegate;

#pragma mark data
@property (nonatomic, retain)NSDictionary *weiboCommentContent;

#pragma mark ui
@property (nonatomic, retain)UIImageView *userImage;
@property (nonatomic, retain)UILabel *userNickNameLabel;
@property (nonatomic, retain)UILabel *commentedTime;
@property (nonatomic, retain)UIButton *revertButton;
@property (nonatomic, retain)UIWebView *commentContent;

#pragma mark -
#pragma mark - method
- (id)initWithWeiboCommentContent:(NSDictionary *)weiboCommentContent style:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
