//
//  WeiboCommentTableViewCell.m
//  CMWeibo
//
//  Created by Cameron on 13-5-4.
//  Copyright (c) 2013年 cm. All rights reserved.
//

#import "WeiboCommentTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "WeiboHtmlString.h"

@implementation WeiboCommentTableViewCell


- (id)initWithWeiboCommentContent:(NSDictionary *)weiboCommentContent style:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //用户头像
        self.userImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 50, 50)];
        self.userImage.userInteractionEnabled = YES;
        UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showUserInfo:)];
        [self.userImage addGestureRecognizer:imageTap];
        [imageTap release];
        
        //用户昵称
        self.userNickNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        
        //评论时间
        self.commentedTime = [[UILabel alloc] initWithFrame:CGRectZero];
        
        //回复按钮
        self.revertButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        //评论内容
        self.commentContent = [[UIWebView alloc] initWithFrame:CGRectZero];
        self.commentContent.scrollView.bounces = NO;
        self.commentContent.delegate = self;
        
        [self addSubview:self.userImage];
        [self addSubview:self.userNickNameLabel];
        [self addSubview:self.commentedTime];
        [self addSubview:self.revertButton];
        [self addSubview:self.commentContent];
        
        self.weiboCommentContent = weiboCommentContent;
        
    }
    return self;
}

- (void)setWeiboCommentContent:(NSDictionary *)weiboCommentContent
{
    if (_weiboCommentContent != weiboCommentContent) {
        _weiboCommentContent = nil;
        _weiboCommentContent = [weiboCommentContent retain];
    }
    [self setWeiboCommentTableViewCell];
}

- (void)setWeiboCommentTableViewCell
{
    //用户信息
    NSDictionary *userInfo = [self.weiboCommentContent objectForKey:@"user"];
    
    //用户头像设置
    self.userImage.layer.cornerRadius = 8;
    self.userImage.layer.masksToBounds = YES;
    self.userImage.layer.borderColor =  [[UIColor colorWithRed:163/255 green:163/255 blue:163/244 alpha:0.3] CGColor];
    self.userImage.layer.borderWidth = 2;
    
    NSString *user_profile_image_url = [userInfo objectForKey:@"profile_image_url"];
    [self.userImage setImageWithURL:[NSURL URLWithString:user_profile_image_url]
                   placeholderImage:[UIImage imageNamed:@"placeholder"] options:SDWebImageRefreshCached];
    
    //用户昵称设置
    self.userNickNameLabel.backgroundColor = [UIColor clearColor];
    self.userNickNameLabel.text = [userInfo objectForKey:@"screen_name"];
    CGSize userNickSize = CGSizeMake(170, 24);
    CGSize userNicklabelSize = [self.userNickNameLabel.text sizeWithFont:self.userNickNameLabel.font constrainedToSize:userNickSize lineBreakMode:NSLineBreakByTruncatingTail];
    self.userNickNameLabel.frame = CGRectMake(70, 5, userNicklabelSize.width, userNicklabelSize.height);
    
    //评论时间
    NSDate *createdDate = [CustomUtil dateFromString:[self.weiboCommentContent objectForKey:@"created_at"] formate:@"EEE MMM d HH:mm:ss Z yyyy "];
    NSString *createdDateStr = nil;
    if ([[CustomUtil stringFromDate:createdDate formate:@"YYYY"] isEqualToString:[CustomUtil stringFromDate:[NSDate date] formate:@"YYYY"]]) {
        createdDateStr  = [CustomUtil stringFromDate:createdDate formate:@"MM-dd HH:mm"];
    } else {
        createdDateStr  = [CustomUtil stringFromDate:createdDate formate:@"YYYY-MM-dd HH:mm"];
    }
    self.commentedTime.backgroundColor = [UIColor clearColor];
    self.commentedTime.font = [UIFont systemFontOfSize:12];
    self.commentedTime.text = createdDateStr;
    CGSize createdTimeLabelSize = [self.commentedTime.text sizeWithFont:self.commentedTime.font];
    self.commentedTime.frame = CGRectMake(320-10-createdTimeLabelSize.width, 5, createdTimeLabelSize.width, createdTimeLabelSize.height);
    
    [self.revertButton setBackgroundImage:[UIImage imageNamed:@"comments_commentbutton_background"] forState:UIControlStateNormal];
    self.revertButton.frame = CGRectMake(320-34, 21, 34, 30);
    [self.revertButton addTarget:self action:@selector(revertButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.commentContent loadHTMLString:[WeiboHtmlString transformString:[self.weiboCommentContent objectForKey:@"text"]] baseURL:nil];
    CGSize weiboSize = CGSizeMake(210, 960);
    NSString *weiboText = [self.weiboCommentContent objectForKey:@"text"];
    CGSize weiboLabelSize = [weiboText sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:weiboSize lineBreakMode:NSLineBreakByCharWrapping];
    self.commentContent.frame = CGRectMake(70, 24, weiboSize.width, weiboLabelSize.height*1.3+10);
    
    self.frame = CGRectMake(0, 0, 320, self.commentContent.frame.origin.y+self.commentContent.frame.size.height+5);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


//点击用户头像
- (void)showUserInfo:(UITapGestureRecognizer *)tap
{
    if ([_delegate respondsToSelector:@selector(userInfoShow:)]) {
        NSDictionary *userInfo = [self.weiboCommentContent objectForKey:@"user"];
        [_delegate userInfoShow:[userInfo objectForKey:@"screen_name"]];
    }
}



#pragma -mark UIWebView Delegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
}

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *requestString = [[request URL] absoluteString];
    
    NSArray *urlComps = [requestString componentsSeparatedByString:@"&"];
    
    if ([urlComps count] > 1 && [(NSString *)[urlComps objectAtIndex:1] isEqualToString:@"cmd1"])//@方法
    {
        NSString *str = [[urlComps objectAtIndex:2] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        if ([_delegate respondsToSelector:@selector(userInfoShow:)]) {
            [_delegate userInfoShow:str];
        }
        
        
        return YES;
    }
    
    if ([urlComps count] > 1 && [(NSString *)[urlComps objectAtIndex:1] isEqualToString:@"cmd2"])//话题方法
    {
        NSString *str = [[urlComps objectAtIndex:2] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        if ([_delegate respondsToSelector:@selector(topicShowByTopicContent:)]) {
            [_delegate topicShowByTopicContent:str];
        }
        
        
        return YES;
    }
    
    NSURL *requestURL =[ [ request URL ] retain ];
    if ( ( [ [ requestURL scheme ] isEqualToString: @"http" ] || [ [ requestURL scheme ] isEqualToString: @"https" ] || [ [ requestURL scheme ] isEqualToString: @"mailto" ])
        && ( navigationType == UIWebViewNavigationTypeLinkClicked ) ) {
        if ([_delegate respondsToSelector:@selector(openWebPageByUrl:)]) {
            [_delegate openWebPageByUrl:requestString];
        }
        return NO;
    }
    [ requestURL release ];
    
    return YES;
}

#pragma mark - 
#pragma mark action
- (void)revertButtonClick:(UIButton *)sender
{
    if ([_delegate respondsToSelector:@selector(revertClick:)]) {
        [_delegate revertClick:self.userNickNameLabel.text];
    }
}

#pragma mark - 
#pragma mark memory control
- (void)dealloc
{
    _weiboCommentContent = nil;
    _userImage = nil;
    _userNickNameLabel = nil;
    _commentedTime = nil;
    _revertButton = nil;
    _commentContent = nil;
    [super dealloc];
}

@end
