//
//  HomeTicketDetialShopTableViewCell.m
//  LongHaoLi
//
//  Created by Guang shen on 2017/8/17.
//  Copyright © 2017年 fanfan. All rights reserved.
//

#import "HomeTicketDetialShopTableViewCell.h"

@implementation HomeTicketDetialShopTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)local:(id)sender {
    [self.delegate makeLogin];
}
- (IBAction)phone:(id)sender {
    [self.delegate callPhone];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
