//
//  RollShopInfoModel.m
//  LongHaoLi
//
//  Created by Guang shen on 2017/8/21.
//  Copyright © 2017年 fanfan. All rights reserved.
//

#import "RollShopInfoModel.h"

@implementation RollShopInfoModel

//  防止崩溃
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {

}

+ (RollShopInfoModel *)setModelWithDictionary:(NSDictionary *)dic {
    
    RollShopInfoModel *tick = [[RollShopInfoModel alloc] init];
    
    [tick setValuesForKeysWithDictionary:dic];
    
    return tick;
}
@end
