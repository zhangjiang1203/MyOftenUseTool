//
//  UITextField+PlaceHolder.m
//  Pods
//
//  Created by DFHZ on 2017/6/30.
//
//

#import "UITextField+PlaceHolder.h"

@implementation UITextField (PlaceHolder)

-(void)setPlaceholder:(NSString *)placeholder color:(UIColor*)color font:(UIFont*)font{
    [self setValue:color forKeyPath:@"_placeholderLabel.textColor"];
    [self setValue:font  forKeyPath:@"_placeholderLabel.font"];
}

@end
