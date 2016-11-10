//
//  ZJAFNRequestTool.m
//  iOSRunTime
//
//  Created by pg on 2016/11/1.
//  Copyright © 2016年 pg. All rights reserved.
//

#import "ZJAFNRequestTool.h"

@interface ZJAFNRequestTool ()
{
    AFHTTPSessionManager *_manager;
}

@property (nonatomic,strong) NSURLSessionDataTask *httpDataTask;

@property (nonatomic,assign) AFNetworkReachabilityStatus workStatus;

@end

@implementation ZJAFNRequestTool

+(void)startMonitoring{
    
    [[AFNetworkReachabilityManager sharedManager]startMonitoring];
    [[AFNetworkReachabilityManager sharedManager]setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        [ZJAFNRequestTool shareRequestTool].workStatus = status;
        if (status == AFNetworkReachabilityStatusNotReachable) {
            //跳转到设置URL的地方
//            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
//            if ([[UIApplication sharedApplication] canOpenURL:url]) {
//                [[UIApplication sharedApplication] openURL:url];
//            }
            NSLog(@"还没有连接网络");
        }else{
            //提醒用户没有连接网络
            NSLog(@"已经连接网络");
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

- (instancetype)init
{
    self = [super init];
    if (self) {
        _manager = [AFHTTPSessionManager manager];
//        _manager.requestSerializer = [AFJSONRequestSerializer serializer];
        _manager.responseSerializer = [AFJSONResponseSerializer serializer];
//        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];

//        [_manager.requestSerializer setValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" forHTTPHeaderField:@"Accept"];
//        [_manager.requestSerializer setValue:@"en-us,en;q=0.5" forHTTPHeaderField:@"Accept-Language"];
//        [_manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
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
    NSString *requestURL = [NSString stringWithFormat:@"%@%@",KRESOURCEURL,sourceURL];
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

/**
 *  取消当前的请求
 */
+(void)cancelRequest{
    [[ZJAFNRequestTool shareRequestTool].httpDataTask cancel];
}


@end
