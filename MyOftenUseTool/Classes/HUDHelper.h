//
//  HUDHelper.h
//  XIBConstraintTest
//
//  Created by zhangjiang on 15/11/5.
//  Copyright © 2015年 zhangjiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

#pragma mark -显示多文本
@interface WCAttachmentText : NSTextAttachment

@end



#define MSG_VIDEO_NO_AUTH    @"该应用未获得授权使用摄像头\n请在iOS“设置”－“隐私” - “相机”中打开,然后回到本应用。"
#define MSG_VIDEO_NO         @"抱歉，暂不支持该手机系统版本"

#define IOS7_OR_LATER   ( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )

#define IOS8_OR_LATER  ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

typedef void (^AnimationSuccessBlock)(BOOL isFinish);
typedef void (^AlertDecideBlock)(NSInteger buttonIndex);//

double radians(float degrees);

typedef enum {
    NETWORK_TYPE_NONE= 0,
    NETWORK_TYPE_2G= 1,
    NETWORK_TYPE_3G= 2,
    NETWORK_TYPE_4G= 3,
    NETWORK_TYPE_5G= 4,//  5G目前为猜测结果
    NETWORK_TYPE_WIFI= 5,
    
}NETWORK_TYPE;


@interface HUDHelper : NSObject
@property (nonatomic, strong) UIView *backView;

/**
 *  定义一个单例
 */
+ (HUDHelper *) getInstance;



/**
 *  获取当前的显示的ViewController
 */
+ (UIViewController *)getCurrentViewController;


/**
 *  获得当前的网络状态
 */
+(NETWORK_TYPE)getNetworkTypeFromStatusBar;//获得当前的网络状态


/**
 *  判断手机号是否正确
 */
+(BOOL)CheckPhoneNumInput:(NSString *)text;


/**
 判断身份证号格式是否正确
 */
+ (BOOL)IsIdentityCard:(NSString *)IDCardNumber;


/**
 *  判断邀请码格式是否正确
 */
+(BOOL)CheckInviteCodeInput:(NSString *)text;


/**
 *  计算字符串中字符个数 一个汉字占据两个字符
 */
+ (NSUInteger)lenghtWithString:(NSString *)string chineseCharCount:(NSUInteger*)chineseCharCount;


/**
 *  计算并绘制字符串文本的高度
 *  @param x     最大的宽度
 */
+(CGSize)getSuitSizeWithString:(NSString *)text fontSize:(float)fontSize bold:(BOOL)bold sizeOfX:(float)x;


/**
 * 计算指定高度的文本的宽度
 */
+(CGSize)getSuitSizeWidthWithString:(NSString*)text fontSize:(float)fontSize sizeOfY:(float)y;

/**
 *  是否有摄像头使用权限
 */
+(void)videoAuthorizationStatusAuthorized:(void(^)(void))authorized;

/**
 * 返回两个日期之间的天数
 */
+(NSInteger)calculateDaysWithDate:(NSString*)dateString;


/**
 *  比较两个日期的大小 format yyyy-MM-dd HH:mm:ss"
 */
+(int)compareOneDay:(NSString *)oneDay withAnotherDay:(NSString *)anotherDay dateFormat:(NSString*)format;

/**
 *  计算两个日期之间的分钟数
 */
+(CGFloat)calculateMinuteFrom:(NSString*)dateStr1 toDate:(NSString *)dateStr2;


/**
 *  计算与当前日期的分钟数
 *
 *  @param dateString 比较的日期
 *
 *  @return 相隔的分钟数  -1  0 都是小于当前时间  > 0 才是返回以后的时间
 */
+(NSInteger)calculateMinuteWithDate:(NSString *)dateString;


/**
 * date与string的相互转换
 *  @"yyyy-MM-dd HH:mm:ss"
 */
+(NSDate*) convertDateFromString:(NSString*)uiDate format:(NSString*)format;


/**
 *  字符串转日期
 *  @param dateString 输入的日期字符串形如：@"1992-05-21 13:08:08"
 */
+ (NSDate *)dateFromString:(NSString *)dateString format:(NSString*)format;


/*!
 *  判断字符串是否为空，为空返回YES
 */
+ (BOOL)isBlankString:(NSString *)string;


/**
 判断服务器返回的数据是否为空
 */
+(BOOL)judgeResposeIsBlank:(id )responseData;


/**
 *  两个字符串是否是包含关系
 */
+(BOOL)isContainsString:(NSString *)firstStr second:(NSString*)secondStr;


/**
 *  截取字符；
 */
+(NSString *)timeString:(NSString *)timeStr range:(NSUInteger)range;


