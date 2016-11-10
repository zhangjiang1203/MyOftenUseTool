//
//  UIView+MBIBnspectable.m
//  ToolsTestDemo
//
//  Created by pg on 16/5/17.
//  Copyright © 2016年 DZHFCompany. All rights reserved.
//

#import "UIView+MBIBnspectable.h"

@implementation UIView (MBIBnspectable)

-(CGFloat)cornerRadius{
    return self.layer.cornerRadius;
}

-(void)setCornerRadius:(CGFloat)cornerRadius{
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = cornerRadius > 0;
}


-(UIColor *)borderColor{
    return [UIColor colorWithCGColor:self.layer.borderColor];
}

-(void)setBorderColor:(UIColor *)borderColor{
    self.layer.borderColor = borderColor.CGColor;
}


-(CGFloat)borderWidth{
    return self.layer.borderWidth;
}

-(void)setBorderWidth:(CGFloat)borderWidth{
    self.layer.borderWidth = borderWidth;
}

@end
