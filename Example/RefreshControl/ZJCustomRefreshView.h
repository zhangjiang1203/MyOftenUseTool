//
//  ZJCustomRefreshView.h
//  MyOftenUseTool
//
//  Created by DFHZ on 2017/8/15.
//  Copyright © 2017年 zhangjiang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^RefreshBlock)();

@interface ZJCustomRefreshView : UIRefreshControl

/**
 设置旋转图片名
 */
@property (copy,nonatomic) NSString *imageName;

/**
 block方式回调

 @param Block 回调block
 @return 对象实例
 */
-(instancetype)initWithRefreshBlock:(RefreshBlock)Block;

/**
 映射返回

 @param target 当前target
 @param refreshAction 调用函数名
 @return 返回实例对象
 */
- (instancetype)initWithTargrt:(id)target refreshAction:(SEL)refreshAction;

/**
 结束刷新
 */
-(void)endRefreshing;

@end
