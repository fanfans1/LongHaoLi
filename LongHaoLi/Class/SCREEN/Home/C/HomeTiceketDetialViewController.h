//
//  HomeTiceketDetialViewController.h
//  LongHaoLi
//
//  Created by Guang shen on 2017/8/17.
//  Copyright © 2017年 fanfan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TicketPackageModel.h"

@interface HomeTiceketDetialViewController : UIViewController

@property (nonatomic, retain)NSString *rollId;
@property (nonatomic, retain)NSString *type;
@property (nonatomic, retain)TicketPackageModel *model;
@property (nonatomic, assign)BOOL isTicketPackage;  // 是否是券包购买

@end
