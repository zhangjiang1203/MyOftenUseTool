//
//  UIImage+Merge.h
//  IOS-Categories
//
//  Created by Jakey on 14/12/30.
//  Copyright (c) 2014年 www.skyfox.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Merge)

/**
 *  合并图片
 *
 *  @param firstImage  第一张图片
 *  @param secondImage 第二章图片
 *
 *  @return 返回的合成图  
 */
+ (nullable UIImage *)mergeImage:(nullable UIImage *)firstImage withImage:(nullable UIImage *)secondImage;
@end
