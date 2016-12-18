//
//  ZJAFNRequestTool.h
//  iOSRunTime
//
//  Created by pg on 2016/11/1.
//  Copyright © 2016年 pg. All rights reserved.
//

#import <Foundation/Foundation.h>

///过期提醒
#define PPDeprecated(instead) NS_DEPRECATED(2_0, 2_0, 2_0, 2_0, instead)

/**请求成功的回调 */
typedef void(^RequestSuccessBlock)(NSURLSessionDataTask  *task, id dataResource);
/** 缓存的Block */
typedef void(^RequestCache)(id responseCache);

/**上传文件成功之后的回调 */
typedef void(^UploadMyFileSuccess)(id dataResource);
/**请求失败的回调 */
typedef void(^RequestFailBlock)(NSString *errorStr);

/** 上传或者下载的进度, Progress.completedUnitCount:当前大小 - Progress.totalUnitCount:总大小*/
typedef void (^HttpProgress)(NSProgress *progress);


typedef NS_ENUM(NSUInteger, RequestMethod) {
    RequestMethod_Get  = 1,
    RequestMethod_Post = 2,
    RequestMethod_Put  = 3,
};

@interface ZJAFNRequestTool : NSObject

/**
 设置网络请求的前缀,在delegate中设置一次就可以，也可以根据测试版和正式版分别设置
 */
@property (nonatomic,copy)NSString *resourceURL;

/**
 设置HTTPS请求时的SSL证书，设置一次就可以了
 */
@property (nonatomic,copy)NSString *certificatesName;

/**
 设置网络分享的单例模式
 */
+(instancetype)shareRequestTool;

/*
 * 开启网络监测 YES 有网络  NO 没有联网
 */
+ (void)startMonitoring:(void(^)(BOOL isNet))netBlock;

/*
 * 关闭网络监测
 */
+ (void)stopMonitoring;

/**
 不带缓存的get请求
 @param urlStr       请求的URL
 @param params       请求参数
 @param isShow       显示指示符
 @param successBlock 成功的回调
 @param failBlock    失败的回调
 @return 返回的任务队列
 */
+(NSURLSessionTask*)getWithURL:(NSString*)urlStr
                         param:(NSDictionary*)params
                           hud:(BOOL)isShow
                       success:(RequestSuccessBlock)successBlock
                          fail:(RequestFailBlock)failBlock;


/**
 带有缓存的get请求
 @param urlStr       请求的URL
 @param params       请求参数
 @param isShow       显示指示符
 @param cacheBlock   缓存block
 @param successBlock 成功的回调
 @param failBlock    失败的回调
 @return 返回的任务队列
 */
+(NSURLSessionTask*)getWithURL:(NSString*)urlStr
                         param:(NSDictionary*)params
                           hud:(BOOL)isShow
                         cache:(RequestCache)cacheBlock
                       success:(RequestSuccessBlock)successBlock
                          fail:(RequestFailBlock)failBlock;


/**
 不带缓存的post请求
 @param urlStr       请求的URL
 @param params       请求参数
 @param isShow       显示指示符
 @param successBlock 成功的回调
 @param failBlock    失败的回调
 @return 返回的任务队列
 */
+(NSURLSessionTask*)postWithURL:(NSString*)urlStr
                          param:(NSDictionary*)params
                            hud:(BOOL)isShow
                        success:(RequestSuccessBlock)successBlock
                           fail:(RequestFailBlock)failBlock;



/**
 带有缓存的post请求

 @param urlStr       请求URL
 @param params       请求参数
 @param isShow       是否显示HUD
 @param cacheBlock   缓存block
 @param successBlock 成功block
 @param failBlock    失败block
 @return 返回的任务队列
 */
+(NSURLSessionTask*)postWithURL:(NSString*)urlStr
                          param:(NSDictionary*)params
                            hud:(BOOL)isShow
                          cache:(RequestCache)cacheBlock
                        success:(RequestSuccessBlock)successBlock
                           fail:(RequestFailBlock)failBlock;

/**
 put请求
 @param urlStr       请求的URL
 @param params       请求参数
 @param isShow       显示指示符
 @param successBlock 成功的回调
 @param failBlock    失败的回调
 @return 返回的任务队列
 */
+(NSURLSessionTask*)putWithURL:(NSString*)urlStr
                         param:(NSDictionary*)params
                           hud:(BOOL)isShow
                       success:(RequestSuccessBlock)successBlock
                          fail:(RequestFailBlock)failBlock;

/**
 下载文件
 @param URL      下载地址,下载路径需要填写全地址路径
 @param fileDir  存放地址
 @param progress 下载进度
 @param success  下载成功的回调
 @param failure  失败的回调
 @return 返回的任务队列
 */
+ (NSURLSessionTask *)downloadWithURL:(NSString *)URL
                              fileDir:(NSString *)fileDir
                             progress:(HttpProgress)progress
                              success:(void(^)(NSString *))success
                              failure:(RequestFailBlock)failure;
/**
 *  上传图片文件
 *  @param URL        请求地址
 *  @param parameters 请求参数
 *  @param images     图片数组
 *  @param name       文件对应服务器上的字段
 *  @param fileName   文件名
 *  @param mimeType   图片文件的类型,例:png、jpeg(默认类型)....
 *  @param progress   上传进度信息
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 *
 *  @return 返回的对象可取消请求,调用cancel方法
 */
+ (NSURLSessionTask *)uploadWithURL:(NSString *)URL
                         parameters:(NSDictionary *)parameters
                             images:(NSArray<UIImage *> *)images
                               name:(NSString *)name
                           progress:(HttpProgress)progress
                            success:(UploadMyFileSuccess)success
                            failure:(RequestFailBlock)failure;

/**
 *  取消当前的请求
 */
+(void)cancelRequest;
@end


#pragma mark -网络请求的缓存处理
@interface ZJAFNRequestCache : NSObject

/**
 缓存网络数据，根据请求的URL和parameters
 做KEY存储数据
 @param httpData   服务器返回的数据
 @param URL        请求的URL地址
 @param parameters 请求的参数
 */
+(void)setHttpCache:(id)httpData URL:(NSString*)URL parameters:(NSDictionary*)parameters;


/**
 根据请求的URL和parameters取出缓存数据

 @param URL 请求的URL
 @param parameters 请求的参数
 @return 缓存的服务器数据
 */
+(id)httpCacheForURL:(NSString*)URL parameters:(NSDictionary*)parameters;


/**
 获取网络缓存的总大小
 */
+(NSString*)getAllHttpCacheSize;


/**
 删除所有的网络缓存
 */
+(void)removeAllHttpCache;

@end
































