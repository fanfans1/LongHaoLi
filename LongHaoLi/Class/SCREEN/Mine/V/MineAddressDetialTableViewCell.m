//
//  MineAddressDetialTableViewCell.m
//  LongHaoLi
//
//  Created by Guang shen on 2017/8/9.
//  Copyright © 2017年 fanfan. All rights reserved.
//

#import "MineAddressDetialTableViewCell.h"

@implementation MineAddressDetialTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)changeSelect:(id)sender {
    [self.delegate selectAddress:sender];
}

@end
