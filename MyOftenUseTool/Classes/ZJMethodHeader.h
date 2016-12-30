//
//  ZJMethodHeader.h
//  MyOftenUseTool
//
//  Created by pg on 2016/11/4.
//  Copyright © 2016年 DZHFCompany. All rights reserved.
//
#ifdef __OBJC__

/**
 字符串是否为空
 */
#define KStringIsEmpty(str) ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1 ? YES:NO)

/**
 数组是否为空
 */
#define KArrarIsEmpty(array) (array == nil || [array isKindOfClass:[NSNull class]] || array.count == 0)

/**
 字典是否为空
 */
#define KDictIsEmpty(dic) (dic == nil || [dic isKindOfClass:[NSNull class]] || dic.allKeys == 0)

/**
 判断对象是否为空
 */
#define KObjectIsEmpty(object) (object == nil \
|| [object isKindOfClass:[NSNull class]] \
|| ([object respondsToSelector(length)] && [(NSData*)object length] == 0) \
|| ([object respondsToSelector(count)] && [(NSArray*)object count] == 0))


/**
 App版本号
 */
#define KAppVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

/**
 屏幕宽度
 */
#define KScreenWidth [UIScreen mainScreen].bounds.size.width

/**
 屏幕高度
 */
#define KScreenHeight [UIScreen mainScreen].bounds.size.height

/**
 生成颜色值
 */
#define KRGB(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]

/**
 生成颜色值 可以设置透明度
 */
#define KRGBA(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(r)/255.0 blue:(r)/255.0 alpha:a]

/**
 随机颜色值
 */
#define KRandomColor KRGB(arc4randow_uniform(256)/255.0,arc4randow_uniform(256)/255.0,arc4randow_uniform(256)/255.0)

/**
 十六进制颜色值 可设置透明度
 */
#define UIColorFromRGB(rgbValue,a) [UIColor colorWithRed : ((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 green : ((float)((rgbValue & 0xFF00) >> 8)) / 255.0 blue : ((float)(rgbValue & 0xFF)) / 255.0 alpha : a]

/**
 弱引用
 */
#define KWeakSelf(type) __weak typeof(type) weak##type = type;

/**
 由角度转换弧度
 */
#define KDegreesToRadian(x) (M_PI * (x) / 180.0)

/**
 由弧度转换角度
 */
#define KRadianToDegrees(radian) (radian * 180.0) / (M_PI)

/**
 读取本地图片
 */
#define KLoadImage(fileName,ext) [UIImage imageWithContentsOfFile:[NSBundle mainBundle]pathForResource:file ofType:ext]]

/**
 定义UIImage对象
*/
#define KImageNamed(imageName) [UIImage imageNamed:imageName]

/**
 打印输出
*/
#if DEBUG
#define NSLog(FORMAT, ...) fprintf(stderr,"\nfunction:%s line:%d content:%s\n", __FUNCTION__, __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define NSLog(FORMAT, ...) nil
#endif

/**
 *  设置控件的圆角和边框
*/
#define KViewBorderRadius(View, Radius, Width, Color)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:[Color CGColor]]

#pragma mark -添加的头文件信息
#import "Foundation_Category.h"
#import "UI_Categories.h"
#import "HUDHelper.h"
#import "ZJAFNRequestTool.h"
#import "WaveAnimation.h"


#endif
