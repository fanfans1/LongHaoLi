//
//  RollInfoModel.h
//  LongHaoLi
//
//  Created by Guang shen on 2017/8/21.
//  Copyright © 2017年 fanfan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RollInfoModel : NSObject


@property (nonatomic, strong)NSString * rollId;
@property (nonatomic, strong)NSString *intro;
@property (nonatomic, assign)float juli;
@property (nonatomic, strong)NSString *name;
@property (nonatomic, assign)float originalPrice ;
@property (nonatomic, strong)NSString *photo;
@property (nonatomic, assign)float salePrice;
@property (nonatomic, strong)NSString *shopId;
@property (nonatomic, assign)int surplusCount;
@property (nonatomic, assign)int virtualGoogs;
@property (nonatomic, retain)NSString *offerDetails;  // 优惠详情

+(RollInfoModel*)setModelWithDictionary:(NSDictionary *)dic;

@end



