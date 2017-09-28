//
//  TicketPackageModel.h
//  LongHaoLi
//
//  Created by Guang shen on 2017/9/8.
//  Copyright © 2017年 fanfan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TicketPackageModel : NSObject


@property (nonatomic, retain)NSString *rollId;  // 券id
@property (nonatomic, retain)NSString *name;    // 券名字
@property (nonatomic, retain)NSString *photo;   // 照片
@property (nonatomic, assign)float originalPrice;   // 原价
@property (nonatomic, assign)float salePrice;  // 售卖
@property (nonatomic, assign)int modelType; // 券类型
@property (nonatomic, retain)NSString *addressShop; // 地址
@property (nonatomic, retain)NSString *orderNum;    // 订单状态
@property (nonatomic, assign)int payType; // 支付状态
@property (nonatomic, assign)NSInteger EndTime;// 结束时间
@property (nonatomic, assign)NSInteger StartTime;// 结束时间
@property (nonatomic, assign)int ItemType;// 券类型
@property (nonatomic, retain)NSString *srID;    // 赠券类型
@property (nonatomic, retain)NSString *recordID;

+(TicketPackageModel *)setModelWithDictionary:(NSDictionary *)dic;



@end
