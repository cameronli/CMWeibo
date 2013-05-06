//
//  CustomUtil.m
//  CMWeibo
//
//  Created by Cameron on 13-3-21.
//  Copyright (c) 2013年 cm. All rights reserved.
//

#import "CustomUtil.h"

@implementation CustomUtil

+ (NSString *)getDocumentPath:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    NSString *path = [docDir stringByAppendingPathComponent:fileName];
    return path;
}

+ (NSString *)getCachesPath:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDir = [paths objectAtIndex:0];
    NSString *path = [cachesDir stringByAppendingPathComponent:fileName];
    return path;
}

+ (NSString *)stringFromDate:(NSDate *)date formate:(NSString *)formate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formate];
    NSString *ret = [formatter stringFromDate:date];
    [formatter release];
    return ret;
}

+ (NSDate *)dateFromString:(NSString *)str formate:(NSString *)formate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formate];
    NSDate *ret = [formatter dateFromString:str];
    [formatter release];
    return ret;
}

@end
