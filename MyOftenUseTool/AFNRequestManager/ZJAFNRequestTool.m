//
//  ZJAFNRequestTool.m
//  iOSRunTime
//
//  Created by pg on 2016/11/1.
//  Copyright © 2016年 pg. All rights reserved.
//

#import "ZJAFNRequestTool.h"
#import "AFNetworking.h"
#import <AFNetworking/AFNetworkActivityIndicatorManager.h>
#import "SVProgressHUD.h"
#import "ZJNetCacheManager.h"

@interface ZJAFNRequestTool ()

@property (nonatomic,assign) AFNetworkReachabilityStatus workStatus;

@property (strong,nonatomic) NSMutableArray *sessionTaskArr;

@end

@implementation ZJAFNRequestTool

static AFHTTPSessionManager *_manager;

+ (void)startMonitoring:(void(^)(BOOL isNet))netBlock{
    
    [[AFNetworkReachabilityManager sharedManager]startMonitoring];
    [[AFNetworkReachabilityManager sharedManager]setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        [ZJAFNRequestTool shareRequestTool].workStatus = status;
        if (status == AFNetworkReachabilityStatusNotReachable) {
            //跳转到设置URL的地方
            netBlock(NO);
        }else{
            netBlock(YES);
        }
    }];
}

+(void)stopMonitoring{
    [[AFNetworkReachabilityManager sharedManager]stopMonitoring];
}

#pragma mark -创建单例
+(instancetype)shareRequestTool{
    static ZJAFNRequestTool *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ZJAFNRequestTool alloc]init];
    });
    return manager;
}

