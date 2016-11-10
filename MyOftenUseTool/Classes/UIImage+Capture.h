//
//  UIImage+Capture.h
//  IOS-Categories
//
//  Created by Jakey on 15/1/10.
//  Copyright (c) 2015年 www.skyfox.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Capture)

/**
 *  截取当前视图上的图片
 *
 *  @param view 视图所在的View
 *
 *  @return 返回的图片
 */
+ (nullable UIImage *)captureWithView:(nullable UIView *)view;

/**
 *  截取图片
 *  @return 返回的截取图片
 */
+ (nullable UIImage *)getImageWithSize:(CGRect)myImageRect FromImage:(nullable UIImage *)bigImage;

@end
