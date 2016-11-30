//
//  ZJSystemUtils.m
//  MyOftenUseTool
//
//  Created by pg on 2016/11/16.
//  Copyright © 2016年 zhangjiang. All rights reserved.
//

#import "ZJSystemUtils.h"
#import <sys/utsname.h>              /*设备型号*/
#import <AVFoundation/AVFoundation.h>/*相机*/
#include <ifaddrs.h>                 /*ip*/
#include <arpa/inet.h>               /*ip*/
#import "SAMKeychain.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <SystemConfiguration/CaptiveNetwork.h>

static NSString *key = @"CFBundleShortVersionString";

#define KUserPasswordIdentifier @"userPassWord"
#define KUserAccount            @"userAccount"
#define KUserLogin              @"userLogin"
#define KUserLoginSuccess       @"loginSuccess"
#define KUserLoginOut           @"loginOut"


@implementation ZJSystemUtils
+(NSString*)deviceString
{
    // 需要#import "sys/utsname.h"
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,3"])    return @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone5,4"])    return @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone6,1"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceString isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceString isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    
    //iPod
    if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceString isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";
    
    //iPad
    if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceString isEqualToString:@"iPad2,4"])      return @"iPad 2 (32nm)";
    if ([deviceString isEqualToString:@"iPad2,5"])      return @"iPad mini (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,6"])      return @"iPad mini (GSM)";
    if ([deviceString isEqualToString:@"iPad2,7"])      return @"iPad mini (CDMA)";
    if ([deviceString isEqualToString:@"iPad3,1"])      return @"iPad 3(WiFi)";
    if ([deviceString isEqualToString:@"iPad3,2"])      return @"iPad 3(CDMA)";
    if ([deviceString isEqualToString:@"iPad3,3"])      return @"iPad 3(4G)";
    if ([deviceString isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([deviceString isEqualToString:@"iPad3,5"])      return @"iPad 4 (4G)";
    if ([deviceString isEqualToString:@"iPad3,6"])      return @"iPad 4 (CDMA)";
    if ([deviceString isEqualToString:@"iPad4,1"])      return @"iPad Air";
    if ([deviceString isEqualToString:@"iPad4,2"])      return @"iPad Air";
    if ([deviceString isEqualToString:@"iPad4,3"])      return @"iPad Air";
    if ([deviceString isEqualToString:@"iPad5,3"])      return @"iPad Air 2";
    if ([deviceString isEqualToString:@"iPad5,4"])      return @"iPad Air 2";
    
    //Simulator
    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";
    
    if ([deviceString isEqualToString:@"iPad4,4"]
        ||[deviceString isEqualToString:@"iPad4,5"]
        ||[deviceString isEqualToString:@"iPad4,6"])      return @"iPad mini 2";
    
    if ([deviceString isEqualToString:@"iPad4,7"]
        ||[deviceString isEqualToString:@"iPad4,8"]
        ||[deviceString isEqualToString:@"iPad4,9"])      return @"iPad mini 3";
    
    NSLog(@"NOTE: Unknown device type: %@", deviceString);
    
    return deviceString;
}
//获取ip地址
+(NSString *)getIPAddress
{
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if( temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    // Free memory
    freeifaddrs(interfaces);
    
    return address;
}

/**
 *  是否有摄像头使用权限
 *
 *  @param authorized 有权限回调
 *  @param restricted 无权限回调
 */
+(void)videoAuthorizationStatusAuthorized:(void(^)(void))authorized restricted:(void(^)(void))restricted
{
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if(authStatus == AVAuthorizationStatusRestricted ||
       authStatus == AVAuthorizationStatusDenied){
        if(restricted)
        {
            restricted();
        }
    }else{
        authorized();
    }
}

/**
 *  获取当前的显示的ViewController
 */
+ (UIViewController *)getCurrentViewController{
    
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

+(NSString *)getCurrentVersion{
    return [NSBundle mainBundle].infoDictionary[key];
}

+(NSString*)getHistoryVersion{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults stringForKey:key];
}

+(void)setLoginState:(BOOL)state{
    if (state) {
        [[NSUserDefaults standardUserDefaults]setObject:KUserLoginSuccess forKey:KUserLogin];
    }else{
        [[NSUserDefaults standardUserDefaults]setObject:KUserLoginOut forKey:KUserLogin];
    }
}

+(BOOL)getLoginState{
    
    NSString *loginState = [[NSUserDefaults standardUserDefaults] objectForKey:KUserLogin];
    if ([loginState isEqualToString:KUserLoginSuccess]) {
        return YES;
    }else{
        return NO;
    }
}


+(BOOL)judgeIsFirstLogin{
    
    NSString *currentVersions = [ZJSystemUtils getCurrentVersion];
    NSString *oldVersions = [ZJSystemUtils getHistoryVersion];
    if ([currentVersions isEqualToString:oldVersions]) {
        //不是第一次登陆
        return NO;
    }else{
        //是第一次登陆,存储版本号
        //存储新版本号
        [[NSUserDefaults standardUserDefaults] setObject:currentVersions forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return YES;
    }
}

+(void)saveUserAccount:(NSString*)account password:(NSString*)password{
    //存储登录状态
    [ZJSystemUtils setLoginState:YES];
    //存储登录账号
    [[NSUserDefaults standardUserDefaults]setObject:account forKey:KUserAccount];
    [[NSUserDefaults standardUserDefaults]synchronize];
    //存储用户名和密码
    /** 初始化一个保存用户帐号的KeychainItemWrapper */
    [SAMKeychain setPassword:password forService:KUserPasswordIdentifier account:KUserAccount];
}


+(NSString*)getUserPassword{
    
    NSString *pass = [SAMKeychain passwordForService:KUserPasswordIdentifier account:KUserAccount];
    return pass;
    
}

+(NSString*)getUserAccount{
    
    NSString *account = [[NSUserDefaults standardUserDefaults]objectForKey:KUserAccount];
    return account;
}

+(NSString*)getDiviceIdentifier{
    NSUUID *identifierForVendor = [[UIDevice currentDevice] identifierForVendor];
    NSString *deviceId = [[identifierForVendor UUIDString] stringByReplacingOccurrencesOfString:@"-" withString:@""];
    return deviceId;
}

#pragma mark -应用程序需要事先申请音视频使用权限
+ (BOOL)requestMediaCapturerAccessWithCompletionHandler:(void (^)(BOOL, NSError*))handler {
    AVAuthorizationStatus videoAuthorStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    AVAuthorizationStatus audioAuthorStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    
    if (AVAuthorizationStatusAuthorized == videoAuthorStatus && AVAuthorizationStatusAuthorized == audioAuthorStatus) {
        handler(YES,nil);
    }else{
        if (AVAuthorizationStatusRestricted == videoAuthorStatus || AVAuthorizationStatusDenied == videoAuthorStatus) {
            NSString *errMsg = NSLocalizedString(@"此应用需要访问摄像头，请设置", @"此应用需要访问摄像头，请设置");
            NSDictionary *userInfo = @{NSLocalizedDescriptionKey:errMsg};
            NSError *error = [NSError errorWithDomain:@"访问权限" code:0 userInfo:userInfo];
            handler(NO,error);
            return NO;
        }
        
        if (AVAuthorizationStatusRestricted == audioAuthorStatus || AVAuthorizationStatusDenied == audioAuthorStatus) {
            NSString *errMsg = NSLocalizedString(@"此应用需要访问麦克风，请设置", @"此应用需要访问麦克风，请设置");
            NSDictionary *userInfo = @{NSLocalizedDescriptionKey:errMsg};
            NSError *error = [NSError errorWithDomain:@"访问权限" code:0 userInfo:userInfo];
            handler(NO,error);
            return NO;
        }
        
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
                    if (granted) {
                        handler(YES,nil);
                    }else{
                        NSString *errMsg = NSLocalizedString(@"不允许访问麦克风", @"不允许访问麦克风");
                        NSDictionary *userInfo = @{NSLocalizedDescriptionKey:errMsg};
                        NSError *error = [NSError errorWithDomain:@"访问权限" code:0 userInfo:userInfo];
                        handler(NO,error);
                    }
                }];
            }else{
                NSString *errMsg = NSLocalizedString(@"不允许访问摄像头", @"不允许访问摄像头");
                NSDictionary *userInfo = @{NSLocalizedDescriptionKey:errMsg};
                NSError *error = [NSError errorWithDomain:@"访问权限" code:0 userInfo:userInfo];
                handler(NO,error);
            }
        }];
    }
    return YES;
}

