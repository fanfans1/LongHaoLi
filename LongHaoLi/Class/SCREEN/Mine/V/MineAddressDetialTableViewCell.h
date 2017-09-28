//
//  MineAddressDetialTableViewCell.h
//  LongHaoLi
//
//  Created by Guang shen on 2017/8/9.
//  Copyright © 2017年 fanfan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MineAddressDetialTableViewCellDelegate <NSObject>

- (void)selectAddress:(UIButton *)btn;

@end

@interface MineAddressDetialTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UIButton *select;
 
@property (nonatomic, weak)id<MineAddressDetialTableViewCellDelegate>delegate;

@end
