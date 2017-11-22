//
//  HUDHelper.m
//  XIBConstraintTest
//
//  Created by zhangjiang on 15/11/5.
//  Copyright © 2015年 zhangjiang. All rights reserved.
//

#import "HUDHelper.h"
#include <arpa/inet.h>
#include <ifaddrs.h>
#import <AVFoundation/AVFoundation.h>/*相机*/
#import <objc/runtime.h>
#import "pop.h"
#define _IPHONE70_ 70000
#define IOS9  [[[UIDevice currentDevice] systemVersion] floatValue]>=9.0f
static const double _x_pi = 3.14159265358979324 * 3000.0 / 180.0;

@implementation WCAttachmentText

- (CGRect)attachmentBoundsForTextContainer:(NSTextContainer *)textContainer proposedLineFragment:(CGRect)lineFrag glyphPosition:(CGPoint)position characterIndex:(NSUInteger)charIndex NS_AVAILABLE_IOS(7_0)
{
    return CGRectMake( 0 , -2 , 16 , 16 );
}
@end

@interface HUDHelper ()<POPAnimationDelegate>

@end


@implementation HUDHelper
+ (HUDHelper *) getInstance
{
    static HUDHelper *instance = nil;
    @synchronized(self) {
        if (instance == nil) {
            instance = [[HUDHelper alloc] init];
        }
    }
    return instance;
}

/* 判断手机号是否正确 */
+(BOOL)CheckPhoneNumInput:(NSString *)text{
    NSString *regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0-9])|(17[0-9]))\\d{8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return  [pred evaluateWithObject:text];
}

+ (BOOL) IsIdentityCard:(NSString *)IDCardNumber
{
    if (IDCardNumber.length <= 0) {
        return NO;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:IDCardNumber];
}

/**
 *  计算字符串中字符个数 一个汉字占据两个字符
 */
+ (NSUInteger)lenghtWithString:(NSString *)string chineseCharCount:(NSUInteger*)chineseCharCount
{
    NSUInteger len = string.length;
    // 汉字字符集
    NSString * pattern  = @"[\u4e00-\u9fa5]";
    NSError *error=nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    if(error)
    {
        NSLog(@"出错");
    }
    // 计算中文字符的个数
    NSUInteger numMatch = [regex numberOfMatchesInString:string options:NSMatchingReportProgress range:NSMakeRange(0, len)];
    *chineseCharCount=numMatch;
    
    return len + numMatch;
}

