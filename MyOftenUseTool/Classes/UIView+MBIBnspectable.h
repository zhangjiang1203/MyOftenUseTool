//
//  UIView+MBIBnspectable.h
//  ToolsTestDemo
//
//  Created by pg on 16/5/17.
//  Copyright © 2016年 DZHFCompany. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface UIView (MBIBnspectable)

@property (assign,nonatomic) IBInspectable CGFloat cornerRadius;

@property (assign,nonatomic) IBInspectable CGFloat borderWidth;

@property (strong,nonatomic) IBInspectable UIColor *borderColor;

@end
