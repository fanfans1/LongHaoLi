//
//  HomeHotTableViewCell.m
//  LongHaoLi
//
//  Created by Guang shen on 2017/8/8.
//  Copyright © 2017年 fanfan. All rights reserved.
//

#import "HomeHotTableViewCell.h"

@implementation HomeHotTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)dragonAction:(id)sender {
    [self.delegate dragonA];
}
- (IBAction)friendAction:(id)sender {
    [self.delegate friendA];
}
- (IBAction)templeAction:(id)sender {
    [self.delegate templeA];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
