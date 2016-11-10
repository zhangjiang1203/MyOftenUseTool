//
//  UIImage+FileName.h
//  IOS-Categories
//
//  Created by Jakey on 14/12/15.
//  Copyright (c) 2014年 www.skyfox.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (FileName)

/**
 *  根据文件名查找图片
 *
 *  @param name 图片名
 *
 *  @return 返回图片
 */
+ (nullable UIImage *)imageWithFileName:(nullable NSString *)name;

@end
