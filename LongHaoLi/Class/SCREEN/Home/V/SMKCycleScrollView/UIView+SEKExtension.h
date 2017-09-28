//
//  UIView+SEKExtension.h
//
//
//  Created by yy on 2016/11/29.
//  Copyright © 2016年 fanfan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (SMKExtension)

@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;

/**
 * 判断一个控件是否真正显示在主窗口
 */
- (BOOL)isShowingOnKeyWindow;

+ (instancetype)viewFromXib;

- (UIView *)findFirstResponder;


@end