//initialize该初始化方法在当用到此类时候只调用一次
+(void)initialize{
    _manager = [AFHTTPSessionManager manager];
    //设置请求的超时时间
    _manager.requestSerializer.timeoutInterval = 30.f;
//    _manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    //设置服务器返回结果的类型:JSON (AFJSONResponseSerializer,AFHTTPResponseSerializer)
    _manager.responseSerializer = [AFJSONResponseSerializer serializer];
    _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/plain", @"text/javascript", @"text/xml", @"image/*", nil];
    // 打开状态栏的等待菊花
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
}

+ (void)setRequestSerializer:(ZJRequestSerializer)requestSerializer {
    _manager.requestSerializer = requestSerializer==ZJRequestSerializerHTTP ? [AFHTTPRequestSerializer serializer] : [AFJSONRequestSerializer serializer];
}

+ (void)setResponseSerializer:(ZJResponseSerializer)responseSerializer {
    _manager.responseSerializer = responseSerializer==ZJResponseSerializerHTTP ? [AFHTTPResponseSerializer serializer] : [AFJSONResponseSerializer serializer];
}

+ (void)setRequestTimeoutInterval:(NSTimeInterval)time {
    _manager.requestSerializer.timeoutInterval = time;
}

+ (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field {
    [_manager.requestSerializer setValue:value forHTTPHeaderField:field];
}

+ (void)openNetworkActivityIndicator:(BOOL)open {
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:open];
}

- (AFSecurityPolicy*)customSecurityPolicy
{
    // /先导入证书
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:_certificatesName ofType:@".cer"];//证书的路径
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    NSSet *set = [NSSet setWithObjects:certData, nil];
    // AFSSLPinningModeCertificate 使用证书验证模式
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    // 如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    //validatesDomainName 是否需要验证域名，默认为YES；
    //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    //如置为NO，建议自己添加对应域名的校验逻辑。
    securityPolicy.validatesDomainName = NO;
    [securityPolicy setPinnedCertificates:set];
    return securityPolicy;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        //加载错误信息提示
        self.sessionTaskArr = [NSMutableArray array];
    }
    return self;
}

-(NSURLSessionTask*)httpRequestMethod:(RequestMethod)requestMethod source:(NSString*)sourceURL param:(NSDictionary*)params hud:(BOOL)isShow cache:(RequestCache)cacheBlock success:(RequestSuccessBlock)successBlock fail:(RequestFailBlock)failBlock{

    //https SSL验证
    if (self.certificatesName) {
        [_manager setSecurityPolicy:[self customSecurityPolicy]];
    }
    if (isShow) {
        [SVProgressHUD show];
    }
    //拼接URL
    NSString *requestURL = [NSString stringWithFormat:@"%@%@",_resourceURL,sourceURL];
    cacheBlock?[ZJNetCacheManager getHttpCacheWithURL:requestURL params:params withBlock:^(id<NSCoding> object) {
        cacheBlock(object);
        [SVProgressHUD dismiss];
    }]:nil;
    
    NSURLSessionDataTask *httpDataTask;
    switch (requestMethod) {
        case RequestMethod_Get:
        {
             httpDataTask = [_manager GET:requestURL parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [SVProgressHUD dismiss];
                //设置缓存保存缓存数据
                [_sessionTaskArr removeObject:task];
                successBlock?successBlock(responseObject):nil;
                        //设置缓存保存缓存数据
                cacheBlock?[ZJNetCacheManager setHttpCache:responseObject URL:requestURL params:params]:nil;
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [SVProgressHUD dismiss];
                [_sessionTaskArr removeObject:task];
                if (failBlock) {
                    failBlock(error.description);
                }
            }];
        }
            break;
        case RequestMethod_Post:
        {
            httpDataTask = [_manager POST:requestURL parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [SVProgressHUD dismiss];
                [_sessionTaskArr removeObject:task];
                successBlock?successBlock(responseObject):nil;
                        //设置缓存保存缓存数据
                cacheBlock?[ZJNetCacheManager setHttpCache:responseObject URL:requestURL params:params]:nil;
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [SVProgressHUD dismiss];
                [_sessionTaskArr removeObject:task];
                if (failBlock) {
                    failBlock(error.description);
                }
            }];
        }
            break;
        case RequestMethod_Put:
        {
            httpDataTask = [_manager PUT:requestURL parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [SVProgressHUD dismiss];
                [_sessionTaskArr removeObject:task];
                if (successBlock) {
                    successBlock(responseObject);
                }
                //设置缓存保存缓存数据
                //设置缓存保存缓存数据
                cacheBlock?[ZJNetCacheManager setHttpCache:responseObject URL:requestURL params:params]:nil;
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [SVProgressHUD dismiss];
                [_sessionTaskArr removeObject:task];
                if (failBlock) {
                    failBlock(error.description);
                }
            }];
        }
            break;
            case RequestMethod_Delete:
        {
            httpDataTask = [_manager DELETE:requestURL parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [SVProgressHUD dismiss];
                [_sessionTaskArr removeObject:task];
                if (successBlock) {
                    successBlock(responseObject);
                }
                //设置缓存保存缓存数据
                //设置缓存保存缓存数据
                cacheBlock?[ZJNetCacheManager setHttpCache:responseObject URL:requestURL params:params]:nil;
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [SVProgressHUD dismiss];
                [_sessionTaskArr removeObject:task];
                if (failBlock) {
                    failBlock(error.description);
                }
            }];
        }
            break;
    }
    // 添加sessionTask到数组
    httpDataTask ? [[ZJAFNRequestTool shareRequestTool].sessionTaskArr addObject:httpDataTask] : nil ;
    return httpDataTask;
}

+(NSURLSessionTask *)getWithURL:(NSString *)urlStr param:(NSDictionary *)params hud:(BOOL)isShow success:(RequestSuccessBlock)successBlock fail:(RequestFailBlock)failBlock{
    return [self getWithURL:urlStr param:params hud:isShow cache:nil success:successBlock fail:failBlock];
}


+(NSURLSessionTask *)getWithURL:(NSString *)urlStr param:(NSDictionary *)params hud:(BOOL)isShow cache:(RequestCache)cacheBlock success:(RequestSuccessBlock)successBlock fail:(RequestFailBlock)failBlock{
    return [[ZJAFNRequestTool shareRequestTool] httpRequestMethod:RequestMethod_Get source:urlStr param:params hud:isShow cache:cacheBlock success:^(id dataResource) {
        successBlock(dataResource);
    } fail:failBlock];

}


+(NSURLSessionTask *)postWithURL:(NSString *)urlStr param:(NSDictionary *)params hud:(BOOL)isShow success:(RequestSuccessBlock)successBlock fail:(RequestFailBlock)failBlock{
    return [self postWithURL:urlStr param:params hud:isShow cache:nil success:successBlock fail:failBlock];
}

+(NSURLSessionTask *)postWithURL:(NSString *)urlStr param:(NSDictionary *)params hud:(BOOL)isShow cache:(RequestCache)cacheBlock success:(RequestSuccessBlock)successBlock fail:(RequestFailBlock)failBlock{
    return [[ZJAFNRequestTool shareRequestTool]httpRequestMethod:RequestMethod_Post source:urlStr param:params hud:isShow cache:cacheBlock success:^( id dataResource) {
        successBlock(dataResource);
    } fail:failBlock];
}

+(NSURLSessionTask *)putWithURL:(NSString *)urlStr param:(NSDictionary *)params hud:(BOOL)isShow success:(RequestSuccessBlock)successBlock fail:(RequestFailBlock)failBlock{
    return [[ZJAFNRequestTool shareRequestTool]httpRequestMethod:RequestMethod_Put source:urlStr param:params hud:isShow cache:nil success:^(id dataResource) {
        successBlock(dataResource);
    } fail:failBlock];
}

+(NSURLSessionTask *)putWithURL:(NSString *)urlStr param:(NSDictionary *)params hud:(BOOL)isShow cache:(RequestCache)cacheBlock success:(RequestSuccessBlock)successBlock fail:(RequestFailBlock)failBlock{
    return [[ZJAFNRequestTool shareRequestTool]httpRequestMethod:RequestMethod_Put source:urlStr param:params hud:isShow cache:cacheBlock success:successBlock fail:failBlock];
}


+(NSURLSessionTask *)deleteWithURL:(NSString *)urlStr param:(NSDictionary *)params hud:(BOOL)isShow success:(RequestSuccessBlock)successBlock fail:(RequestFailBlock)failBlock{
    return [[ZJAFNRequestTool shareRequestTool]httpRequestMethod:RequestMethod_Delete source:urlStr param:params hud:isShow cache:nil success:successBlock fail:failBlock];
}

+(NSURLSessionTask *)deleteWithURL:(NSString *)urlStr param:(NSDictionary *)params hud:(BOOL)isShow cache:(RequestCache)cacheBlock success:(RequestSuccessBlock)successBlock fail:(RequestFailBlock)failBlock{
    return [[ZJAFNRequestTool shareRequestTool]httpRequestMethod:RequestMethod_Delete source:urlStr param:params hud:isShow cache:cacheBlock success:successBlock fail:failBlock];
}

#pragma mark - 下载文件
+ (NSURLSessionTask *)downloadWithURL:(NSString *)URL
                              fileDir:(NSString *)fileDir
                             progress:(HttpProgress)progress
                              success:(void(^)(NSString *))success
                              failure:(RequestFailBlock)failure
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URL]];
    NSURLSessionDownloadTask *downloadTask = [_manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
        //下载进度
        dispatch_sync(dispatch_get_main_queue(), ^{
            progress ? progress(downloadProgress) : nil;
        });
        NSLog(@"下载进度:%.2f%%",100.0*downloadProgress.completedUnitCount/downloadProgress.totalUnitCount);
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        //拼接缓存目录
        NSString *downloadDir = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:fileDir ? fileDir : @"Download"];
        //打开文件管理器
        NSFileManager *fileManager = [NSFileManager defaultManager];
        //创建Download目录
        [fileManager createDirectoryAtPath:downloadDir withIntermediateDirectories:YES attributes:nil error:nil];
        //拼接文件路径
        NSString *filePath = [downloadDir stringByAppendingPathComponent:response.suggestedFilename];
        NSLog(@"downloadDir = %@",downloadDir);
        //返回文件位置的URL路径
        return [NSURL fileURLWithPath:filePath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if(failure && error) {failure(error.description) ; return ;};
        success ? success(filePath.absoluteString /** NSURL->NSString*/) : nil;
    }];
    //开始下载
    [downloadTask resume];
    downloadTask ? [[ZJAFNRequestTool shareRequestTool].sessionTaskArr addObject:downloadTask] : nil ;
    return downloadTask;
}

