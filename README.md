# MyOftenUseTool
![Version](https://img.shields.io/badge/pod-0.5.0-yellow.svg)
![License](https://img.shields.io/badge/License-MIT-blue.svg)
![Platform](https://img.shields.io/badge/Platform-iOS-orange.svg)
![Platform](https://img.shields.io/badge/Build-Passed-green.svg)
###自己常用的一些封装方法和UIKIT，Foundation框架的category添加的方法

##Requirements 要求
* iOS 8+
* XCode 8+

#可以使用Cocoapods进行安装，有关于Cocoapods的安转和使用请参考[Cocoapods](http://cocoapods.org),
#### Podfile
在你需要使用的项目中添加Podfile文件，

```ruby

platform :ios, '8.0'

pod 'MyOftenUseTool'

```

#关于类库的一些使用说明
##AFNetworking的封装，添加了YYCache缓存网络数据，网络数据存储在本地，根据请求的URL获取缓存的数据，并返回到相应的Block中，其中的方法参考YYCache的使用方法[参考例子](https://github.com/jkpang/PPNetworkHelper)中，可以下载测试项目
首先添加的就是关于网络状态的检测，

```objective-c
/*
* 开启网络监测 YES 有网络  NO 没有联网
*/
+ (void)startMonitoring:(void(^)(BOOL isNet))netBlock;

/*
* 关闭网络监测
*/
+ (void)stopMonitoring;

```
对应的实现如下
```objective-c
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

```

在文件中添加了请求返回和取消请求的操作,每个请求中返回值 NSURLSessionTask 可以根据这个来取消这个请求,请求中使用了YYCache来缓存对应的URL的请求数据，
```objective-c
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

```
取消当前的网络请求的操作
```objective-c
   [ZJAFNRequestTool cancelRequest];
```
AFN请求中的封装还有post和put以及文件的上传和下载操作


##关于HUDHelper类的说明
这个类中涉及的方法使用比较杂，图像绘制，坐标转换，日期转换，判断空字符串和邮箱电话号码的正则表达式判断设置label的行间距，返回图文混排的文本，简单动画设定，计算文本的高度和数组字符串的一些处理方法等方法，具体的请看这个分类中的方法，都有注释的。

##关于ZJSystemUtils类的说明
此类中主要是获取一些系统的信息，存储用户登录的账号和密码
```objective-c

/**
*  手机型号  “iPhone 5”,“iPhone 4S”,"iPhone 4"
*/
+(NSString*)deviceString;
/**
*  获取ip地址
*/
+(NSString *)getIPAddress;
/**
*  是否有摄像头使用权限
*
*  @param authorized 有权限回调
*  @param restricted 无权限回调
*/
+(void)videoAuthorizationStatusAuthorized:(void(^)(void))authorized restricted:(void(^)(void))restricted;
/**
*  获取当前的显示的ViewController
*
*  @return 当前的显示的ViewController
*/
+ (UIViewController *)getCurrentViewController;

/**
*  获取当前版本号
*/
+(NSString*)getCurrentVersion;

/**
*  获取历史存储的版本号
*/
+(NSString*)getHistoryVersion;

/**
设置登录状态 0 退出登录  1 登录成功
*/
+(void)setLoginState:(BOOL)state;

/**
获取登录状态 0 没有登录 1 登录
*/
+(BOOL)getLoginState;


/**
*  判断是不是第一次登陆
*/
+(BOOL)judgeIsFirstLogin;


/**
*  存储登录账号的用户名和密码
*/
+(void)saveUserAccount:(NSString*)account password:(NSString*)password;

/**
*  获取用户密码
*/
+(NSString*)getUserPassword;

/**
*  获取用户账号
*/
+(NSString*)getUserAccount;

/**
*  获取设备标示
*/
+(NSString *)getDiviceIdentifier;

#pragma mark -应用程序需要事先申请音视频使用权限
+ (BOOL)requestMediaCapturerAccessWithCompletionHandler:(void (^)(BOOL value, NSError *error))handler;

/**
*  检查app是否有照片操作权限
*/
+(void)getAssetsAuthorizationStatus:(void (^)(BOOL isAuthorize,NSString *errorStr))authorizeBlock;

#pragma mark -获取当前连接的wifi名称

/**
获取当前连接的wifi名称
*/
+(NSString *)getWifiName;

/**
容量转换
@param fileSize 文件大小
@return 返回值
*/
+(NSString *)fileSizeToString:(unsigned long long)fileSize;

/**
获取电池的状态
*/
+(UIDeviceBatteryState)getBatteryStauts;

/**
获取电池的电量，用百分比表示
*/
+(CGFloat)getBatteryQuantity;

```
具体的实现请点击.m文件查看

##UIKit和Foundation+Category类
这两个类中是收集的一些kit和foundation框架中添加的一些拓展类的方法，ZJAlertViewController是我自己封装的一个alertView的一个简单使用

```objective-c

/**
*  设置弹出的alertView，已经适配ios9
*
*  @param title             标题
*  @param message           信息
*  @param cancelButtonTitle 取消按钮,@"",没有取消按钮
*  @param otherButtonTitles 其他按钮,@"",没有确定按钮
*  @param alertBlock        返回的block
*/
+ (void)alertShowTitle:(nullable NSString *)title message:(nullable NSString*)message cancelButtonTitle:(nullable NSString *)cancelButtonTitle otherButtonTitles:(nullable NSString *)otherButtonTitles block:(nullable continueBlock)alertBlock;


/**
*  提示信息 有取消和确定两个按钮
*
*  @param message       内容
*  @param continueBlock 确定按钮的点击事件
*  @param cancelBlock   返回按钮的点击事件
*/
+(void)alertShowWithMsg:(nullable NSString *)message continueBlock:(nullable continueNoParamBlock)continueBlock cancelBlock:(nullable continueNoParamBlock)cancelBlock;

/**
提示信息,只有确定按钮

@param message       内容
@param title         确定按钮的title
@param continueBlock 确定按钮的点击事件
*/
+(void)alertShowWithMsg:(nullable NSString *)message continueTitle:(nullable NSString *)title continueBlock:(nullable continueNoParamBlock)continueBlock;

```

##WaveAnimation
这是一个加载等待视图，在网络加载过程中显示，这是在网上看到的一个比较好的例子，自己修改和封装之后更方便使用，[原文地址](http://www.cocoachina.com/ios/20161202/18252.html),加载完成之后取消显示,效果如下

![波浪显示](https://github.com/zhangjiang1203/MyOftenUseTool/blob/master/Example/waveAnimation.gif "波浪显示")

显示指示图
```objective-c
/**
开始加载显示视图 nil为空的时候显示在rootView的window上
*/
+(void)startAnimationToView:(UIView*)view;


/**
停止显示视图
*/
+(void)stopAnimation;

```

#Demo
上面的文件都包含在一个[测试项目](https://github.com/zhangjiang1203/MyOftenUseTool)中，可以下载测试项目

#证书

RealReachability is released under the MIT license. See LICENSE for details.

#最后

欢迎使用，如果在使用中有什么问题请联系我😁😁😁😁
