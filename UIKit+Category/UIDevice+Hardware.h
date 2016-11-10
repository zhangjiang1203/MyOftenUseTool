//
//  UIDevice+Hardware.h
//  TestTable
//
//  Created by Inder Kumar Rathore on 19/01/13.
//  Copyright (c) 2013 Rathore. All rights reserved.
//

#import <UIKit/UIKit.h>

#define IS_IPAD (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
#define DEVICE_IOS_VERSION [[UIDevice currentDevice].systemVersion floatValue]
#define DEVICE_HARDWARE_BETTER_THAN(i) [[UIDevice currentDevice] isCurrentDeviceHardwareBetterThan:i]

#define DEVICE_HAS_RETINA_DISPLAY (fabs([UIScreen mainScreen].scale - 2.0) <= fabs([UIScreen mainScreen].scale - 2.0)*DBL_EPSILON)
#define IS_IOS7_OR_LATER (((double)(DEVICE_IOS_VERSION)-7.0) > -((double)(DEVICE_IOS_VERSION)-7.0)*DBL_EPSILON)
#define NSStringAdd568hIfIphone4inch(str) [NSString stringWithFormat:[UIDevice currentDevice].isIphoneWith4inchDisplay ? @"%@-568h" : @"%@", str]

#define IS_IPHONE_5 [[UIScreen mainScreen] applicationFrame].size.height == 568

typedef NS_ENUM(NSInteger,NETWORK_STATE) {
    NETWORK_STATE_NONE = 0,
    NETWORK_STATE_2G   = 1,
    NETWORK_STATE_3G   = 2,
    NETWORK_STATE_4G   = 3,
    NETWORK_STATE_5G   = 4,
    NETWORK_STATE_WIFI = 5,
};

typedef enum
{
    NOT_AVAILABLE,
    
    IPHONE_2G,
    IPHONE_3G,
    IPHONE_3GS,
    IPHONE_4,
    IPHONE_4_CDMA,
    IPHONE_4S,
    IPHONE_5,
    IPHONE_5_CDMA_GSM,
    IPHONE_5C,
    IPHONE_5C_CDMA_GSM,
    IPHONE_5S,
    IPHONE_5S_CDMA_GSM,
    IPHONE_6,
    IPHONE_6_PLUS,

    
    IPOD_TOUCH_1G,
    IPOD_TOUCH_2G,
    IPOD_TOUCH_3G,
    IPOD_TOUCH_4G,
    IPOD_TOUCH_5G,
    
    IPAD,
    IPAD_2,
    IPAD_2_WIFI,
    IPAD_2_CDMA,
    IPAD_3,
    IPAD_3G,
    IPAD_3_WIFI,
    IPAD_3_WIFI_CDMA,
    IPAD_4,
    IPAD_4_WIFI,
    IPAD_4_GSM_CDMA,
    
    IPAD_MINI,
    IPAD_MINI_WIFI,
    IPAD_MINI_WIFI_CDMA,
    IPAD_MINI_RETINA_WIFI,
    IPAD_MINI_RETINA_WIFI_CDMA,
    
    IPAD_AIR_WIFI,
    IPAD_AIR_WIFI_GSM,
    IPAD_AIR_WIFI_CDMA,
    
    SIMULATOR
} Hardware;


@interface UIDevice (Hardware)
/**
 *  返回硬件类型
 */
- (nullable NSString *)hardwareString;

/** This method returns the Hardware enum depending upon harware string */
- (Hardware)hardware;

/**
 *  硬件的具体描述
 */
- (nullable NSString *)hardwareDescription;

/** This method returs the readble description without identifier (GSM, CDMA, GLOBAL) */
- (nullable NSString *)hardwareSimpleDescription;

/** This method returns YES if the current device is better than the hardware passed */
- (BOOL)isCurrentDeviceHardwareBetterThan:(Hardware)hardware;

/** This method returns the resolution for still image that can be received 
 from back camera of the current device. Resolution returned for image oriented landscape right. **/
- (CGSize)backCameraStillImageResolutionInPixels;


/**
 *  是不是4或者4s
 *
 *  @return 是 YES  否  NO
 */
- (BOOL)isIphoneWith4inchDisplay;

/**
 *  返回的MAC地址
 */
+ (nullable NSString *)macAddress;

/**
 *  CPU频率 大小
 */
+ (NSUInteger)cpuFrequency;


/**
 *  总线频率 大小
 */
+ (NSUInteger)busFrequency;

/**
 *  RAM 的大小
 *
 *  @return RAM大小
 */
+ (NSUInteger)ramSize;

/**
 *  返回的CPU Number
 *
 */
+ (NSUInteger)cpuNumber;


//Return the current device total memory
//+ (NSUInteger)totalMemory;
// Return the current device non-kernel memory
//+ (NSUInteger)userMemory;

/**
 *  获取iOS系统的版本号
 *
 *  @return 系统版本
 */
+ (nullable NSString *)systemVersion;

/**
 *  判断当前系统是否有摄像头
 *
 *  @return 有就返回YES
 */
+ (BOOL)hasCamera;


/**
 *  获取手机内存总量, 返回的是字节数
 *
 *  @return 返回字节数
 */
+ (NSUInteger)totalMemoryBytes;


/**
 *  获取手机可用内存, 返回的是字节数
 *
 *  @return 字节数
 */
+ (NSUInteger)freeMemoryBytes;

/**
 *  获取手机硬盘空闲空间, 返回的是字节数
 *
 *  @return 字节数
 */
+ (long long)freeDiskSpaceBytes;


/**
 *  获取手机硬盘总空间, 返回的是字节数
 *
 *  @return 返回字节总数
 */
+ (long long)totalDiskSpaceBytes;


/**
 *  获取当前的显示的ViewController
 */
+ (nullable UIViewController *)getCurrentViewController;


/**
 *  获取当前的网络状态
 */
+ (NETWORK_STATE)getNetworkTypeFromStatusBar;
@end
