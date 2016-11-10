//
//  NSString+RemoveEmoji.h
//  NSString+RemoveEmoji
//
//  Created by Jakey on 15/5/13.
//  Copyright (c) 2015年 Jakey. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface NSString (RemoveEmoji)

- (BOOL)isIncludingEmoji;

- (instancetype)removedEmojiString;

/**
 *  移除html标签
 *
 *  @param html html description
 *
 *  @return return value description
 */
- (NSString *)removeHTML2:(NSString *)html;

@end
