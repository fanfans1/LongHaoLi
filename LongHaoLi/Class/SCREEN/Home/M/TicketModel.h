//
//  TicketModel.h
//  LongHaoLi
//
//  Created by Guang shen on 2017/8/16.
//  Copyright © 2017年 fanfan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TicketModel : NSObject

@property (nonatomic, retain)NSString *rollId;
@property (nonatomic, retain)NSString *name;
@property (nonatomic, retain)NSString *shopId;
@property (nonatomic, retain)NSString *photo;
@property (nonatomic, assign)int virtualGoogs;  // 券类型

@property (nonatomic, assign)float originalPrice;   // 原价
@property (nonatomic, assign)float salePrice;  // 售卖
@property (nonatomic, assign)float purchase; // 采购价
@property (nonatomic, retain)NSString *intro;
@property (nonatomic, assign)int count;
@property (nonatomic, assign)int surplusCount; // 剩余份数
@property (nonatomic, assign)int payType;
@property (nonatomic, retain)NSString *offerDetails;  // 优惠详情
@property (nonatomic, assign)int buyCount;  // 购买次数
@property (nonatomic, assign)int useCount;  // 使用次数
@property (nonatomic, assign)int modelType; // 类型
@property (nonatomic, retain)NSString *addressShop;
@property (nonatomic, retain)NSString *addTime;
@property (nonatomic, retain)NSString *useEndTime;
@property (nonatomic, assign)int status;
@property (nonatomic, assign)int addPersone;
@property (nonatomic, assign)int auditPerson;   

+(TicketModel*)setModelWithDictionary:(NSDictionary *)dic;
@end
