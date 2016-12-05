//
//  WaveAnimation.h
//  iOSRunTime
//
//  Created by pg on 2016/12/5.
//  Copyright © 2016年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WaveAnimation : UIView

#pragma mark -开始和暂停动画
+(void)startAnimationToView:(UIView*)view;


+(void)stopAnimation;

@end
