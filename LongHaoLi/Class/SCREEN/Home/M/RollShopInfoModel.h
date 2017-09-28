//
//  RollShopInfoModel.h
//  LongHaoLi
//
//  Created by Guang shen on 2017/8/21.
//  Copyright © 2017年 fanfan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RollShopInfoModel : NSObject
@property (nonatomic, strong)NSString *addressShop; // 商圈
@property (nonatomic, strong)NSString *address; // 地址

@property (nonatomic, assign)int businessareaId;
@property (nonatomic, strong)NSString *juli;
@property (nonatomic, strong)NSString *latitudeX;
@property (nonatomic, strong)NSString *latitudeY;
@property (nonatomic, strong)NSString *linkPerson;
@property (nonatomic, strong)NSString * rollId;
@property (nonatomic, assign)int  linkTel;
@property (nonatomic, strong)NSString *name;
@property (nonatomic, strong)NSString *photo;
@property (nonatomic, strong)NSString *intro;
@property (nonatomic, strong)NSString *modelType;
@property (nonatomic, assign)int total;

+(RollShopInfoModel *)setModelWithDictionary:(NSDictionary *)dic;
@end
