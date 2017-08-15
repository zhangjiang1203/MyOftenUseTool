//
//  ZJSegmentScrollView.m
//  CroquetBallAPP
//
//  Created by DFHZ on 2017/7/12.
//  Copyright © 2017年 DFHZ. All rights reserved.
//

#import "ZJSegmentScrollView.h"

#define KDefaultColor [UIColor colorWithRed:51/255.0 green:10/255.0 blue:200/255.0 alpha:1]
#define KSelectedColor [UIColor colorWithRed:1 green:0 blue:0 alpha:1]
#define KANIMATION 0.5
@interface ZJSegmentScrollView ()<UIScrollViewDelegate>
{
    CGSize viewSize;
    CGFloat maxWidth;
    NSInteger chooseTag;
}

@property (strong,nonatomic) UIScrollView *myScrollView;

@property (strong,nonatomic) UIView *lineView;

@property (strong,nonatomic) UIButton *selectedBtn;

@end

@implementation ZJSegmentScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        viewSize = frame.size;
        [self initMyScrollViewAndLineView];
    }
    return self;
}


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        viewSize = self.frame.size;
        [self initMyScrollViewAndLineView];
    }
    return self;
}

-(void)initMyScrollViewAndLineView{
    self.myScrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
    self.myScrollView.delegate = self;
    self.myScrollView.showsVerticalScrollIndicator = NO;
    self.myScrollView.showsHorizontalScrollIndicator =NO;
    self.myScrollView.clipsToBounds = YES;
    [self addSubview:self.myScrollView];
    
    self.normalColor = KDefaultColor;
    self.selectedColor = KSelectedColor;
    self.lineHeight = 2;
    self.buttonFont = [UIFont systemFontOfSize:15];
    self.lineWidth = 40;
}

-(void)setNormalColor:(UIColor *)normalColor{
    _normalColor = normalColor;
    [self.myScrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UIButton class]]) {
            [obj setTitleColor:self.normalColor forState:UIControlStateNormal];
        }
    }];
}

-(void)setSelectedColor:(UIColor *)selectedColor{
    _selectedColor = selectedColor;
    [self.myScrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UIButton class]]) {
            [obj setTitleColor:self.selectedColor forState:UIControlStateNormal];
        }
    }];
}

-(void)setLineHeight:(CGFloat)lineHeight{
    _lineHeight = lineHeight;
    CGRect lineFrame = self.lineView.frame;
    lineFrame.origin.y = viewSize.height -lineHeight;
    lineFrame.size.height = _lineHeight;
    self.lineView.frame = lineFrame;
}

-(void)setLineWidth:(CGFloat)lineWidth{
    _lineWidth = lineWidth;
    CGRect lineFrame = self.lineView.frame;
    if (lineFrame.size.width > _lineWidth) {
        lineFrame.origin.x += (lineFrame.size.width -_lineWidth)/2;
    }else{
        lineFrame.origin.x -= (_lineWidth - lineFrame.size.width)/2;
    }
    lineFrame.size.width = _lineHeight;
    self.lineView.frame = lineFrame;
}

-(void)setSegmentTitleArr:(NSArray *)segmentTitleArr{
    _segmentTitleArr = segmentTitleArr;
    //添加按钮
    [self.myScrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UIButton class]]) {
            [obj removeFromSuperview];
        }
    }];
    [self.lineView removeFromSuperview];
    [self addMySegmentButton];
}


