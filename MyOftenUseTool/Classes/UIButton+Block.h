//
//  UIButton+Block.h
//  IOS-Categories
//
//  Created by Jakey on 14/12/30.
//  Copyright (c) 2014年 www.skyfox.org. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^TouchedBlock)(NSInteger tag);

@interface UIButton (Block)
/**
 *  按钮的touchupinside触发方法的Block回调
 *
 *  @param touchHandler 点击的按钮的tag值
 */
-(void)addActionHandler:(TouchedBlock)touchHandler;
@end
