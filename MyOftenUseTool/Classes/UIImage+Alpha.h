// UIImage+Alpha.h
// Created by Trevor Harmon on 9/20/09.
// Free for personal or commercial use, with or without modification.
// No warranty is expressed or implied.

// Helper methods for adding an alpha layer to an image
#import <UIKit/UIKit.h>

@interface UIImage (Alpha)
/**
 *  是否有alpha通道
 */
- (BOOL)hasAlpha;

/**
 *  添加一个alpha通道的图片
 */
- (nullable UIImage *)imageWithAlpha;

/**
 *  图片添加边框
 *
 *  @param borderSize 边框的宽度
 */
- (nullable UIImage *)transparentBorderImage:(NSUInteger)borderSize;
@end
