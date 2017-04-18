//
//  ZJUpdateAppManager.h
//  MyOftenUseTool
//
//  Created by DFHZ on 2017/4/18.
//  Copyright © 2017年 zhangjiang. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ZJUpdateAppManager : NSObject

/**
 *  版本号
 */
@property(nonatomic,copy) NSString * version;

/**
 *  更新日志
 */
@property(nonatomic,copy)NSString *releaseNotes;

/**
 *  更新时间
 */
@property(nonatomic,copy)NSString *currentVersionReleaseDate;

/**
 *  APPId
 */
@property(nonatomic,copy)NSString *trackId;

/**
 *  bundleId
 */
@property(nonatomic,copy)NSString *bundleId;

/**
 *  AppStore地址
 */
@property(nonatomic,copy)NSString *trackViewUrl;

/**
 *  开发商
 */
@property(nonatomic,copy)NSString *sellerName;

/**
 *  文件大小
 */
@property(nonatomic,copy)NSString *fileSizeBytes;

/**
 *  展示图
 */
@property(nonatomic,strong)NSArray *screenshotUrls;


+(void)checkNewVersionWithAppID:(NSString *)appID control:(UIViewController*)ctrl;

@end
