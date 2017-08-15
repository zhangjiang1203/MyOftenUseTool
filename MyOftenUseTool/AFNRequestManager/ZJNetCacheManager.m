//
//  ZJNetCacheManager.m
//  MyOftenUseTool
//
//  Created by DFHZ on 2017/8/15.
//  Copyright © 2017年 zhangjiang. All rights reserved.
//

#import "ZJNetCacheManager.h"
#import "YYCache.h"

#pragma mark -网络缓存数据
@implementation ZJNetCacheManager

static NSString *const ZJNetCache = @"ZJNetCacheManager";
static YYCache *_dataCache;

//初始化YYCache
+(void)initialize{
    _dataCache = [YYCache cacheWithName:ZJNetCache];
}


+(void)setHttpCache:(id)httpData URL:(NSString *)URL params:(NSDictionary *)params{
    NSString *cacheKey = [self cacheKeyWithURL:URL params:params];
    //异步缓存
    [_dataCache setObject:httpData forKey:cacheKey withBlock:nil];
}

+(id)getHttpCacheWithURL:(NSString *)URL params:(NSDictionary *)params{
    NSString *cahceKey = [self cacheKeyWithURL:URL params:params];
    return [_dataCache objectForKey:cahceKey];
}


+(void)getHttpCacheWithURL:(NSString *)URL params:(NSDictionary *)params withBlock:(void (^)(id<NSCoding>))block{
    NSString *cahceKey = [self cacheKeyWithURL:URL params:params];
    [_dataCache objectForKey:cahceKey withBlock:^(NSString * _Nonnull key, id<NSCoding>  _Nonnull object) {
       dispatch_async(dispatch_get_main_queue(), ^{
           block(object);
       });
    }];
}

+(NSInteger)getAllHttpCacheSize{
    return [_dataCache.diskCache totalCost];
}

+(void)removeAllHttpCache{
    [_dataCache.diskCache removeAllObjects];
}


+(NSString*)cacheKeyWithURL:(NSString*)URL params:(NSDictionary*)params{
    if (!params) return URL;
    //参数转字符串
    NSData *stringData = [NSJSONSerialization dataWithJSONObject:params options:0 error:nil];
    NSString *paramsString = [[NSString alloc]initWithData:stringData encoding:NSUTF8StringEncoding];
    
    return [NSString stringWithFormat:@"%@%@",URL,paramsString];
}


@end