//上传单张图片
+(NSURLSessionTask *)uploadSignalImageWithURL:(NSString *)URL
                                   parameters:(NSDictionary *)parameters
                                       images:(UIImage *)image
                                     progress:(HttpProgress)progress
                                      success:(UploadMyFileSuccess)success
                                      failure:(RequestFailBlock)failure{
    
    NSURLSessionTask *uploadTask = [_manager POST:URL parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSDate *date = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy/MM/dd/hh/mm/ss"];
        NSString *dateString = [formatter stringFromDate:date];
        NSData *imageData;
        if (UIImagePNGRepresentation(image) == nil)
        {
            imageData = UIImageJPEGRepresentation(image, 1.0);
            if (imageData.length/1024 > 1024) {
                imageData = UIImageJPEGRepresentation(image, 0.5);
            }
        }else{
            imageData = UIImagePNGRepresentation(image);
        }
        [formData appendPartWithFileData:imageData name:@"updateFile" fileName:[NSString stringWithFormat:@"%@",dateString] mimeType:@"image/jpg/png/jpeg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        progress?progress(uploadProgress):nil;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success ? success(responseObject) : nil;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure ? failure(error.description) : nil;
    }];
    
    uploadTask ? [[ZJAFNRequestTool shareRequestTool].sessionTaskArr addObject:uploadTask] : nil ;
    
    return uploadTask;
    
    
}

