//
//  ZJAFNRequestTool.h
//  iOSRunTime
//
//  Created by pg on 2016/11/1.
//  Copyright © 2016年 pg. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^RequestSuccessBlock)(NSURLSessionDataTask  *task, id dataResource);
typedef void(^RequestFailBlock)(NSString *errorStr);

typedef NS_ENUM(NSUInteger, RequestMethod) {
    RequestMethod_Get  = 1,
    RequestMethod_Post = 2,
    RequestMethod_Put  = 3,
};

@interface ZJAFNRequestTool : NSObject


/**
 设置网络请求的前缀,在delegate中设置一边就可以，也可以根据测试版和正式版分别设置
 */
@property (nonatomic,copy)NSString *resourceURL;

/**
 设置网络分享的单例模式
 */
+(instancetype)shareRequestTool;


/*
 * 开启网络监测
 */
+ (void)startMonitoring;
/*
 * 关闭网络监测
 */
+ (void)stopMonitoring;

/**
 get请求

 @param urlStr       请求的URL
 @param params       请求参数
 @param successBlock 成功的回调
 @param failBlock    失败的回调

 @return 返回的任务队列
 */
+(NSURLSessionTask*)getWithURL:(NSString*)urlStr param:(NSDictionary*)params success:(RequestSuccessBlock)successBlock fail:(RequestFailBlock)failBlock;


/**
 post请求
 
 @param urlStr       请求的URL
 @param params       请求参数
 @param successBlock 成功的回调
 @param failBlock    失败的回调
 
 @return 返回的任务队列
 */
+(NSURLSessionTask*)postWithURL:(NSString*)urlStr param:(NSDictionary*)params success:(RequestSuccessBlock)successBlock fail:(RequestFailBlock)failBlock;


/**
 put请求
 
 @param urlStr       请求的URL
 @param params       请求参数
 @param successBlock 成功的回调
 @param failBlock    失败的回调
 
 @return 返回的任务队列
 */
+(NSURLSessionTask*)putWithURL:(NSString*)urlStr param:(NSDictionary*)params success:(RequestSuccessBlock)successBlock fail:(RequestFailBlock)failBlock;


/**
 *  取消当前的请求
 */
+(void)cancelRequest;
@end
