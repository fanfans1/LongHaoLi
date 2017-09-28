//
//  ConsumptionTableViewCell.h
//  LongHaoLi
//
//  Created by Guang shen on 2017/8/31.
//  Copyright © 2017年 fanfan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConsumptionTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (nonatomic, assign) BOOL isSelect;

@end
