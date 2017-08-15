//
//  ZJWaveView.h
//  WaterWave
//
//  Created by DFHZ on 2017/7/12.
//  Copyright © 2017年 YingshanDeng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,KWaveType){
    KWaveType_Sin,
    KWaveType_Cos,
};


@interface ZJWaveView : UIView

/**
 sin图层的填充颜色
 */
@property (strong,nonatomic) UIColor *sinFillColor;

/**
 cos图层的填充颜色
 */
@property (strong,nonatomic) UIColor *cosFillColor;


/**
 动画开始
 */
- (void)startDisplayLink;


/**
 动画结束
 */
- (void)stopDisplayLink;



@end