//计算并绘制字符串文本的高度
+(CGSize)getSuitSizeWithString:(NSString *)text fontSize:(float)fontSize bold:(BOOL)bold sizeOfX:(float)x
{
    UIFont *font ;
    if (bold) {
        font = [UIFont boldSystemFontOfSize:fontSize];
    }else{
        font = [UIFont systemFontOfSize:fontSize];
    }
    
    CGSize constraint = CGSizeMake(x, MAXFLOAT);
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    // 返回文本绘制所占据的矩形空间。
    CGSize contentSize = [text boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    return contentSize;
}



+(CGSize)getSuitSizeWidthWithString:(NSString *)text fontSize:(float)fontSize sizeOfY:(float)y{
    
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    
    CGSize constraint = CGSizeMake(MAXFLOAT, y);
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    // 返回文本绘制所占据的矩形空间。
    CGSize contentSize = [text boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    return contentSize;
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

/*!
 @brief 空返回YES
 @string string
 */
+ (BOOL)isBlankString:(NSString *)string
{
    if (string == nil || string == NULL ||[string isEqual:@""]||[string isEqual:@"<null>"])
        return YES;
    
    if ([string isKindOfClass:[NSNull class]])
        return YES;
    //判断是不是空格
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0)
        return YES;
    
    return NO;
}


+(BOOL)judgeResposeIsBlank:(id )responseData
{
    if([responseData isKindOfClass:[NSString class]]){
        return ![HUDHelper isBlankString:responseData];
    }
    
    if([responseData isKindOfClass:[NSArray class]] && [responseData count]>0){
        return YES;
    }
    
    if([responseData isKindOfClass:[NSDictionary class]] && [responseData allKeys].count){
        return YES;
    }
    return NO;
}

//两个字符串是否是包含关系
+(BOOL)isContainsString:(NSString *)firstStr second:(NSString*)secondStr{
    
    if (IOS8_OR_LATER) {
        return [firstStr containsString:secondStr];
    }else{
        NSRange lengthRange = [firstStr rangeOfString:secondStr];
       return  lengthRange.length?YES: NO;
    }
}


//截取字符；
+(NSString *)timeString:(NSString *)timeStr range:(NSUInteger)range
{
    if (![self isBlankString:timeStr]) {
        if (timeStr.length > range) {
            return [timeStr substringToIndex:range];
        }else{
            return timeStr;
        }
    }else{
        return @"";
    }
}


#pragma mark -字典或者数组转json
+(NSString*)converseToJsonWithObject:(id)obj{
    NSError *error = nil;
    //NSJSONWritingPrettyPrinted:指定生成的JSON数据应使用空格旨在使输出更加可读。如果这个选项是没有设置,最紧凑的可能生成JSON表示。
    NSData *jsonData = [NSJSONSerialization
                        dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString ;
    if ([jsonData length] > 0 && error == nil){
//        DLog(@"Successfully serialized the dictionary into data.");
        //NSData转换为String
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"JSON String = %@", jsonString);
        
        return jsonString;
    }
    else if ([jsonData length] == 0 &&
             error == nil){
        NSLog(@"No data was returned after serialization.");
    }
    else if (error != nil){
        NSLog(@"An error happened = %@", error);
    }
    
    return nil;
    
}

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
+(NSMutableAttributedString*)createTextKitWithString:(NSString*)string attributes:(NSDictionary*)attributes image:(NSString*)imageName index:(NSInteger)index{
    //图文混排
    NSMutableAttributedString *titleString = [[NSMutableAttributedString alloc]initWithString:string attributes:attributes];
    WCAttachmentText *textAttachment = [[WCAttachmentText alloc]initWithData:nil ofType:nil];
    UIImage *showImage = [UIImage imageNamed:imageName];
    textAttachment.image = showImage;
    
    NSAttributedString *textAttschmentString = [NSAttributedString attributedStringWithAttachment:textAttachment];
    
    [titleString insertAttributedString:textAttschmentString atIndex:index];
    return  titleString;
}

/*!
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

//  将数组重复的对象去除，只保留一个
+ (NSArray *)arrayWithMemberIsOnly:(NSArray *)array
{
    NSMutableArray *categoryArray = [NSMutableArray array];
    for (unsigned i = 0; i < [array count]; i++) {
        
        if ([categoryArray containsObject:[array objectAtIndex:i]] == NO) {
            [categoryArray addObject:[array objectAtIndex:i]];
        }
    }
    return categoryArray;
}


#pragma mark - 通过颜色值生成图片
+ (UIImage *)buttonImageFromColor:(UIColor *)color size:(CGSize)size{
    
    CGRect rect = CGRectMake(0,0,size.width,size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

#pragma mark - 裁剪图片
+ (UIImage *)clipsToRect:(CGRect)rect image:(UIImage*)orangeImage{
    CGRect maxRect = CGRectMake(0, 0, orangeImage.size.width, orangeImage.size.height);
    CGImageRef imageRef = CGImageCreateWithImageInRect(orangeImage.CGImage,maxRect);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //    CGContextTranslateCTM(ctx, 0, orangeImage.size.height);
    //    CGContextScaleCTM(ctx, 1, -1);
    CGContextDrawImage(ctx, CGRectMake(rect.origin.x, rect.origin.y, orangeImage.size.width, rect.size.height), orangeImage.CGImage);
    CGContextClipToRect(ctx, rect);
    UIImage *image = [UIImage imageWithCGImage:imageRef];
    UIGraphicsEndImageContext();
    CGImageRelease(imageRef);
    return image;
}

#pragma mark -图片压缩处理
+(UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0,0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    //返回新的改变大小后的图片
    return scaledImage;
}


/**
 * @brief  指定宽度压缩图片
 */
+ (UIImage *)scaleToSize:(UIImage *)img sizeW:(CGFloat)changeW{
    
    CGFloat imageW = img.size.width;
    CGFloat imageH = img.size.height;
    CGFloat changeH = (changeW*imageH)/imageW;
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(CGSizeMake(changeW, changeH));
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0,0, changeW, changeH)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    //返回新的改变大小后的图片
    return scaledImage;
}


+(void)setImageFitWithImageView:(UIImageView*)imageView{
    
    [imageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
    imageView.contentMode =  UIViewContentModeScaleAspectFill;
    imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    imageView.clipsToBounds  = YES;
}


+(void)makeScale:(UIView*)scaleView delegate:(id)delegate scale:(CGFloat)scale duration:(CFTimeInterval)duration
{
    
    scaleView.layer.transform = CATransform3DIdentity;
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    CATransform3D tr0 = CATransform3DMakeScale(1, 1, 1);
    CATransform3D tr1 = CATransform3DMakeScale(scale, scale, 1);
    CATransform3D tr2 = CATransform3DMakeScale(1, 1, 1);
    NSArray *frameValues = [NSArray arrayWithObjects:
                            [NSValue valueWithCATransform3D:tr0],
                            [NSValue valueWithCATransform3D:tr1],
                            [NSValue valueWithCATransform3D:tr2],
                            nil];
    [animation setValues:frameValues];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.duration = duration;
    animation.delegate = delegate;
    [scaleView.layer addAnimation:animation forKey:@"ShakedAnimation"];
}

#pragma mark -角度转弧度
double radians(float degrees) {
    return ( degrees * M_PI ) / 180.0;
}


+(void)rotationView:(UIView*)view duration:(CGFloat)duration delegate:(id)delegate
{
    view.layer.transform=CATransform3DIdentity;
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    CATransform3D tr0 = CATransform3DMakeRotation(radians(0),     0, 0,1);
    CATransform3D tr1 = CATransform3DMakeRotation(radians(90),    0, 0,1);
    CATransform3D tr2 = CATransform3DMakeRotation(radians(180.0), 0, 0,1);
    CATransform3D tr3 = CATransform3DMakeRotation(radians(270.0), 0, 0,1);
    CATransform3D tr4 = CATransform3DMakeRotation(radians(0), 0,  0,1);
    NSArray *frameValues = [NSArray arrayWithObjects:
                            [NSValue valueWithCATransform3D:tr0],
                            [NSValue valueWithCATransform3D:tr1],
                            [NSValue valueWithCATransform3D:tr2],
                            [NSValue valueWithCATransform3D:tr3],
                            [NSValue valueWithCATransform3D:tr4],
                            nil];
    [animation setValues:frameValues];
    animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.duration = duration;
    animation.repeatCount=HUGE_VALF;
    animation.delegate=delegate;
    [view.layer addAnimation:animation forKey:@"RotationAnimation"];
}


#pragma mark------对动画的处理
+(void)floatAnimator:(UIView *)animator
{
    animator.layer.transform=CATransform3DIdentity;
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    CATransform3D tr0 = CATransform3DMakeTranslation(0, 0, 0);
    CATransform3D tr1 = CATransform3DMakeTranslation(-15, 0, 0);
    CATransform3D tr3 = CATransform3DMakeTranslation(0, 0, 0);
    NSArray *frameValues = [NSArray arrayWithObjects:
                            [NSValue valueWithCATransform3D:tr0],
                            [NSValue valueWithCATransform3D:tr1],
                            [NSValue valueWithCATransform3D:tr3],
                            nil];
    [animation setValues:frameValues];
    animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.duration = 1.4;
    animation.repeatCount=10000;
    [animator.layer addAnimation:animation forKey:@"ShakedAnimation"];
}


+ (UIImage*) BgImageFromColors:(NSArray*)colors withFrame: (CGRect)frame{
    
    NSMutableArray *ar = [NSMutableArray array];
    for(UIColor *c in colors) {
        [ar addObject:(id)c.CGColor];
    }
    //开始生成
    UIGraphicsBeginImageContextWithOptions(frame.size, YES, 1);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    //定义颜色空间
    CGColorSpaceRef colorSpace = CGColorGetColorSpace([[colors lastObject] CGColor]);
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)ar, NULL);
    //设置起点和终点
    CGPoint start,end;;
    start = CGPointMake(0.0, frame.size.height);
    end = CGPointMake(frame.size.width, 0.0);
    //绘制图形
    CGContextDrawLinearGradient(context, gradient, start, end,kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    //生成图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    //释放
    CGGradientRelease(gradient);
    CGContextRestoreGState(context);
    CGColorSpaceRelease(colorSpace);
    UIGraphicsEndImageContext();
    
    return image;
    
}


+ (UIImage *)imageWithColor:(UIColor *)color
{
    // 描述矩形
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    
    // 开启位图上下文
    UIGraphicsBeginImageContext(rect.size);
    // 获取位图上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 使用color演示填充上下文
    CGContextSetFillColorWithColor(context, [color CGColor]);
    // 渲染上下文
    CGContextFillRect(context, rect);
    // 从上下文中获取图片
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    // 结束上下文
    UIGraphicsEndImageContext();
    
    return theImage;
}

#pragma mark -百度转火星坐标
+(CLLocation*)transformFromBaiDuToGoogle:(CLLocation*)baidu{
    
    double x = baidu.coordinate.longitude - 0.0065, y = baidu.coordinate.latitude - 0.006;
    double z = sqrt(x * x + y * y) - 0.00002 * sin(y * _x_pi);
    double theta = atan2(y, x) - 0.000003 * cos(x * _x_pi);
    double gg_lon = z * cos(theta);
    double gg_lat = z * sin(theta);
    return [[CLLocation alloc]initWithLatitude:gg_lat longitude:gg_lon];
}

#pragma mark -火星转百度坐标
+(CLLocation*)transformFromGoogleToBaiDu:(CLLocation*)google
{
    double x = google.coordinate.longitude, y =  google.coordinate.latitude;
    double z = sqrt(x * x + y * y) + 0.00002 * sin(y * _x_pi);
    double theta = atan2(y, x) + 0.000003 * cos(x * _x_pi);
    
    double bd_lon=z * cos(theta) + 0.0065;
    double bd_lat = z * sin(theta) + 0.006;
    
    return [[CLLocation alloc]initWithLatitude:bd_lat longitude:bd_lon];
}


+(void)makeNumChangeWithView:(UILabel*)label string:(NSString*)suffix FromValue:(CGFloat)from toValue:(CGFloat)to time:(CGFloat)time{
    
    //此对象的属性不在Pop Property的标准属性中，要创建一个POPAnimationProperty
    POPAnimatableProperty *prop = [POPAnimatableProperty propertyWithName:@"countdown" initializer:^(POPMutableAnimatableProperty *prop) {
        prop.writeBlock = ^(id obj, const CGFloat values[]) {
            label.text = [NSString stringWithFormat:@"%d%@",(int)values[0],suffix];
        };
        prop.threshold = 0.01f;
    }];
    POPBasicAnimation *anBasic = [POPBasicAnimation linearAnimation];   //秒表当然必须是线性的时间函数
    anBasic.property = prop;    //自定义属性
    anBasic.fromValue = @(from);   //从0开始
    anBasic.toValue = @(to);  //180秒
    anBasic.duration = time;    //持续3分钟
    anBasic.beginTime = CACurrentMediaTime();    //延迟1秒开始
    [label pop_addAnimation:anBasic forKey:@"countdown"];
    
}


+(CALayer*)drawLineGradient:(UIColor*)topColor
                buttomColor:(UIColor*)buttomColor
                 startpoint:(CGPoint)startPoint
                   endpoint:(CGPoint)endPoint
                      frame:(CGRect)frame
{
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.colors = [NSArray arrayWithObjects:
                       (id)topColor.CGColor,
                       (id)buttomColor.CGColor,nil];
    // 起始点
    gradient.startPoint = startPoint;
    
    // 结束点
    gradient.endPoint = endPoint;
    gradient.frame = frame;
    return gradient;
    
}


+(UIView *)createFrostedglassEffectWithFrame:(CGRect)frame{
    UIBlurEffect *blurEffect=[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *visualEffectView=[[UIVisualEffectView alloc]initWithEffect:blurEffect];
    [visualEffectView setFrame:frame];
    return visualEffectView;
}


+(void)setControlView:(UIView*)view corner:(CGFloat)cornerRadius borderW:(CGFloat)borderWidth borderColor:(UIColor *)borderColor{
    view.layer.cornerRadius = cornerRadius;
    view.layer.masksToBounds = YES;
    if (borderWidth) {
        view.layer.borderColor  = borderColor.CGColor;
        view.layer.borderWidth  = borderWidth;
    }
}

#pragma mark -给UILabel设置行间距和字间距
+(void)setLabelSpace:(UILabel*)label withValue:(NSString*)str withFont:(UIFont*)font color:(UIColor*)color space:(CGFloat)lineSpace{
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = lineSpace; //设置行间距
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    //设置字间距 NSKernAttributeName:@1.5f
    UIColor *defaultColor = color?color:[UIColor blackColor];
    NSDictionary *dic = @{NSFontAttributeName:font,
                          NSParagraphStyleAttributeName:paraStyle,
                          NSKernAttributeName:@1.5f,
                          NSForegroundColorAttributeName:defaultColor};
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:str attributes:dic];
    label.attributedText = attributeStr;
}


#pragma mark -计算UILabel的高度(带有行间距的情况)
+(CGFloat)getSpaceLabelHeight:(NSString*)str withFont:(UIFont*)font withWidth:(CGFloat)width space:(CGFloat)lineSpace{
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = lineSpace;
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    NSDictionary *dic = @{NSFontAttributeName:font,
                          NSParagraphStyleAttributeName:paraStyle,
                          NSKernAttributeName:@1.5f};
    
    CGSize size = [str boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size.height;
}


+ (NSString *)flattenHTML:(NSString *)html {
    
    NSScanner *theScanner;
    NSString *text = nil;
    theScanner = [NSScanner scannerWithString:html];
    while ([theScanner isAtEnd] == NO) {
        [theScanner scanUpToString:@"<" intoString:NULL] ;
        [theScanner scanUpToString:@">" intoString:&text] ;
        html = [html stringByReplacingOccurrencesOfString:
                [NSString stringWithFormat:@"%@>", text]
                                               withString:@""];
    }
    return html;
}


//正则去除网络标签
+(NSString *)getZZwithString:(NSString *)string{
    NSRegularExpression *regularExpretion = [NSRegularExpression regularExpressionWithPattern:@"<[^>]*>|\n" options:0 error:nil];
    string = [regularExpretion stringByReplacingMatchesInString:string options:NSMatchingReportProgress range:NSMakeRange(0, string.length) withTemplate:@""];
    return string;
}
@end
