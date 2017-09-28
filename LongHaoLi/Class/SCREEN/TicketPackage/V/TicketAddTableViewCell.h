//
//  TicketAddTableViewCell.h
//  LongHaoLi
//
//  Created by Guang shen on 2017/8/9.
//  Copyright © 2017年 fanfan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TicketAddTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *picture;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *type;

@end
