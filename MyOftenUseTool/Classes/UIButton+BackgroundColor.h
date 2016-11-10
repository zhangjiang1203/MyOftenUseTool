//
//  UIButton+BackgroundColor.h
//  IOS-Categories
//
//  Created by 符现超 on 15/5/9.
//  Copyright (c) 2015年 http://weibo.com/u/1655766025 All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (BackgroundColor)

/**
 *  根据状态设置button的背景颜色
 *
 *  @param backgroundColor 添加的颜色值
 *  @param state           按钮的状态
 */
- (void)setBackgroundColor:(nullable UIColor *)backgroundColor forState:(UIControlState)state;
@end
