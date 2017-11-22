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
typedef void(^RequestSuccessBlock)(id responseObject);
/** 缓存的Block */
typedef void(^RequestCache)(id responseCache);

/**请求失败的回调 */
typedef void(^RequestFailBlock)(NSString *errorStr);

/**上传文件成功之后的回调 */
typedef void(^UploadMyFileSuccess)(id dataResource);


/** 上传或者下载的进度, Progress.completedUnitCount:当前大小 - Progress.totalUnitCount:总大小*/
typedef void (^HttpProgress)(NSProgress *progress);


typedef NS_ENUM(NSUInteger, RequestMethod) {
    RequestMethod_Get    = 1,
    RequestMethod_Post   = 2,
    RequestMethod_Put    = 3,
    RequestMethod_Delete = 4,
};


typedef NS_ENUM(NSUInteger, ZJRequestSerializer) {
    /** 设置请求数据为JSON格式*/
    ZJRequestSerializerJSON = 1,
    /** 设置请求数据为二进制格式*/
    ZJRequestSerializerHTTP = 2,
};

typedef NS_ENUM(NSUInteger, ZJResponseSerializer) {
    /** 设置响应数据为JSON格式*/
    ZJResponseSerializerJSON = 1,
    /** 设置响应数据为二进制格式*/
    ZJResponseSerializerHTTP = 2,
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
 *  设置网络请求参数的格式:默认为二进制格式
 *
 *  @param requestSerializer ZJRequestSerializerJSON(JSON格式),ZJRequestSerializerHTTP(二进制格式),
 */
+ (void)setRequestSerializer:(ZJRequestSerializer)requestSerializer;

/**
 *  设置服务器响应数据格式:默认为JSON格式
 *
 *  @param responseSerializer ZJResponseSerializerJSON(JSON格式),ZJResponseSerializerHTTP(二进制格式)
 */
+ (void)setResponseSerializer:(ZJResponseSerializer)responseSerializer;

/**
 *  设置请求超时时间:默认为30S
 *
 *  @param time 时长
 */
+ (void)setRequestTimeoutInterval:(NSTimeInterval)time;

/**
 *  设置请求头
 */
+ (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field;

/**
 *  是否打开网络状态转圈菊花:默认打开
 *
 *  @param open YES(打开), NO(关闭)
 */
+ (void)openNetworkActivityIndicator:(BOOL)open;


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
 put 请求有缓存

 @param urlStr 请求的URL
 @param params 请求参数
 @param isShow 显示指示符
 @param cacheBlock 缓存回调
 @param successBlock 成功的回调
 @param failBlock 失败的回调
 @return 返回的任务队列
 */
+(NSURLSessionTask*)putWithURL:(NSString*)urlStr
                          param:(NSDictionary*)params
                            hud:(BOOL)isShow
                          cache:(RequestCache)cacheBlock
                        success:(RequestSuccessBlock)successBlock
                           fail:(RequestFailBlock)failBlock;



/**
 delete请求

 @param urlStr 请求的URL
 @param params 请求参数
 @param isShow 显示指示符
 @param successBlock 成功的回调
 @param failBlock 失败的回调
 @return 返回的任务队列
 */
+(NSURLSessionTask*)deleteWithURL:(NSString*)urlStr
                         param:(NSDictionary*)params
                           hud:(BOOL)isShow
                       success:(RequestSuccessBlock)successBlock
                          fail:(RequestFailBlock)failBlock;


/**
 delete请求 带缓存
 
 @param urlStr 请求的URL
 @param params 请求参数
 @param isShow 显示指示符
 @param cacheBlock 缓存回调
 @param successBlock 成功的回调
 @param failBlock 失败的回调
 @return 返回的任务队列
 */
+(NSURLSessionTask*)deleteWithURL:(NSString*)urlStr
                            param:(NSDictionary*)params
                              hud:(BOOL)isShow
                            cache:(RequestCache)cacheBlock
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
 *  上传多个图片文件
 *  @param URL        请求地址
 *  @param parameters 请求参数
 *  @param images     图片数组
 *  @param progress   上传进度信息
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 *
 *  @return 返回的对象可取消请求,调用cancel方法
 */
+ (NSURLSessionTask *)uploadMultipleImageWithURL:(NSString *)URL
                                      parameters:(NSDictionary *)parameters
                                          images:(NSArray<UIImage *> *)images
                                        progress:(HttpProgress)progress
                                         success:(UploadMyFileSuccess)success
                                         failure:(RequestFailBlock)failure;


/**
 上传单张图片

 @param URL 请求地址
 @param parameters 请求参数
 @param image 上传的图片
 @param progress 上传进度信息
 @param success 请求成功的回调
 @param failure 请求失败的回调
 @return 返回的可取消请求
 */
+ (NSURLSessionTask *)uploadSignalImageWithURL:(NSString*)URL
                                    parameters:(NSDictionary *)parameters
                                        images:(UIImage*)image
                                      progress:(HttpProgress)progress
                                       success:(UploadMyFileSuccess)success
                                       failure:(RequestFailBlock)failure;

/**
 *  取消所有的请求
 */
+(void)cancelAllRequest;

/**
 *  根据指定的URL取消请求
 */
+ (void)cancelRequestWithURL:(NSString *)URL;
@end

