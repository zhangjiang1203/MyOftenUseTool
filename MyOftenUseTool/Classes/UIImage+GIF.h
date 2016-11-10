//
//  UIImage+GIF.h
//  LBGIFImage
//
//  Created by Laurin Brandner on 06.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (GIF)

/**
 *  加载动态图
 *
 *  @param name 动态图名称
 */
+ (nullable UIImage *)sd_animatedGIFNamed:(nullable NSString *)name;

/**
 *  加载动态图
 *
 *  @param name 动态图名称
 */
+ (nullable UIImage *)sd_animatedGIFWithData:(nullable NSData *)data;


/**
 *  修改大小
 *
 *  @param size 变成的尺寸
 */
- (nullable UIImage *)sd_animatedImageByScalingAndCroppingToSize:(CGSize)size;

@end
