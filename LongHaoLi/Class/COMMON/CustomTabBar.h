//
//  CustomTabBar.h
//  LongHaoLi
//
//  Created by Guang shen on 2017/8/14.
//  Copyright © 2017年 fanfan. All rights reserved.
//

#import <Foundation/Foundation.h>


@class CustomTabBar;

@protocol CustomTabBarDelegate <NSObject>
@optional
- (void)tabBarPlusBtnClick:(CustomTabBar *)tabBar;
@end


@interface CustomTabBar : UITabBar

/** tabbar的代理 */
@property (nonatomic, weak) id<CustomTabBarDelegate> myDelegate ;




@end
