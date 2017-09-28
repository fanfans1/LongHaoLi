//
//  HomeTicketShopListTableViewCell.h
//  LongHaoLi
//
//  Created by Guang shen on 2017/8/18.
//  Copyright © 2017年 fanfan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RollShopInfoModel.h"

@protocol HomeTicketShopListTableViewCellDelegate <NSObject>


- (void)makePhone:(RollShopInfoModel *)dic;

- (void)makeLocal:(RollShopInfoModel *)dic;

@end

@interface HomeTicketShopListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *desc;
@property (weak, nonatomic) IBOutlet UILabel *local;
@property (nonatomic, strong)RollShopInfoModel *model;
@property (weak, nonatomic) IBOutlet UIImageView *shopImage;

@property (nonatomic, weak)id<HomeTicketShopListTableViewCellDelegate>delegate;
@end
