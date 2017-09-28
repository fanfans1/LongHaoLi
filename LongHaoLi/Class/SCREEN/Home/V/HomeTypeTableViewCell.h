//
//  HomeTypeTableViewCell.h
//  LongHaoLi
//
//  Created by Guang shen on 2017/8/8.
//  Copyright © 2017年 fanfan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HomeTypeTableViewCellDelegate <NSObject>

- (void)foodA;
- (void)playA;
- (void)lifeA;
- (void)shoppingA;

@end

@interface HomeTypeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *food;
@property (weak, nonatomic) IBOutlet UIButton *play;
@property (weak, nonatomic) IBOutlet UIButton *life;
@property (weak, nonatomic) IBOutlet UIButton *shopping;
@property (nonatomic, weak)id<HomeTypeTableViewCellDelegate>delegate;

@end
