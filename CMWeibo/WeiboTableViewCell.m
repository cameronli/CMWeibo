//
//  WeiboTableViewCell.m
//  CMWeibo
//
//  Created by Cameron on 13-3-28.
//  Copyright (c) 2013年 cm. All rights reserved.
//

#import "WeiboTableViewCell.h"
#import "WeiboHtmlString.h"

@interface WeiboTableViewCell(TableViewMaker)

- (void)setWeiboTableViewCell;

@end

@implementation WeiboTableViewCell
@synthesize delegate = _delegate;


- (id)initWithWeiboData:(NSDictionary *)weiboContent style:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //用户头像
        self.userImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
        self.userImage.userInteractionEnabled = YES;
        UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showUserInfo:)];
        [self.userImage addGestureRecognizer:imageTap];
        [imageTap release];
        
        //用户昵称
        self.userNickName = [[UILabel alloc] initWithFrame:CGRectZero];
        
        //是否vip
        self.isVIPImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.isVIPImage.image = [UIImage imageNamed:@"timeline_membership_icon"];
        
        //转发图片
        self.retweetImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.retweetImage.image = [UIImage imageNamed:@"timeline_retweet_count_icon"];
        
        //转发数量
        self.retweetLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        
        //评论图片
        self.commentImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.commentImage.image = [UIImage imageNamed:@"timeline_comment_count_icon"];
        
        //评论数量
        self.commentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        
        //微博的内容
        self.weiboContentLabel = [[UIWebView alloc] init];
//        self.weiboContentWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
//        [self.weiboContentLabel setFont:[UIFont systemFontOfSize:18.0f]];
//        [self.weiboContentLabel setTextColor:[UIColor blackColor]];
        [self.weiboContentLabel setBackgroundColor:[UIColor clearColor]];
        self.weiboContentLabel.frame = CGRectMake(80, 30, 240, 0);
        self.weiboContentLabel.delegate = self;
        self.weiboContentLabel.scrollView.bounces = NO;
        
        //微博的图片
        self.weiboImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        
        //转发的原微博
        self.retweetContentView = [[UIView alloc] initWithFrame:CGRectZero];
        
        //微博创建时间
        self.createdTimeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        
        //微博发布来源
        self.weiboSourceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        
        
        
        [self addSubview:self.userImage];
        [self addSubview:self.userNickName];
        [self addSubview:self.isVIPImage];
        
        [self addSubview:self.retweetImage];
        [self addSubview:self.retweetLabel];
        [self addSubview:self.commentImage];
        [self addSubview:self.commentLabel];
        
        [self addSubview:self.weiboContentLabel];
        [self addSubview:self.weiboImage];
        
        [self addSubview:self.retweetContentView];
        
        [self addSubview:self.createdTimeLabel];
        [self addSubview:self.weiboSourceLabel];
        
        self.weiboContent = weiboContent;
        
//        if (self.weiboContent != nil) {
//            [self setWeiboTableViewCell];
//        }
        
    }
    return self;
}

