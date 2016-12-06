//
//  WaveAnimation.h
//  iOSRunTime
//
//  Created by pg on 2016/12/5.
//  Copyright © 2016年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WaveAnimation : UIView

/**
 开始加载显示视图 nil为空的时候显示在rootView的window上
 */
+(void)startAnimationToView:(UIView*)view;


/**
 停止显示视图
 */
+(void)stopAnimation;

@end