#pragma mark - 上传多张图片文件
+ (NSURLSessionTask *)uploadMultipleImageWithURL:(NSString *)URL
                                      parameters:(NSDictionary *)parameters
                                          images:(NSArray<UIImage *> *)images
                                        progress:(HttpProgress)progress
                                         success:(UploadMyFileSuccess)success
                                         failure:(RequestFailBlock)failure
{
        NSURLSessionTask *sessionTask = [_manager POST:URL parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //根据当前系统时间生成图片名称
        NSDate *date = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy/MM/dd/hh/mm/ss"];
        NSString *dateString = [formatter stringFromDate:date];
        //压缩-添加-上传图片
        [images enumerateObjectsUsingBlock:^(UIImage * _Nonnull image, NSUInteger idx, BOOL * _Nonnull stop) {
            NSData *imageData;
            if (UIImagePNGRepresentation(image) == nil)
            {
                imageData = UIImageJPEGRepresentation(image, 1.0);
                if (imageData.length/1024 > 1024) {
                    imageData = UIImageJPEGRepresentation(image, 0.5);
                }
            }else{
                imageData = UIImagePNGRepresentation(image);
            }
            
            [formData appendPartWithFileData:imageData name:[NSString stringWithFormat:@"updateFile_%zd",idx] fileName:[NSString stringWithFormat:@"%@_%zd",dateString,idx] mimeType:@"image/jpg/png/jpeg"];
        }];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        //上传进度
        //        dispatch_sync(dispatch_get_main_queue(), ^{
        progress ? progress(uploadProgress) : nil;
        //        });
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success ? success(responseObject) : nil;
        NSLog(@"responseObject = %@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failure ? failure(error.description) : nil;
        NSLog(@"error = %@",error);
    }];
    
    sessionTask ? [[ZJAFNRequestTool shareRequestTool].sessionTaskArr addObject:sessionTask] : nil ;
    return sessionTask;
}

+ (void)cancelAllRequest {
    // 锁操作
    @synchronized(self) {
        [[ZJAFNRequestTool shareRequestTool].sessionTaskArr enumerateObjectsUsingBlock:^(NSURLSessionTask  *_Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            [task cancel];
        }];
        [[ZJAFNRequestTool shareRequestTool].sessionTaskArr  removeAllObjects];
    }
}

+ (void)cancelRequestWithURL:(NSString *)URL {
    if (!URL) { return; }
    @synchronized (self) {
        [[ZJAFNRequestTool shareRequestTool].sessionTaskArr  enumerateObjectsUsingBlock:^(NSURLSessionTask  *_Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([task.currentRequest.URL.absoluteString hasPrefix:URL]) {
                [task cancel];
                [[ZJAFNRequestTool shareRequestTool].sessionTaskArr  removeObject:task];
                *stop = YES;
            }
        }];
    }
}

@end

#pragma mark - NSDictionary,NSArray的分类
/*
 *新建NSDictionary与NSArray的分类, 控制台打印json数据中的中文
 */
#ifdef DEBUG
@implementation NSArray (ZJ)

- (NSString *)descriptionWithLocale:(id)locale {
    NSMutableString *strM = [NSMutableString stringWithString:@"(\n"];
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [strM appendFormat:@"\t%@,\n", obj];
    }];
    [strM appendString:@")"];
    
    return strM;
}

@end

@implementation NSDictionary (ZJ)

- (NSString *)descriptionWithLocale:(id)locale {
    NSMutableString *strM = [NSMutableString stringWithString:@"{\n"];
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [strM appendFormat:@"\t%@ = %@;\n", key, obj];
    }];
    
    [strM appendString:@"}\n"];
    
    return strM;
}
@end
#endif