- (void)setWeiboTableViewCell
{
    //用户信息
    NSDictionary *userInfo = [self.weiboContent objectForKey:@"user"];
    
    //用户头像设置
    self.userImage.layer.cornerRadius = 8;
    self.userImage.layer.masksToBounds = YES;
    self.userImage.layer.borderColor =  [[UIColor colorWithRed:163/255 green:163/255 blue:163/244 alpha:0.3] CGColor];
    self.userImage.layer.borderWidth = 2;
    
    NSString *user_profile_image_url = [userInfo objectForKey:@"profile_image_url"];
    [self.userImage setImageWithURL:[NSURL URLWithString:user_profile_image_url]
                   placeholderImage:[UIImage imageNamed:@"placeholder"] options:SDWebImageRefreshCached];
    
    //用户昵称设置
    self.userNickName.backgroundColor = [UIColor clearColor];
    self.userNickName.text = [userInfo objectForKey:@"screen_name"];
    CGSize userNickSize = CGSizeMake(230, 100);
    CGSize userNicklabelSize = [self.userNickName.text sizeWithFont:self.userNickName.font constrainedToSize:userNickSize];
    self.userNickName.frame = CGRectMake(80, 10, userNicklabelSize.width, userNicklabelSize.height);
    
    //是否vip
    self.isVIPImage.frame = CGRectMake(80+userNicklabelSize.width+5, 12, 14, 14);
    
    //评论数量
    self.commentLabel.backgroundColor = [UIColor clearColor];
//    NSLog(@"%@",[[self.weiboContent objectForKey:@"comments_count"] class]);
    self.commentLabel.text = [NSString stringWithFormat:@"%@",[self.weiboContent objectForKey:@"comments_count"]];
    self.commentLabel.font = [UIFont systemFontOfSize:14];
    self.commentLabel.textColor = [UIColor colorWithRed:154/255 green:164/255 blue:188/255 alpha:0.5];
    CGSize commentLabelSize = [self.commentLabel.text sizeWithFont:self.commentLabel.font];
    self.commentLabel.frame = CGRectMake(SCREEN_WIDTH-10-commentLabelSize.width, 13, commentLabelSize.width, commentLabelSize.height);
    
    //评论图标
    self.commentImage.frame = CGRectMake(self.commentLabel.frame.origin.x-12-3, 16, 12, 12);
    
    //转发数量
    self.retweetLabel.backgroundColor = [UIColor clearColor];
    self.retweetLabel.text = [NSString stringWithFormat:@"%@",[self.weiboContent objectForKey:@"reposts_count"]];
    self.retweetLabel.font = [UIFont systemFontOfSize:14];
    self.retweetLabel.textColor = [UIColor colorWithRed:154/255 green:164/255 blue:188/255 alpha:0.5];
    CGSize retweetLabelSize = [self.retweetLabel.text sizeWithFont:self.retweetLabel.font];
    self.retweetLabel.frame = CGRectMake(self.commentImage.frame.origin.x-10-retweetLabelSize.width, 13, retweetLabelSize.width, retweetLabelSize.height);
    
    //转发图标
    self.retweetImage.frame = CGRectMake(self.retweetLabel.frame.origin.x-12-3, 16, 12, 12);
    
    //
    
    
    //微博内容设置
/*
//    [self.weiboContentLabel setNumberOfLines:0];
//    self.weiboContentLabel.translatesAutoresizingMaskIntoConstraints = NO;
//    [self.weiboContentLabel setLinksEnabled:NO];
    
//    NSLog(@"%@",[self.weiboContent objectForKey:@"text"]);
//    self.weiboContentLabel.text = [self.weiboContent objectForKey:@"text"];
//    CGSize weiboSize = CGSizeMake(230, 960);
//    CGSize weiboLabelSize = [self.weiboContentLabel.text sizeWithFont:self.weiboContentLabel.font constrainedToSize:weiboSize];
//    self.weiboContentLabel.frame = CGRectMake(80, 30, weiboSize.width, weiboLabelSize.height+10);
//    [self.weiboContentLabel layoutIfNeeded];
//    CGFloat webViewHeight = 0.0f;
//    if (self.weiboContentLabel.subviews.count > 0) {
//        UIView *scrollerView = [self.weiboContentLabel.subviews objectAtIndex:0];
//        if (scrollerView.subviews.count > 0) {
//            UIView *webDocView = scrollerView.subviews.lastObject;
//            if ([webDocView isKindOfClass:[NSClassFromString(@"UIWebDocumentView") class]]) {
//                webViewHeight = webDocView.frame.size.height;
//            }
//        }
//    }
//    CGRect frame = self.weiboContentLabel.frame;
//    frame.size = self.weiboContentLabel.contentSize;
//    self.weiboContentLabel.frame = frame;
//    self.weiboContentLabel.autoresizesSubviews = YES;
//    self.weiboContentLabel.autoresizingMask =(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
//    CGRect frame = self.weiboContentLabel.frame;
//    frame.origin = CGPointMake(80, 30);
//    frame.size = self.weiboContentLabel.contentSize;
//    self.weiboContentLabel.frame = frame;
//    [self.weiboContentLabel layoutIfNeeded];
*/
    [self.weiboContentLabel loadHTMLString:[WeiboHtmlString transformString:[self.weiboContent objectForKey:@"text"]] baseURL:nil];
    CGSize weiboSize = CGSizeMake(230, 960);
    NSString *weiboText = [self.weiboContent objectForKey:@"text"];
    CGSize weiboLabelSize = [weiboText sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:weiboSize lineBreakMode:NSLineBreakByCharWrapping];
    self.weiboContentLabel.frame = CGRectMake(80, 30, weiboSize.width, weiboLabelSize.height*1.3+10);
    
    
    //微博的图片
    self.weiboImage.frame = CGRectMake(90, self.weiboContentLabel.frame.origin.y+self.weiboContentLabel.frame.size.height, 0, 0);
    if ([self.weiboContent objectForKey:@"thumbnail_pic"]) {
        self.weiboImage.frame = CGRectMake(90, self.weiboContentLabel.frame.origin.y+self.weiboContentLabel.frame.size.height, 100, 100);
        self.weiboImage.contentMode = UIViewContentModeScaleAspectFit;
        NSString *thumbnail_pic_url = [self.weiboContent objectForKey:@"thumbnail_pic"];
        [self.weiboImage setImageWithURL:[NSURL URLWithString:thumbnail_pic_url]
                       placeholderImage:[UIImage imageNamed:@"placeholder"] options:SDWebImageRefreshCached];
        self.weiboImage.userInteractionEnabled = YES;
        UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClick:)];
        [self.weiboImage addGestureRecognizer:imageTap];
        [imageTap release];
    }
    
    //转发的微博
    for (UIView *view in self.retweetContentView.subviews) {
        [view removeFromSuperview];
    }
    self.retweetContentView.frame = CGRectMake(80, self.weiboImage.frame.origin.y+self.weiboImage.frame.size.height, 0, 0);
    UIView *retweetBackGroundView = [[UIView alloc] initWithFrame:CGRectZero];
    if ([self.weiboContent objectForKey:@"retweeted_status"]) {
        NSDictionary *retweetContent = [self.weiboContent objectForKey:@"retweeted_status"];
        NSDictionary *originalUserInfo = [retweetContent objectForKey:@"user"];
        NSString *retweetContentText = [NSString stringWithFormat:@"@%@ : %@",[originalUserInfo objectForKey:@"screen_name"],[retweetContent objectForKey:@"text"]];
        //转发的原微博内容
//        IFTweetLabel *retweetContentLabel = [[IFTweetLabel alloc] initWithFrame:CGRectZero];
//        [retweetContentLabel setNumberOfLines:0];
//        [retweetContentLabel setFont:[UIFont systemFontOfSize:16.0f]];
//        [retweetContentLabel setTextColor:[UIColor blackColor]];
//        [retweetContentLabel setBackgroundColor:[UIColor clearColor]];
//        [retweetContentLabel setLinksEnabled:NO];
//        
//        retweetContentLabel.text = retweetContentText;
//        CGSize retweetContentSize = CGSizeMake(220, 960);
//        CGSize retweetContentLabelSize = [retweetContentText sizeWithFont:[UIFont systemFontOfSize:16.0f] constrainedToSize:retweetContentSize];
//        retweetContentLabel.frame = CGRectMake(5, 5, retweetContentLabelSize.width, retweetContentLabelSize.height);
//        [retweetBackGroundView addSubview:retweetContentLabel];
        UIWebView *retweetContentLabel = [[UIWebView alloc] initWithFrame:CGRectZero];
        retweetContentLabel.backgroundColor = [UIColor clearColor];
        [retweetContentLabel setOpaque:NO];
        retweetContentLabel.delegate = self;
        
        [retweetContentLabel loadHTMLString:[WeiboHtmlString transformString:retweetContentText] baseURL:nil];
        CGSize weiboSize = CGSizeMake(220, 960);
        CGSize weiboLabelSize = [retweetContentText sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:weiboSize lineBreakMode:NSLineBreakByCharWrapping];
        retweetContentLabel.frame = CGRectMake(5, 10, weiboSize.width, weiboLabelSize.height*1.3+10);
        [retweetBackGroundView addSubview:retweetContentLabel];
        
        self.retweetContentView.frame = CGRectMake(80, self.weiboImage.frame.origin.y+self.weiboImage.frame.size.height, 230, retweetContentLabel.frame.size.height+10);
        
        //转发的原微博是否有图片
        if ([retweetContent objectForKey:@"thumbnail_pic"]) {
            UIImageView *retweetImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, retweetContentLabel.frame.origin.y+retweetContentLabel.frame.size.height+5, 100, 100)];// CGRectMake(90, self.weiboContentLabel.frame.origin.y+self.weiboContentLabel.frame.size.height, 100, 100);
            retweetImageView.contentMode = UIViewContentModeScaleAspectFit;
            NSString *retweet_thumbnail_pic_url = [retweetContent objectForKey:@"thumbnail_pic"];
            [retweetImageView setImageWithURL:[NSURL URLWithString:retweet_thumbnail_pic_url]
                            placeholderImage:[UIImage imageNamed:@"placeholder"] options:SDWebImageRefreshCached];
            retweetImageView.userInteractionEnabled = YES;
            
            UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClick:)];
            [retweetImageView addGestureRecognizer:imageTap];
            [imageTap release];
            
            [retweetBackGroundView addSubview:retweetImageView];
            [retweetImageView release];
            self.retweetContentView.frame = CGRectMake(80, self.weiboImage.frame.origin.y+self.weiboImage.frame.size.height, 230, retweetContentLabel.frame.size.height+10+120);
        }
        
        [retweetContentLabel release];
        
