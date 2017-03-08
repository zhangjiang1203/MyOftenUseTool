//
//  UITextView+PlaceHolder.h
//  IOS-Categories
//
//  Created by Jakey on 14/12/15.
//  Copyright (c) 2014年 www.skyfox.org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>
@interface UITextView (PlaceHolder) <UITextViewDelegate>
@property (nonatomic, strong) UITextView *placeHolderTextView;
//@property (nonatomic, assign) id <UITextViewDelegate> textViewDelegate;
/*
 * 设置显示的占位符和占位符颜色
 */
- (void)addPlaceHolder:(NSString *)placeHolder color:(UIColor*)color;
@end
