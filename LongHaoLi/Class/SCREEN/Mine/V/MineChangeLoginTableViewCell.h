//
//  MineChangeLoginTableViewCell.h
//  LongHaoLi
//
//  Created by Guang shen on 2017/8/9.
//  Copyright © 2017年 fanfan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MineChangeLoginTableViewCellDelegate <NSObject>

- (void)change;

@end

@interface MineChangeLoginTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *changeLogin;
@property (nonatomic, weak)id<MineChangeLoginTableViewCellDelegate>delegate;

@end
