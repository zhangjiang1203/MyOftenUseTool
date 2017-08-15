//
//  ZJSegmentScrollView.h
//  CroquetBallAPP
//
//  Created by DFHZ on 2017/7/12.
//  Copyright © 2017年 DFHZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJSegmentScrollView : UIView


/**
 设置字体
 */
@property (strong,nonatomic) UIFont *buttonFont;

/**
 设置默认颜色
 */
@property (strong,nonatomic) UIColor *normalColor;

/**
 设置选中颜色
 */
@property (strong,nonatomic) UIColor *selectedColor;

/**
 横线的高度
 */
@property (assign,nonatomic) CGFloat lineHeight;


/**
 横线的宽度
 */
@property (assign,nonatomic) CGFloat lineWidth;

/**
 显示的文本数组
 */
@property (strong,nonatomic) NSArray<NSString*> *segmentTitleArr;

@end
