//
//  WaveAnimation.m
//  iOSRunTime
//
//  Created by pg on 2016/12/5.
//  Copyright © 2016年 pg. All rights reserved.
//

#import "WaveAnimation.h"

#define KWidth  [UIScreen mainScreen].bounds.size.width
#define KHeight [UIScreen mainScreen].bounds.size.height

#define KSinFillColor [UIColor blueColor]
#define KCosFillColor [UIColor greenColor]

#define KBottomImage  [UIImage imageNamed:@"Resource.bundle/bottom"]
#define KSinImage     [UIImage imageNamed:@"Resource.bundle/blue"]
#define KCosImage     [UIImage imageNamed:@"Resource.bundle/gray"]

typedef NS_ENUM(NSInteger,KWaveType){
    KWaveType_Sin,
    KWaveType_Cos,
};

@interface WaveAnimation ()
{
    //参数设置
    CGFloat frequency;//频率
    CGFloat waveWidth;//波宽
    CGFloat waveHeight;//波高
    CGFloat maxAmplitude;//最大偏移量
}

@property (nonatomic,assign)CGFloat phase;//相位

@property (nonatomic,strong)CADisplayLink *displayLink;

@property (nonatomic,strong)CAShapeLayer *sinShapeLayer;

@property (nonatomic,strong)CAShapeLayer *cosShapeLayer;
//添加的底部 中间 上边的三幅图
@property (nonatomic,strong)UIImageView *bottomImageView;

@property (nonatomic,strong)UIImageView *cosImageView;

@property (nonatomic,strong)UIImageView *sinImageView;

@end

static CGFloat kWavePositionDuration = 5;
static WaveAnimation *animation = nil;

@implementation WaveAnimation

+(instancetype)shareWaveAnimation{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        animation = [[WaveAnimation alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    });
    return  animation;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpMyView];
        self.center = CGPointMake(KWidth*0.5, KHeight*0.5);
    }
    return self;
}

-(void)setUpMyView{
    [_displayLink invalidate];//取消定时器
    
//    [[NSBundle mainBundle]pathForResource:@"Resource.bundle" ofType:nil];
    
    waveWidth = CGRectGetWidth(self.bounds);
    waveHeight = CGRectGetHeight(self.bounds)*0.5;
    self.phase = 0;
    frequency = 0.3;
    maxAmplitude = waveHeight * .3;
    
    //添加layer
    CGRect rect = CGRectMake(0, CGRectGetHeight(self.bounds), self.bounds.size.width, self.bounds.size.height);
    _sinShapeLayer = [CAShapeLayer layer];
    _sinShapeLayer.backgroundColor = [UIColor clearColor].CGColor;
    _sinShapeLayer.fillColor = KSinFillColor.CGColor;
    _sinShapeLayer.frame = rect;
    
    _cosShapeLayer = [CAShapeLayer layer];
    _cosShapeLayer.backgroundColor = [UIColor clearColor].CGColor;
    _cosShapeLayer.fillColor = KCosFillColor.CGColor;
    _cosShapeLayer.frame = rect;
    
    //添加图片
    _bottomImageView = [[UIImageView alloc]initWithFrame:self.bounds];
    _bottomImageView.contentMode = UIViewContentModeScaleAspectFit;
    _bottomImageView.image = KBottomImage;
    [self addSubview:_bottomImageView];
    
    _cosImageView = [[UIImageView alloc]initWithFrame:self.bounds];
    _cosImageView.contentMode = UIViewContentModeScaleAspectFit;
    _cosImageView.image = KCosImage;
    [self addSubview:_cosImageView];
    
    _sinImageView = [[UIImageView alloc]initWithFrame:self.bounds];
    _sinImageView.contentMode = UIViewContentModeScaleAspectFit;
    _sinImageView.image = KSinImage;
    [self addSubview:_sinImageView];
    
    //设置layer
    _sinImageView.layer.mask = _sinShapeLayer;
    _cosImageView.layer.mask = _cosShapeLayer;
}

-(UIBezierPath*)createWavePathWithType:(KWaveType)type{
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGFloat endX = 0;
    for (CGFloat x = 0; x < waveWidth+1; x++) {
        CGFloat y = 0;
        endX = x;
        CGFloat angle = 360.0/waveWidth*(x*M_PI/180.0);
        if (type == KWaveType_Sin) {
            y = maxAmplitude*sinf(angle*frequency+_phase*M_PI/180.0)+maxAmplitude;
        }else{
            y = maxAmplitude*cosf(angle*frequency+_phase*M_PI/180.0)+maxAmplitude;
        }
        x==0?[path moveToPoint:CGPointMake(x, y)]:[path addLineToPoint:CGPointMake(x, y)];
    }
    CGFloat endY = CGRectGetHeight(self.bounds)+10;
    [path addLineToPoint:CGPointMake(endX, endY)];
    [path addLineToPoint:CGPointMake(0, endY)];
    return path;
}

#pragma mark -开始设置动画
+(void)startAnimationToView:(UIView*)view{
    
    WaveAnimation *wave = [WaveAnimation shareWaveAnimation];wave.alpha = 0.0;
    [wave.displayLink invalidate];
    wave.displayLink = [CADisplayLink displayLinkWithTarget:wave selector:@selector(updateMyWaveAnimation)];
    [wave.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    //设置两个图层的显示动画
    CGPoint position = wave.sinShapeLayer.position;
    position.y = position.y - wave.bounds.size.height - 10;
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.fromValue = [NSValue valueWithCGPoint:wave.sinShapeLayer.position];
    animation.duration = kWavePositionDuration;
    animation.toValue = [NSValue valueWithCGPoint:position];
    animation.repeatCount = HUGE_VALF;
    animation.removedOnCompletion = NO;
    [wave.sinShapeLayer addAnimation:animation forKey:@"positionWave"];
    [wave.cosShapeLayer addAnimation:animation forKey:@"positionWave"];
    
    [UIView animateWithDuration:0.5 animations:^{
        wave.alpha = 1.0;
        if (view) {
            [view addSubview:wave];
        }else{
           [[[[UIApplication sharedApplication] delegate] window] addSubview:wave];
        }
    }];
}

-(void)updateMyWaveAnimation{
    
    WaveAnimation *wave = [WaveAnimation shareWaveAnimation];
    wave.phase += 8;
    wave.sinShapeLayer.path = [wave createWavePathWithType:KWaveType_Sin].CGPath;
    wave.cosShapeLayer.path = [wave createWavePathWithType:KWaveType_Cos].CGPath;
}

#pragma mark -停止动画
+(void)stopAnimation{
    WaveAnimation *wave = [WaveAnimation shareWaveAnimation];
    [wave.displayLink invalidate];
    [wave.sinShapeLayer removeAllAnimations];
    [wave.cosShapeLayer removeAllAnimations];
    wave.sinShapeLayer.path = nil;
    wave.cosShapeLayer.path = nil;
    
    [UIView animateWithDuration:0.5 animations:^{
        wave.alpha = 0.0;
    } completion:^(BOOL finished) {
        [wave removeFromSuperview];
    }];
}
@end
