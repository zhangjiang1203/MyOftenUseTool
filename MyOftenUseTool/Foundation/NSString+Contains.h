//
//  NSString+Contains.h
//  IOS-Categories
//
//  Created by 符现超 on 15/5/9.
//  Copyright (c) 2015年 http://weibo.com/u/1655766025 All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Contains)

#pragma mark -字符串的方法
/**
 *  判断URL中是否包含中文
 */
- (BOOL)isBlankString;

/**
 *  判断URL中是否包含中文
 */
- (BOOL)isContainChinese;

/**
 *  是否包含空格
 */
- (BOOL)isContainBlank;

/**
 *  Unicode编码的字符串转成NSString
 */
- (NSString *)makeUnicodeToString;

/**
 *  是否包含字符
 *
 *  @param set 查看的字符
 */
- (BOOL)containsCharacterSet:(NSCharacterSet *)set;

/**
 *  是否包含另一字符串
 *
 */
- (BOOL)containsString:(NSString *)string;

/**
 *  返回当前的字符数
 */
- (int)wordsCount;

@end
