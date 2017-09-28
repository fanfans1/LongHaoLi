//
//  ZmjPickView.h
//  Longhaoli
//
//  Created by 亿缘 on 2017/7/21.
//  Copyright © 2017年 亿缘. All rights reserved.
//

#import <UIKit/UIKit.h>

// 屏幕宽度
#define ScreenWidth [UIScreen mainScreen].bounds.size.width

// 屏幕高度
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

typedef void(^determineBtnActionBlock)(NSInteger shengId, NSInteger shiId, NSInteger xianId, NSString *shengName, NSString *shiName, NSString *xianName);

@interface ZmjPickView : UIView

@property (copy, nonatomic) determineBtnActionBlock determineBtnBlock;

- (void)show;

- (void)dismiss;

@end
