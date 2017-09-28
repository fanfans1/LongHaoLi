//
//  HomeTicketDetialShopTableViewCell.h
//  LongHaoLi
//
//  Created by Guang shen on 2017/8/17.
//  Copyright © 2017年 fanfan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HomeTicketDetialShopTableViewCellDelegate <NSObject>

- (void)makeLogin;
- (void)callPhone;

@end

@interface HomeTicketDetialShopTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *desc;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (nonatomic, weak)id<HomeTicketDetialShopTableViewCellDelegate>delegate;

@end
