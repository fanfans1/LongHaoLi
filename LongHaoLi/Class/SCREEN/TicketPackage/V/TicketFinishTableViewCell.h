//
//  TicketFinishTableViewCell.h
//  LongHaoLi
//
//  Created by Guang shen on 2017/8/9.
//  Copyright © 2017年 fanfan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TicketFinishTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIImageView *picture;
@property (weak, nonatomic) IBOutlet UILabel *desc;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UILabel *butTime;
@property (weak, nonatomic) IBOutlet UILabel *useTime;
@property (weak, nonatomic) IBOutlet UIImageView *add;

@end
