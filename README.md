# MyOftenUseTool
![Version](https://img.shields.io/badge/pod-0.3.0-yellow.svg)
![License](https://img.shields.io/badge/License-MIT-blue.svg)
![Platform](https://img.shields.io/badge/Platform-iOS-orange.svg)
![Platform](https://img.shields.io/badge/Build-Passed-green.svg)
###自己常用的一些封装方法和UIKIT，Foundation框架的category添加的方法

#可以使用Cocoapods进行安装，有关于Cocoapods的安转和使用请参考[Cocoapods](http://cocoapods.org),
#### Podfile
在你需要使用的项目中添加Podfile文件，
```ruby
platform :ios, '8.0'

pod 'MyOftenUseTool'
```

#Usage
##AFNetworking的封装
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

在文件中添加了请求返回和取消请求的操作,每个请求中返回值 NSURLSessionTask 可以根据这个来取消这个请求
```objective-c
/**
get请求

@param urlStr       请求的URL
@param params       请求参数
@param successBlock 成功的回调
@param failBlock    失败的回调
@return 返回的任务队列
*/
+(NSURLSessionTask*)getWithURL:(NSString*)urlStr param:(NSDictionary*)params success:(RequestSuccessBlock)successBlock fail:(RequestFailBlock)failBlock;
```
取消当前的网络请求的操作
```objective-c
   [ZJAFNRequestTool cancelRequest];
```
AFN请求中的封装还有post和put以及文件的上传和下载操作


##关于HUDHelper类的说明
这个类中涉及的方法使用比较杂，图像绘制，坐标转换，日期转换，判断空字符串和邮箱电话号码的正则表达式判断设置label的行间距，返回图文混排的文本，简单动画设定，计算文本的高度和数组字符串的一些处理方法等方法，具体的请看这个分类中的方法，都有注释的。
