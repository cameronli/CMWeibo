//
//  CustomUtil.h
//  CMWeibo
//
//  Created by Cameron on 13-3-21.
//  Copyright (c) 2013年 cm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomUtil : NSObject

// 获取Document下文件的路径
+ (NSString *)getDocumentPath:(NSString *)fileName;

// 获取Caches下文件的路径
+ (NSString *)getCachesPath:(NSString *)fileName;

// date -> string
+ (NSString *)stringFromDate:(NSDate *)date formate:(NSString *)formate;

// string -> date
+ (NSDate *)dateFromString:(NSString *)str formate:(NSString *)formate;

@end
