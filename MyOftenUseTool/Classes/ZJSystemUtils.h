//
//  ZJSystemUtils.h
//  MyOftenUseTool
//
//  Created by pg on 2016/11/16.
//  Copyright © 2016年 zhangjiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZJSystemUtils : NSObject

/**
 *  手机型号  “iPhone 5”,“iPhone 4S”,"iPhone 4"
 */
+(NSString*)deviceString;
/**
 *  获取ip地址
 */
+(NSString *)getIPAddress;
/**
 *  是否有摄像头使用权限
 *
 *  @param authorized 有权限回调
 *  @param restricted 无权限回调
 */
+(void)videoAuthorizationStatusAuthorized:(void(^)(void))authorized restricted:(void(^)(void))restricted;
/**
 *  获取当前的显示的ViewController
 *
 *  @return 当前的显示的ViewController
 */
+ (UIViewController *)getCurrentViewController;

/**
 *  获取当前版本号
 */
+(NSString*)getCurrentVersion;

/**
 *  获取历史存储的版本号
 */
+(NSString*)getHistoryVersion;

/**
 设置登录状态 0 退出登录  1 登录成功
 */
+(void)setLoginState:(BOOL)state;

/**
 获取登录状态 0 没有登录 1 登录
 */
+(BOOL)getLoginState;


/**
 *  判断是不是第一次登陆
 */
+(BOOL)judgeIsFirstLogin;


/**
 *  存储登录账号的用户名和密码
 */
+(void)saveUserAccount:(NSString*)account password:(NSString*)password;

/**
 *  获取用户密码
 */
+(NSString*)getUserPassword;

/**
 *  获取用户账号
 */
+(NSString*)getUserAccount;

/**
 *  获取设备标示
 */
+(NSString *)getDiviceIdentifier;

#pragma mark -应用程序需要事先申请音视频使用权限
+ (BOOL)requestMediaCapturerAccessWithCompletionHandler:(void (^)(BOOL value, NSError *error))handler;

/**
 *  检查app是否有照片操作权限
 */
+(void)getAssetsAuthorizationStatus:(void (^)(BOOL isAuthorize,NSString *errorStr))authorizeBlock;

@end
