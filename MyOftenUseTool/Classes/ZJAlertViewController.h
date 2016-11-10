//
//  ZJAlertViewController.h
//  iOS_Category
//
//  Created by pg on 16/5/16.
//  Copyright © 2016年 YYQ. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^continueBlock )(NSInteger buttonIndex);


@interface ZJAlertViewController : NSObject

/**
 *  设置弹出的alertView，已经适配ios9
 *
 *  @param title             标题
 *  @param message           信息
 *  @param cancelButtonTitle 取消按钮,@"",没有取消按钮
 *  @param otherButtonTitles 其他按钮,@"",没有确定按钮
 *  @param alertBlock        返回的block
 */
+ (void)alertShowTitle:(nullable NSString *)title
               message:(nullable NSString *)message
     cancelButtonTitle:(nullable NSString *)cancelButtonTitle
     otherButtonTitles:(nullable NSString *)otherButtonTitles
                 block:(nullable continueBlock)alertBlock;

@end
