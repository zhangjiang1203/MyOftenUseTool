# MyOftenUseTool
[![Version](https://img.shields.io/badge/pod-0.3.0-yellow.svg)]
[![License](https://img.shields.io/badge/License-MIT-blue.svg)]
[![Platform](https://img.shields.io/badge/Platform-iOS-orange.svg)
[![Platform](https://img.shields.io/badge/Build-Passed-green.svg)]
###自己常用的一些封装方法和UIKIT，Foundation框架的category添加的方法

#AFNetworking的封装
首先添加的就是关于网络状态的检测，

```objective-c
/*
* 开启网络监测 YES 有网络  NO 没有联网
*/
+ (BOOL)startMonitoring;

/*
* 关闭网络监测
*/
+ (void)stopMonitoring;

```
对应的实现如下
```objective-c
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

```

在文件中添加了请求返回和取消请求的操作
