//
//  ZJCustomRefreshView.m
//  MyOftenUseTool
//
//  Created by DFHZ on 2017/8/15.
//  Copyright © 2017年 zhangjiang. All rights reserved.
//

#import "ZJCustomRefreshView.h"


#define KRefreshViewHeight 60
#define KViewWidth [UIScreen mainScreen].bounds.size.width
typedef NS_ENUM(NSInteger, ZJRefreshState) {
    ZJRefreshStateNormal = 0,     /** 普通状态 */
    ZJRefreshStatePulling,        /** 释放刷新状态 */
    ZJRefreshStateRefreshing,     /** 正在刷新 */
};

@interface ZJCustomRefreshView ()

@property (strong,nonatomic) UIImageView *transImage;

@property (strong,nonatomic) UIScrollView *superScroll;

@property (assign,nonatomic) ZJRefreshState currentState;

@property (assign,nonatomic) CGFloat originalOffSetY;

@property (copy,nonatomic) RefreshBlock myBlock;
//映射调用函数
@property (assign, nonatomic) id refreshTarget;

@property (nonatomic, assign) SEL refreshAction;

@end

@implementation ZJCustomRefreshView

- (instancetype)initWithRefreshBlock:(RefreshBlock)block
{
    self = [super init];
    if (self) {
        self.myBlock = block;
        self.imageName = @"loadDataImage_1";
        [self addTransformImage];
    }
    return self;
}

-(instancetype)initWithTargrt:(id)target refreshAction:(SEL)refreshAction{
    self = [super init];
    if (self) {
        self.refreshAction = refreshAction;
        self.refreshTarget = target;
        self.imageName = @"loadDataImage_1";
        [self addTransformImage];
    }
    return self;
}

//添加图片旋转
-(void)addTransformImage{
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KViewWidth, KRefreshViewHeight)];
    backView.backgroundColor = [UIColor whiteColor];
    [self addSubview:backView];
    
    self.transImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:self.imageName]];
    self.transImage.bounds = CGRectZero;
    self.transImage.center = CGPointMake(KViewWidth/2, KRefreshViewHeight/2);
    [backView addSubview:self.transImage];
}

#pragma mark -设置图片
-(void)setImageName:(NSString *)imageName{
    _imageName = imageName;
    self.transImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:self.imageName]];
}

#pragma mark -添加旋转动画
- (void)loopBasicAnimation{
    //动画
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 1;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = ULLONG_MAX;
    [self.transImage.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

//添加KVO
-(void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    if ([newSuperview isKindOfClass:[UIScrollView class]]) {
        self.superScroll = (UIScrollView*)newSuperview;
        [self.superScroll addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if (self.superScroll.isDragging && !self.isRefreshing){
        if (!self.originalOffSetY) {
            self.originalOffSetY = -self.superScroll.contentOffset.y;
        }
        CGFloat normalPullingOffset = self.originalOffSetY - KRefreshViewHeight;
        if (self.currentState == ZJRefreshStatePulling && self.superScroll.contentOffset.y > normalPullingOffset) {
            self.currentState = ZJRefreshStateNormal;
        }else if (self.currentState == ZJRefreshStateNormal && self.superScroll.contentOffset.y < normalPullingOffset){
            self.currentState = ZJRefreshStatePulling;
        }
    }else if (!self.superScroll.isDragging){
        if (self.currentState == ZJRefreshStatePulling) {
            self.currentState = ZJRefreshStateRefreshing;
        }
    }
    CGFloat offsetY = - self.superScroll.contentOffset.y;
    if (offsetY < KRefreshViewHeight && offsetY > 16) {
        __weak typeof(self) weakSelf = self;
        //开始放缩动画
        CGFloat imageW = offsetY - 16;
        CGFloat centerY = offsetY/2;
        [UIView animateWithDuration:0.01 animations:^{
            weakSelf.transImage.bounds = CGRectMake(0, 0, imageW, imageW);
            CGPoint center = weakSelf.transImage.center;
            center.y = centerY;
            weakSelf.transImage.center = center;
        }];
    }else if(offsetY >= KRefreshViewHeight){
        self.transImage.frame = CGRectMake(KViewWidth/2-22, 8, 44, 44);
    }else{
        self.transImage.bounds = CGRectZero;
    }
}

//设置刷新的状态
-(void)setCurrentState:(ZJRefreshState)currentState{
    _currentState = currentState;
    switch (_currentState) {
        case ZJRefreshStateNormal:
            NSLog(@"normal");
            [self.transImage.layer removeAnimationForKey:@"rotationAnimation"];
            break;
        case ZJRefreshStatePulling:
            [self loopBasicAnimation];
            NSLog(@"Pulling");
            break;
        case ZJRefreshStateRefreshing:
            [self beginRefreshing];
            self.myBlock?self.myBlock():nil;
            [self doRefreshAction];
            NSLog(@"Refreshing");
            break;
    }
}

#pragma mark -开始调用刷新
-(void)doRefreshAction{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    if (self.refreshTarget && [self.refreshTarget respondsToSelector:self.refreshAction]) {
        [self.refreshTarget performSelector:self.refreshAction];
    }
#pragma clang diagnostic pop
}

#pragma mark -开始刷新
- (void)beginRefreshing
{
    [super beginRefreshing];
}

-(void)endRefreshing{
    if (self.currentState != ZJRefreshStateRefreshing) {
        return;
    }
    self.currentState = ZJRefreshStateNormal;
    [super endRefreshing];
    //执行刷新的状态中 用户手动拖动到normal状态的offset ，[super endRefreshing] 无法回到初始位置，所以手动设置
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (weakSelf.superScroll.contentOffset.y >= self.originalOffSetY-KRefreshViewHeight && self.superScroll.contentOffset.y <= weakSelf.originalOffSetY) {
            CGPoint offset = weakSelf.superScroll.contentOffset;
            offset.y = weakSelf.originalOffSetY;
            [weakSelf.superScroll setContentOffset:offset animated:YES];
        }
    });
}

-(void)dealloc{
    [self.superScroll removeObserver:self forKeyPath:@"contentOffset"];
}
@end