//        UIImage *image = [UIImage imageNamed:@"timeline_retweet_background"]; // 用contentOfFile方式更好
//        self.retweetContentView.layer.contents = (id) image.CGImage; // 如果需要背景透明加上下面这句
//        self.retweetContentView.layer.backgroundColor = [UIColor clearColor].CGColor;
        //设置转发微博背景颜色以及圆角
        retweetBackGroundView.frame = CGRectMake(1, 6, self.retweetContentView.frame.size.width-1, self.retweetContentView.frame.size.height-6);
        retweetBackGroundView.backgroundColor = [UIColor colorWithRed:239/255 green:239/255 blue:239/255 alpha:0.06];
        retweetBackGroundView.layer.cornerRadius = 5;
        retweetBackGroundView.alpha = 1;
        [self.retweetContentView addSubview:retweetBackGroundView];
        self.retweetContentView.backgroundColor = [UIColor whiteColor];
        //转发微博背景的上端
        [retweetBackGroundView release];
        UIImageView *retweetBackGroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"timeline_retweet_background"]];
        
        retweetBackGroundImage.contentMode = UIViewContentModeTopLeft;
        retweetBackGroundImage.clipsToBounds = YES;
        retweetBackGroundImage.frame = CGRectMake(0, 0, retweetBackGroundImage.frame.size.width, 6);
        [self.retweetContentView addSubview:retweetBackGroundImage];
        [self.retweetContentView sendSubviewToBack:retweetBackGroundImage];
        [retweetBackGroundImage release];
    }
    
    //微博创建时间
    NSDate *createdDate = [CustomUtil dateFromString:[self.weiboContent objectForKey:@"created_at"] formate:@"EEE MMM d HH:mm:ss Z yyyy "];
    NSString *createdDateStr = nil;
    if ([[CustomUtil stringFromDate:createdDate formate:@"YYYY"] isEqualToString:[CustomUtil stringFromDate:[NSDate date] formate:@"YYYY"]]) {
        createdDateStr  = [CustomUtil stringFromDate:createdDate formate:@"MM-dd HH:mm"];
    } else {
        createdDateStr  = [CustomUtil stringFromDate:createdDate formate:@"YYYY-MM-dd HH:mm"];
    }
    self.createdTimeLabel.backgroundColor = [UIColor clearColor];
    self.createdTimeLabel.font = [UIFont systemFontOfSize:12];
    self.createdTimeLabel.text = createdDateStr;
    CGSize createdTimeLabelSize = [self.createdTimeLabel.text sizeWithFont:self.createdTimeLabel.font];
    self.createdTimeLabel.frame = CGRectMake(80, self.retweetContentView.frame.origin.y+self.retweetContentView.frame.size.height+2, createdTimeLabelSize.width, createdTimeLabelSize.height);
    
    //微博信息来源
    self.weiboSourceLabel.backgroundColor = [UIColor clearColor]; 
    self.weiboSourceLabel.font = [UIFont systemFontOfSize:12];
    NSString *originSource = [self.weiboContent objectForKey:@"source"];
    NSRange sourceRange = [originSource rangeOfString:@">"];
    NSString *secondSource = [originSource substringFromIndex:sourceRange.location+1];
    NSString *thirdSource = [secondSource substringToIndex:[secondSource length]-4];
    self.weiboSourceLabel.text = [NSString stringWithFormat:@"来自于%@",thirdSource];
    CGSize weiboSourceLabelSize = [self.weiboSourceLabel.text sizeWithFont:self.weiboSourceLabel.font];
    self.weiboSourceLabel.frame = CGRectMake(self.createdTimeLabel.frame.origin.x+self.createdTimeLabel.frame.size.width+5, self.createdTimeLabel.frame.origin.y, weiboSourceLabelSize.width, weiboSourceLabelSize.height);
    //设置高度
    self.frame = CGRectMake(0, 0, 320, self.weiboSourceLabel.frame.origin.y+self.weiboSourceLabel.frame.size.height+5);
}

