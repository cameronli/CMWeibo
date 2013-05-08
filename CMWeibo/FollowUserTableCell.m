//
//  FollowUserTableCell.m
//  CMWeibo
//
//  Created by Cameron on 13-5-7.
//  Copyright (c) 2013年 cm. All rights reserved.
//

#import "FollowUserTableCell.h"
#import "UIImageView+WebCache.h"

@implementation FollowUserTableCell

- (id)initWithUserInfo:(NSDictionary *)userInfo style:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.userImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
        
        self.userNickName = [[UILabel alloc] initWithFrame:CGRectMake(70, 10, 200, 24)];
        
        self.recentWeibo = [[UILabel alloc] initWithFrame:CGRectMake(70, 32, 200, 24)];
        
        [self addSubview:self.userImage];
        [self addSubview:self.userNickName];
        [self addSubview:self.recentWeibo];
        
        self.userInfo = userInfo;
        
        self.frame = CGRectMake(0, 0, 320, 70);
    }
    return self;
}

- (void)setUserInfo:(NSDictionary *)userInfo
{
    if (_userInfo != userInfo) {
        _userInfo = nil;
        _userInfo = [userInfo retain];
    }
    [self setCellContent];
}

- (void)setCellContent
{
    [self.userImage setImageWithURL:[NSURL URLWithString:[self.userInfo objectForKey:@"profile_image_url"]]
placeholderImage:[UIImage imageNamed:@"placeholder"] options:SDWebImageRefreshCached];
    
    [self.userNickName setText:[self.userInfo objectForKey:@"screen_name"]];
    
    NSDictionary *recentWeiboContent = [self.userInfo objectForKey:@"status"];
    
    [self.recentWeibo setText:[recentWeiboContent objectForKey:@"text"]];
    
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
