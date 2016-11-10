//
//  UIButton+countDown.h
//  NetworkEgOc
//
//  Created by iosdev on 15/3/17.
//  Copyright (c) 2015年 iosdev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (CountDown)

/**
 *  按钮设置倒计时
 *
 *  @param timeout    倒计时总时间
 *  @param tittle     文字标题
 *  @param waitTittle 等待显示的文字
 */
-(void)startTime:(NSInteger )timeout title:(nullable NSString *)tittle waitTittle:(nullable NSString *)waitTittle;
@end