-(void)addMySegmentButton{
    //计算当前所有标题的最大长度
    NSMutableArray *widthArr = [NSMutableArray array];
    [self.segmentTitleArr enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat width = [self getSuitSizeWidthWithString:obj fontSize:_buttonFont height:viewSize.height];
        [widthArr addObject:@(width)];
    }];
    
    //拿出标题最大的宽度
    [widthArr enumerateObjectsUsingBlock:^(NSNumber*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (maxWidth < [obj floatValue]) {
            maxWidth = [obj floatValue];
        }
    }];
    maxWidth = maxWidth*widthArr.count > viewSize.width?maxWidth:(viewSize.width/widthArr.count);
    CGFloat contentWidth = maxWidth*widthArr.count;
    _myScrollView.contentSize = CGSizeMake(contentWidth, viewSize.height);
    //开始添加按钮
    [self.segmentTitleArr enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(idx*maxWidth, 0, maxWidth, viewSize.height)];
        button.titleLabel.font = _buttonFont;
        [button setTitle:obj forState:UIControlStateNormal];
        [button setTitleColor:self.normalColor forState:UIControlStateNormal];
        [button setTitleColor:self.selectedColor forState:UIControlStateSelected];
        button.tag = idx + 10;
        [button addTarget:self action:@selector(titleButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.myScrollView addSubview:button];
    }];
    
    self.lineView = [[UIView alloc]initWithFrame:CGRectMake((maxWidth-self.lineWidth)/2, viewSize.height - self.lineHeight, self.lineWidth, self.lineHeight)];
    self.lineView.backgroundColor = self.selectedColor;
    [self.myScrollView addSubview:self.lineView];
    
}

-(void)titleButtonClickAction:(UIButton*)sender{
    
    self.selectedBtn.selected = NO;
    sender.selected = YES;
    self.selectedBtn = sender;
    
    __weak typeof(self) weakself = self;
    __block CGRect lineRect = self.lineView.frame;
    if (chooseTag < sender.tag) {
        lineRect.size.width = CGRectGetMidX(sender.frame)-CGRectGetMidX(lineRect)+self.lineWidth;
        //添加弹性动画
        [UIView animateWithDuration:KANIMATION/2 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:5.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            weakself.lineView.frame = lineRect;
        } completion:^(BOOL finished) {
            lineRect.origin.x = CGRectGetMidX(sender.frame)-weakself.lineWidth/2;
            lineRect.size.width = weakself.lineWidth;
            [UIView animateWithDuration:KANIMATION/2 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:5.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                weakself.lineView.frame = lineRect;
            } completion:nil];
        }];
    }else{
        lineRect.size.width = CGRectGetMidX(lineRect)-CGRectGetMidX(sender.frame)+self.lineWidth;
        lineRect.origin.x = CGRectGetMidX(sender.frame)-self.lineWidth/2.0;
        //添加弹性动画
        [UIView animateWithDuration:KANIMATION/2 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:5.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            weakself.lineView.frame = lineRect;
        } completion:^(BOOL finished) {
            lineRect.size.width = weakself.lineWidth;
            [UIView animateWithDuration:KANIMATION/2 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:5.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                weakself.lineView.frame = lineRect;
            } completion:nil];
        }];
    }
    chooseTag = sender.tag;
    [self setScrollOffset:sender.tag];
}

//设置scrollview的移动位置
- (void)setScrollOffset:(NSInteger)index{
    UIButton *sender = (UIButton*)[self viewWithTag:index];
    CGRect rect = sender.frame;
    float midX = CGRectGetMidX(rect);
    float offset = 0;
    float contentWidth = _myScrollView.contentSize.width;
    float halfWidth = CGRectGetWidth(self.bounds) / 2.0;
    if (midX < halfWidth) {
        offset = 0;
    }else if (midX > contentWidth - halfWidth){
        offset = contentWidth - 2 * halfWidth;
    }else{
        offset = midX - halfWidth;
    }
    [UIView animateWithDuration:KANIMATION animations:^{
        [_myScrollView setContentOffset:CGPointMake(offset, 0) animated:NO];
    }];
}


/**
 *  @brief 计算文字的宽度
 */
-(CGFloat)getSuitSizeWidthWithString:(NSString *)text fontSize:(UIFont*)font height:(float)height{
    
    CGSize constraint = CGSizeMake(MAXFLOAT, height);
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    // 返回文本绘制所占据的矩形空间。
    CGSize contentSize = [text boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    return contentSize.width+10;
}
@end