//设置高度
- (void)setHeight
{
    
}

//设置该微博内容
- (void)setWeiboContent:(NSDictionary *)weiboContent
{
    if (_weiboContent != weiboContent) {
        _weiboContent = nil;
        _weiboContent = [weiboContent retain];
    }
    [self setWeiboTableViewCell];
}

//微博图片点击
- (void)imageClick:(UITapGestureRecognizer *)tap
{
    if ([tap.view isEqual:self.weiboImage]) {//显示微博的图片
        if ([_delegate respondsToSelector:@selector(imageShowByUrl:)]) {
            [_delegate imageShowByUrl:[self.weiboContent objectForKey:@"original_pic"]];
        }
    } else {//显示转发微博的图片
        if ([_delegate respondsToSelector:@selector(imageShowByUrl:)]) {
            NSDictionary *retweetContent = [self.weiboContent objectForKey:@"retweeted_status"];
            [_delegate imageShowByUrl:[retweetContent objectForKey:@"original_pic"]];
        }
    }
    NSLog(@"%@",tap);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{
    [_weiboSourceLabel release];
    [_createdTimeLabel release];
    [_commentLabel release];
    [_commentImage release];
    [_retweetLabel release];
    [_retweetImage release];
    [_userImage release];
    [_weiboContentLabel release];
    [_userNickName release];
    [_isVIPImage release];
    [_weiboContent release];
    [_delegate release];
    [super dealloc];
}

//点击用户头像
- (void)showUserInfo:(UITapGestureRecognizer *)tap
{
    if ([_delegate respondsToSelector:@selector(userInfoShow:)]) {
        NSDictionary *userInfo = [self.weiboContent objectForKey:@"user"];
        [_delegate userInfoShow:[userInfo objectForKey:@"screen_name"]];
    }
}

#pragma -mark UIWebView Delegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
}

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType
{
//    NSLog(@"shouldStartLoadWithRequest");
    NSString *requestString = [[request URL] absoluteString];
//    NSLog(@"urlString:%@", requestString);
    
    NSArray *urlComps = [requestString componentsSeparatedByString:@"&"];
    
    if ([urlComps count] > 1 && [(NSString *)[urlComps objectAtIndex:1] isEqualToString:@"cmd1"])//@方法
    {
        NSString *str = [[urlComps objectAtIndex:2] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//        NSLog(@"%@", str);
        
        if ([_delegate respondsToSelector:@selector(userInfoShow:)]) {
            [_delegate userInfoShow:str];
        }
        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:str message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alert show];
//        [alert release];
        
        return YES;
    }
    
    if ([urlComps count] > 1 && [(NSString *)[urlComps objectAtIndex:1] isEqualToString:@"cmd2"])//话题方法
    {
        NSString *str = [[urlComps objectAtIndex:2] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//        NSLog(@"%@", str);
        
        if ([_delegate respondsToSelector:@selector(topicShowByTopicContent:)]) {
            [_delegate topicShowByTopicContent:str];
        }
        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:str message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alert show];
//        [alert release];
        
        return YES;
    }
    
    //以下是使用safri打开链接
//    NSURL *requestURL =[ [ request URL ] retain ];
//    if ( ( [ [ requestURL scheme ] isEqualToString: @"http" ] || [ [ requestURL scheme ] isEqualToString: @"https" ] || [ [ requestURL scheme ] isEqualToString: @"mailto" ])
//        && ( navigationType == UIWebViewNavigationTypeLinkClicked ) ) {
//        return ![ [ UIApplication sharedApplication ] openURL: [ requestURL autorelease ] ];
//    }
//    [ requestURL release ];
    
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

@end
