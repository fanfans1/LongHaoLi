//
//  Luck.h
//  抽奖
//  fan

//  Created by 亿缘 on 2017/7/15.
//  Copyright © 2017年 亿缘. All rights reserved.
//

#import <UIKit/UIKit.h>





@protocol LuckDelegate <NSObject>

- (void)luckViewDidStopWithArrayCount:(NSInteger)count;
- (void)luckSelectBtn:(UIButton *)btn;

@end

@interface Luck: UIView

/**
 *  图片地址，网络获取
 */



@property (assign, nonatomic) id<LuckDelegate> delegate;

@property (nonatomic, retain)NSArray *luckArr;
@property (strong, nonatomic) NSMutableArray *imageArray; // 奖品数组
@property (nonatomic, assign)int circleNum;
@property (nonatomic, assign)int prizeTime; // 抽奖次数

@end
