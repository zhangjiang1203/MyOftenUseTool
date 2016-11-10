// UIImage+RoundedCorner.h
// Created by Trevor Harmon on 9/20/09.
// Free for personal or commercial use, with or without modification.
// No warranty is expressed or implied.

// Extends the UIImage class to support making rounded corners
#import <UIKit/UIKit.h>
@interface UIImage (RoundedCorner)

/**
 *  返回带有圆角和边框的图片
 *
 *  @param cornerSize 圆角大小
 *  @param borderSize 变宽的宽度
 *
 *  @return 返回之后的图片
 */
- (nullable UIImage *)roundedCornerImage:(NSInteger)cornerSize borderSize:(NSInteger)borderSize;
@end
