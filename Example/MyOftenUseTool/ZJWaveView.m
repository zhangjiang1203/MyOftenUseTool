//
//  ZJWaveView.m
//  WaterWave
//
//  Created by DFHZ on 2017/7/12.
//  Copyright © 2017年 YingshanDeng. All rights reserved.
//

#import "ZJWaveView.h"

@interface ZJWaveView ()
{
    CGFloat viewW;
    CGFloat ViewH;
}

/**
 sin layer
 */
@property (strong,nonatomic) CAShapeLayer *sinLayer;

/**
 cos layer
 */
@property (strong,nonatomic) CAShapeLayer *cosLayer;

/**
 *  重绘定时器
 */
@property (nonatomic, strong) CADisplayLink *displayLink;

/**
 *  水波的高度
 */
@property (nonatomic, assign) CGFloat waterWaveHeight;

/**
 *  Y 轴方向的缩放
 */
@property (nonatomic, assign) CGFloat zoomY;

/**
 *  X 轴方向的平移
 */
@property (nonatomic, assign) CGFloat translateX;

/**
 震动的频率  值越大 震动的越快
 */
@property (assign,nonatomic) CGFloat frequency;

@end


@implementation ZJWaveView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        viewW = frame.size.width;
        ViewH = frame.size.height;
        [self commitMyIniyData];
        [self setUpMyShowLayer];
        [self startDisplayLink];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        viewW = self.frame.size.width;
        ViewH = self.frame.size.height;
        [self commitMyIniyData];
        [self setUpMyShowLayer];
        [self startDisplayLink];
    }
    return self;
}

-(void)setSinFillColor:(UIColor *)sinFillColor{
    _sinFillColor = sinFillColor;
    self.sinLayer.fillColor = _sinFillColor.CGColor;
    self.sinLayer.strokeColor = _sinFillColor.CGColor;
}

-(void)setCosFillColor:(UIColor *)cosFillColor{
    _cosFillColor = cosFillColor;
    self.cosLayer.fillColor = _cosFillColor.CGColor;
    self.cosLayer.strokeColor = _cosFillColor.CGColor;
}

#pragma mark -初始化数据
-(void)commitMyIniyData{
    self.waterWaveHeight = self.frame.size.height/2.0;
    self.zoomY = 6;
    self.translateX = 0;
    self.frequency = 1;
}

#pragma mark -初始化图层
-(void)setUpMyShowLayer{
    self.sinLayer = [CAShapeLayer layer];
    self.sinLayer.fillColor = [UIColor colorWithRed:86/255.0 green:202/255.0 blue:139/255.0 alpha:1].CGColor;
    self.sinLayer.path = [self waterWavePathWithType:KWaveType_Sin];
    self.sinLayer.lineWidth = 0.1;
    self.sinLayer.strokeColor = [UIColor colorWithRed:86/255.0 green:202/255.0 blue:139/255.0 alpha:1].CGColor;;
    [self.layer addSublayer:self.sinLayer];
    
    self.cosLayer = [CAShapeLayer layer];
    self.cosLayer.fillColor = [UIColor colorWithRed:200/255.0 green:40/255.0 blue:30/255.0 alpha:1].CGColor;
    self.cosLayer.path = [self waterWavePathWithType:KWaveType_Cos];
    self.cosLayer.lineWidth = 0.1;
    self.cosLayer.strokeColor = [UIColor colorWithRed:200/255.0 green:40/255.0 blue:30/255.0 alpha:1].CGColor;
    [self.layer addSublayer:self.cosLayer];
}


-(CGPathRef)waterWavePathWithType:(KWaveType)type{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, self.waterWaveHeight)];
    CGFloat y = 0;
    for (float x=0; x<=viewW; x++) {
        if (type == KWaveType_Sin) {
            y = self.zoomY*sinf(self.frequency*x*M_PI/180 - self.translateX* M_PI/180.0)+self.waterWaveHeight;
        }else{
            y = self.zoomY*cosf(self.frequency*x*M_PI/180 - self.translateX* M_PI/180.0)+self.waterWaveHeight+5;
        }
        [path addLineToPoint:CGPointMake(x, y)];
    }
    [path addLineToPoint:CGPointMake(viewW, ViewH)];
    [path addLineToPoint:CGPointMake(0, ViewH)];
    [path addLineToPoint:CGPointMake(0, self.waterWaveHeight)];
    [path closePath];
    return path.CGPath;
}

#pragma mark -开始添加动画
-(void)updateMyWaveAnimation{
    self.translateX += 5;
    if (self.zoomY <= 10 &&self.zoomY >=6) {
        self.zoomY += 0.02;
    }else{
        self.zoomY -= 0.02;
    }
    self.sinLayer.path = [self waterWavePathWithType:KWaveType_Sin];
    self.cosLayer.path = [self waterWavePathWithType:KWaveType_Cos];
}

#pragma mark -定时器开启和关闭
- (void)startDisplayLink
{
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateMyWaveAnimation)];
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)stopDisplayLink
{
    [self.displayLink invalidate];
    self.displayLink = nil;
}

@end
