//
//  FollowUserTableCell.h
//  CMWeibo
//
//  Created by Cameron on 13-5-7.
//  Copyright (c) 2013年 cm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FollowUserTableCell : UITableViewCell

@property (nonatomic, retain) NSDictionary *userInfo;

#pragma mark UI Component
@property (nonatomic, retain) UIImageView *userImage;
@property (nonatomic, retain) UILabel *userNickName;
@property (nonatomic, retain) UILabel *recentWeibo;

- (id)initWithUserInfo:(NSDictionary *)userInfo style:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
