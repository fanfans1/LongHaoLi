//
//  HomeTicketShopListTableViewCell.m
//  LongHaoLi
//
//  Created by Guang shen on 2017/8/18.
//  Copyright © 2017年 fanfan. All rights reserved.
//

#import "HomeTicketShopListTableViewCell.h"

@implementation HomeTicketShopListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)local:(id)sender {
    [self.delegate makeLocal:self.model];
}
- (IBAction)phone:(id)sender {
    [self.delegate makePhone:self.model];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
