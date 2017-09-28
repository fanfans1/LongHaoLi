//
//  HomeTypeTableViewCell.m
//  LongHaoLi
//
//  Created by Guang shen on 2017/8/8.
//  Copyright © 2017年 fanfan. All rights reserved.
//

#import "HomeTypeTableViewCell.h"

@implementation HomeTypeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)foodAction:(id)sender {
    [self.delegate foodA];
}
- (IBAction)playAction:(id)sender {
    [self.delegate playA];
}
- (IBAction)lifeAction:(id)sender {
    [self.delegate lifeA];
}
- (IBAction)shoppingAction:(id)sender {
    [self.delegate shoppingA];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
