//
//  WeiboHtmlString.m
//  CMWeibo
//
//  Created by Cameron on 13-4-27.
//  Copyright (c) 2013年 cm. All rights reserved.
//

#import "WeiboHtmlString.h"
#import <Foundation/NSObjCRuntime.h>
#import "RegexKitLite.h"

@implementation WeiboHtmlString

+ (NSString *)transformString:(NSString *)originalStr
{
    NSString *text = [NSString stringWithFormat:@"<style>body{margin:2 0 2;word-wrap:break-word;word-break:break-all;}</style>%@",originalStr];
//    text = originalStr;
    
    //解析http://短链接
    NSString *regex_http = @"[http]+://[a-zA-Z1-9].[a-zA-Z1-9]*/[a-zA-Z1-9]*";//http://短链接正则表达式
    NSArray *array_http = [text componentsMatchedByRegex:regex_http];
    
    if ([array_http count]) {
        for (NSString *str in array_http) {
            NSRange range = [text rangeOfString:str];
            NSString *funUrlStr = [NSString stringWithFormat:@"<a href='%@'>%@</a>",str, str];
            text = [text stringByReplacingCharactersInRange:NSMakeRange(range.location, str.length) withString:funUrlStr];
//            NSLog(@"text:%@", text);
        }
    }
    
    //解析@
    NSString *regex_at = @"@([\u4e00-\u9fa5A-Z0-9a-z_-]+#?)";//@的正则表达式
    
    NSArray *array_at = [text componentsMatchedByRegex:regex_at];
    
    if ([array_at count]) {
        NSMutableArray *test_arr = [[NSMutableArray alloc] init];
        for (NSString *str in array_at) {
            NSRange range = [text rangeOfString:str];
            if (![test_arr containsObject:str]) {
                [test_arr addObject:str];
                NSString *funUrlStr = [NSString stringWithFormat:@"<a href='&cmd1&%@'>%@</a>",str, str];
                text = [text stringByReplacingCharactersInRange:NSMakeRange(range.location, [str length]) withString:funUrlStr];
//                NSLog(@"text:%@", text);
            }
        }
        [test_arr release];
    }
    
    //解析话题
    NSString *regex_pound = @"#([^\\#|.]+)#";//话题的正则表达式
    NSArray *array_pound = [text componentsMatchedByRegex:regex_pound];
    
    if ([array_pound count]) {
        for (NSString *str in array_pound) {
            NSRange range = [text rangeOfString:str];
            NSString *funUrlStr = [NSString stringWithFormat:@"<a href='&cmd2&%@'>%@</a>",str, str];
            text = [text stringByReplacingCharactersInRange:NSMakeRange(range.location, [str length]) withString:funUrlStr];
//            NSLog(@"text:%@", text);
        }
    }
    
    
    
    //解析表情
    NSString *regex_emoji = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";//表情的正则表达式
    NSArray *array_emoji = [text componentsMatchedByRegex:regex_emoji];
    
    NSString *filePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"emotionImage.plist"];
    NSDictionary *m_EmojiDic = [[NSDictionary alloc] initWithContentsOfFile:filePath];
    NSString *path = [NSString stringWithFormat:@"%@", [[NSBundle mainBundle] bundlePath]];
    
    if ([array_emoji count]) {
        for (NSString *str in array_emoji) {
            NSRange range = [text rangeOfString:str];
            NSString *i_transCharacter = [m_EmojiDic objectForKey:str];
            if (i_transCharacter) {
                NSString *imageHtml = [NSString stringWithFormat:@"<img src = 'file://%@/%@' width='24' height='24'>", path, i_transCharacter];
                text = [text stringByReplacingCharactersInRange:NSMakeRange(range.location, [str length]) withString:imageHtml];
            }
        }
    }
    
    
    //返回转义后的字符串
    return text;
}


@end