+(void)getAssetsAuthorizationStatus:(void (^)(BOOL, NSString *))authorizeBlock{
    NSString *tipTextWhenNoPhotosAuthorization; // 提示语
    // 获取当前应用对照片的访问授权状态
    ALAuthorizationStatus authorizationStatus = [ALAssetsLibrary authorizationStatus];
    // 如果没有获取访问授权，或者访问授权状态已经被明确禁止，则显示提示语，引导用户开启授权
    if (authorizationStatus == ALAuthorizationStatusRestricted || authorizationStatus == ALAuthorizationStatusDenied) {
        NSDictionary *mainInfoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *appName = [mainInfoDictionary objectForKey:@"CFBundleDisplayName"];
        tipTextWhenNoPhotosAuthorization = [NSString stringWithFormat:@"请在设备的\"设置-隐私-照片\"选项中，允许%@访问你的手机相册", appName];
        // 展示提示语
        authorizeBlock(NO,tipTextWhenNoPhotosAuthorization);
    }else{
        authorizeBlock(YES,@"");
    }
}

#pragma mark -获取当前连接的wifi名称
+(NSString*)getWifiName{
    NSString *wifiName = nil;
    CFArrayRef wifiInterfaces = CNCopySupportedInterfaces();
    if (!wifiInterfaces) return nil;
    
    NSArray *interfaces = (__bridge NSArray *)wifiInterfaces;
    for (NSString *interfaceName in interfaces) {
        CFDictionaryRef dictRef = CNCopyCurrentNetworkInfo((__bridge CFStringRef)(interfaceName));
        if(dictRef){
            NSDictionary *networkInfo = (__bridge NSDictionary*)dictRef;
            wifiName = [networkInfo objectForKey:((__bridge NSString *)kCNNetworkInfoKeySSID)];
            CFRelease(dictRef);
        }
    }
    CFRelease(wifiInterfaces);
    return wifiName;
}


+(NSString *)fileSizeToString:(unsigned long long)fileSize
{
    NSInteger KB = 1024;
    NSInteger MB = KB*KB;
    NSInteger GB = MB*KB;
    
    if (fileSize < 10)  {
        return @"0 B";
    }else if (fileSize < KB)    {
        return @"< 1 KB";
    }else if (fileSize < MB)    {
        return [NSString stringWithFormat:@"%.1f KB",((CGFloat)fileSize)/KB];
    }else if (fileSize < GB)    {
        return [NSString stringWithFormat:@"%.1f MB",((CGFloat)fileSize)/MB];
    }else   {
        return [NSString stringWithFormat:@"%.1f GB",((CGFloat)fileSize)/GB];
    }
}


+(long long)getTotalMemorySize
{
    return [NSProcessInfo processInfo].physicalMemory;
}

+(UIDeviceBatteryState)getBatteryStauts
{
    return [UIDevice currentDevice].batteryState;
}

+(CGFloat)getBatteryQuantity
{
    return [[UIDevice currentDevice]batteryLevel];
}

@end
