//
//  UIImage+Color.h
//  IOS-Categories
//
//  Created by Jakey on 14/12/15.
//  Copyright (c) 2014年 www.skyfox.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Color)
/**
 *  根据颜色值生成图片
 *
 *  @param color 添加的颜色值
 *
 *  @return 生成的图片
 */
+ (nullable UIImage*)imageWithColor:(nullable UIColor *)color;


/**
 *  生成一个颜色渐变的背景图
 *
 *  @param colors 传递的颜色值
 *  @param frame  设置图片大小
 *
 *  @return 生成的图片
 */
+ (nullable UIImage*)createGradientImage:(nullable NSArray*)colors withFrame: (CGRect)frame;


/**
 *  利用CAGradientLayer创建颜色渐变的图层
 *
 *  @param colorsArr   颜色数组
 *  @param locationArr 分割点数组
 *  @param startPoint  颜色渐变的起点 (0,0),(0,1)……
 *  @param endPoint    颜色渐变的终点 (0,0),(0,1)……
 *  @param layerFrame  生成的图层的frame
 *
 *  @return 颜色渐变的图层
 */
+ (nullable CAGradientLayer*)createGradientLayer:(nullable NSArray*)colorsArr location:(nullable NSArray*)locationArr start:(CGPoint)startPoint end:(CGPoint)endPoint frame:(CGRect)layerFrame;


/**
 *  图片在某一个点的颜色值
 *
 *  @param point 在图像的那个点
 *
 *  @return 返回的颜色值
 */
- (nullable UIColor *)colorAtPoint:(CGPoint )point;

/**
 *  某一个点的像素
 *
 *  @param point 图像上的点
 *
 *  @return 返回的像素
 */
- (nullable UIColor *)colorAtPixel:(CGPoint)point;

/**
 *  返回该图片是否有透明度通道
 *
 *  @return
 */
- (BOOL)hasAlphaChannel;

/**
 *  获得灰度图
 *
 *  @param UIImage 原图像
 *
 *  @return 返回灰度图
 */
+ (nullable UIImage *)covertToGrayImageFromImage:(nullable UIImage *)sourceImage;

@end
