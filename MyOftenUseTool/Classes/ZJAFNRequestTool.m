//
//  ZJAFNRequestTool.m
//  iOSRunTime
//
//  Created by pg on 2016/11/1.
//  Copyright © 2016年 pg. All rights reserved.
//

#import "ZJAFNRequestTool.h"
#import "AFNetworking.h"

#define KCertificates @""

@interface ZJAFNRequestTool ()

@property (nonatomic,strong) NSURLSessionDataTask *httpDataTask;

@property (nonatomic,assign) AFNetworkReachabilityStatus workStatus;

@end

@implementation ZJAFNRequestTool

static AFHTTPSessionManager *_manager;


+(BOOL)startMonitoring{
    
    __block BOOL isNet = NO;
    [[AFNetworkReachabilityManager sharedManager]startMonitoring];
    [[AFNetworkReachabilityManager sharedManager]setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        [ZJAFNRequestTool shareRequestTool].workStatus = status;
        if (status == AFNetworkReachabilityStatusNotReachable) {
            //跳转到设置URL的地方
            isNet = NO;
        }else{
            isNet = YES;
        }
    }];
    return NO;
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
    //设置请求参数的类型:JSON (AFJSONRequestSerializer,AFHTTPRequestSerializer)
    _manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //设置请求的超时时间
    _manager.requestSerializer.timeoutInterval = 30.f;
    //设置服务器返回结果的类型:JSON (AFJSONResponseSerializer,AFHTTPResponseSerializer)
    _manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/plain", @"text/javascript", @"text/xml", @"image/*", nil];
    
    // 2.设置证书模式
    NSString * cerPath = [[NSBundle mainBundle] pathForResource:KCertificates ofType:@"cer"];
    NSData * cerData = [NSData dataWithContentsOfFile:cerPath];
    _manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate withPinnedCertificates:[[NSSet alloc] initWithObjects:cerData, nil]];
    // 客户端是否信任非法证书
    _manager.securityPolicy.allowInvalidCertificates = YES;
    // 是否在证书域字段中验证域名
    [_manager.securityPolicy setValidatesDomainName:NO];

}

- (instancetype)init
{
    self = [super init];
    if (self) {
        //加载错误信息提示

    }
    return self;
}

-(NSURLSessionTask*)httpRequestMethod:(RequestMethod)requestMethod source:(NSString*)sourceURL param:(NSDictionary*)params success:(RequestSuccessBlock)successBlock fail:(RequestFailBlock)failBlock{
    
    //无网络情况，取消当前请求，直接返回错误信息*/
    if ([ZJAFNRequestTool shareRequestTool].workStatus ==AFNetworkReachabilityStatusNotReachable) {
        failBlock(@"您还没有联网,请检查网络");
        [ZJAFNRequestTool cancelRequest];
        return nil;
    }
    //拼接URL
    NSString *requestURL = [NSString stringWithFormat:@"%@%@",_resourceURL,sourceURL];
    switch (requestMethod) {
        case RequestMethod_Get:
        {
            _httpDataTask = [_manager GET:requestURL parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                successBlock(task,responseObject);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                failBlock(error.description);
            }];
        }
            break;
        case RequestMethod_Post:
        {
            _httpDataTask = [_manager POST:requestURL parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                successBlock(task,responseObject);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                failBlock(error.description);
            }];
        }
            break;
        case RequestMethod_Put:
        {
            _httpDataTask = [_manager PUT:requestURL parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                successBlock(task,responseObject);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                failBlock(error.description);
            }];
        }
            break;
    }
    return _httpDataTask;
}

+(NSURLSessionTask *)getWithURL:(NSString *)urlStr param:(NSDictionary *)params success:(RequestSuccessBlock)successBlock fail:(RequestFailBlock)failBlock{
    return [[ZJAFNRequestTool shareRequestTool] httpRequestMethod:RequestMethod_Get source:urlStr param:params success:^(NSURLSessionDataTask *task, id dataResource) {
        successBlock(task,dataResource);
    } fail:failBlock];
}

+(NSURLSessionTask *)postWithURL:(NSString *)urlStr param:(NSDictionary *)params success:(RequestSuccessBlock)successBlock fail:(RequestFailBlock)failBlock{
    return [[ZJAFNRequestTool shareRequestTool]httpRequestMethod:RequestMethod_Post source:urlStr param:params success:^(NSURLSessionDataTask *task, id dataResource) {
        successBlock(task,dataResource);
    } fail:failBlock];
}

+(NSURLSessionTask *)putWithURL:(NSString *)urlStr param:(NSDictionary *)params success:(RequestSuccessBlock)successBlock fail:(RequestFailBlock)failBlock{
    return [[ZJAFNRequestTool shareRequestTool]httpRequestMethod:RequestMethod_Put source:urlStr param:params success:^(NSURLSessionDataTask *task, id dataResource) {
        successBlock(task,dataResource);
    } fail:failBlock];
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
    
    return downloadTask;
    
}


#pragma mark - 上传图片文件

+ (NSURLSessionTask *)uploadWithURL:(NSString *)URL
                         parameters:(NSDictionary *)parameters
                             images:(NSArray<UIImage *> *)images
                               name:(NSString *)name
                           progress:(HttpProgress)progress
                            success:(UploadMyFileSuccess)success
                            failure:(RequestFailBlock)failure
{
    
    return [_manager POST:URL parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //根据当前系统时间生成图片名称
        NSDate *date = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy/MM/dd/hh/mm/ss"];
        NSString *dateString = [formatter stringFromDate:date];
        //压缩-添加-上传图片
        [images enumerateObjectsUsingBlock:^(UIImage * _Nonnull image, NSUInteger idx, BOOL * _Nonnull stop) {
            NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
            [formData appendPartWithFileData:imageData name:name fileName:[NSString stringWithFormat:@"%@-%zd",dateString,idx] mimeType:@"image/jpg/png/jpeg"];
        }];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        //上传进度
        dispatch_sync(dispatch_get_main_queue(), ^{
            progress ? progress(uploadProgress) : nil;
        });
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        success ? success(responseObject) : nil;
        NSLog(@"responseObject = %@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failure ? failure(error.description) : nil;
        NSLog(@"error = %@",error);
    }];
}



/**
 *  取消当前的请求
 */
+(void)cancelRequest{
    [[ZJAFNRequestTool shareRequestTool].httpDataTask cancel];
}


@end
