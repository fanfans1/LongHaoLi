//
//  HomeHotTableViewCell.h
//  LongHaoLi
//
//  Created by Guang shen on 2017/8/8.
//  Copyright © 2017年 fanfan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HomeHotTableViewCellDelegate <NSObject>

- (void)dragonA;
- (void)friendA;
- (void)templeA;

@end

@interface HomeHotTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *dragonGift;
@property (weak, nonatomic) IBOutlet UIButton *friendPresent;
@property (weak, nonatomic) IBOutlet UIButton *temple;
@property (nonatomic, weak)id<HomeHotTableViewCellDelegate>delegate;

@end