/**
 *  字典或者数组转json字符串
 */
+(NSString*)converseToJsonWithObject:(id)obj;


/*!
 * @brief 把格式化的JSON格式的字符串转换成字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

/**
 *  将数组中重复的对象去除，只保留一个
 */
+ (NSArray *)arrayWithMemberIsOnly:(NSArray *)array;


/**
 *  通过颜色值生成图片
 */
+ (UIImage *)buttonImageFromColor:(UIColor *)color size:(CGSize)size;


/**
 *  获取当前系统时间 @"yyyy-MM-dd HH:mm:ss"
 */
+(NSString*)getCurrentDateWithFormat:(NSString*)format;

/**
 *  截屏操作
 *
 */
+ (UIImage *) captureScreen;

/**
 * 裁剪图片
 */
+ (UIImage *)clipsToRect:(CGRect)rect image:(UIImage*)orangeImage;

/**
 *  图片压缩处理到指定的大小
 */
+(UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size;


/**
 * @brief  指定宽度压缩图片
 */
+ (UIImage *)scaleToSize:(UIImage *)img sizeW:(CGFloat)changeW;

/**
 *  设置图片自适应
 */
+(void)setImageFitWithImageView:(UIImageView*)imageView;


/**
 *  控件放大缩小动画
 */
+(void)makeScale:(UIView*)scaleView delegate:(id)delegate scale:(CGFloat)scale duration:(CFTimeInterval)duration;


/**
 *  控件旋转
 */
+(void)rotationView:(UIView*)view delegate:(id)delegate;


/**
 *  添加控件来回动画
 */
+(void)floatAnimator:(UIView *)animator;


/**
 *  app版本号
 */
+ (NSString *)appVersion;


/**
 *  根据颜色值生成一个渐变的颜色块
 */
+ (UIImage*) BgImageFromColors:(NSArray*)colors withFrame: (CGRect)frame;

/**
 *  生成一个纯颜色背景图
 */
+ (UIImage *)imageWithColor:(UIColor *)color;

/**
 *  百度转火星坐标
 */
+ (CLLocation*)transformFromBaiDuToGoogle:(CLLocation*)baidu;


/**
 *  火星转百度坐标
 */
+ (CLLocation*)transformFromGoogleToBaiDu:(CLLocation*)google;


#pragma mark   ==============产生随机订单号==============
/**
 *  产生随机订单号
 */
+ (NSString *)generateTradeNO;


/*!
 @brief 简单绘制线性渐变效果 从上至下
 @param topColor 上色
 @param buttomColor 下色
 @param startpoint 起点
 @param endpoint   终点
 */
+(CALayer*)drawLineGradient:(UIColor*)topColor
                buttomColor:(UIColor*)buttomColor
                 startpoint:(CGPoint)startPoint
                   endpoint:(CGPoint)endPoint
                      frame:(CGRect)frame;



/**
 *  返回图文混排
 *
 *  @param string     字符串
 *  @param attributes 文字属性
 *  @param imageName  图片名称
 *  @param index      插入位置
 *
 *  @return 用控件的attributedText属性接收
 */
+(NSMutableAttributedString*)createTextKitWithString:(NSString*)string attributes:(NSDictionary*)attributes image:(NSString*)imageName range:(NSRange)range index:(NSInteger)index;


/**
 *  生成毛玻璃效果的背景,
 *
 *  @param frame 添加的frame
 *
 *  @return 返回的毛玻璃效果View
 */
+(UIView *)createFrostedglassEffectWithFrame:(CGRect)frame;

/**
 *  设置图片显示的样式
 */
+(void)setControlView:(UIView*)view corner:(CGFloat)cornerRadius borderW:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;

/**
 *  修改图像显示的方向
 */
+ (UIImage *)fixOrientation:(UIImage *)srcImg ;

/**
 *  设置label的行间距的文本显示
 *
 *  @param label     文本
 *  @param str       文字
 *  @param font      字体
 *  @param lineSpace 行间距
 */
+(void)setLabelSpace:(UILabel*)label withValue:(NSString*)str withFont:(UIFont*)font space:(CGFloat)lineSpace;


#pragma mark -计算UILabel的高度(带有行间距的情况)
/**
 *  计算UILabel的高度(带有行间距的情况)
 *
 *  @param str       文本
 *  @param font      字号
 *  @param width     最大宽度
 *  @param lineSpace 间距
 *
 *  @return label高度
 */
+(CGFloat)getSpaceLabelHeight:(NSString*)str withFont:(UIFont*)font withWidth:(CGFloat)width space:(CGFloat)lineSpace;
@end
