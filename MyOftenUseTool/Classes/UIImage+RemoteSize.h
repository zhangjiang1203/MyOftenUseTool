//
//  UIImage+RemoteSize.h
//  IOS-Categories
//
//  Created by Jakey on 15/1/27.
//  Copyright (c) 2015年 www.skyfox.org. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^UIImageSizeRequestCompleted) (NSURL* imgURL, CGSize size);

@interface UIImage (RemoteSize)

/**
 *  返回网络图片的尺寸，带有header
 *
 *  @param imgURL     图片地址
 *  @param completion 返回的数据
 */
+ (void)requestSizeNoHeader:(NSURL*)imgURL completion:(UIImageSizeRequestCompleted)completion;


/**
 *  返回网络图片的尺寸，不带header
 *
 *  @param imgURL     图片地址
 *  @param completion 返回的数据
 */
//+ (void)requestSizeWithHeader:(NSURL*)imgURL completion:(UIImageSizeRequestCompleted)completion;

@end