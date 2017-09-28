//
//  RollInfoModel.m
//  LongHaoLi
//
//  Created by Guang shen on 2017/8/21.
//  Copyright © 2017年 fanfan. All rights reserved.
//

#import "RollInfoModel.h"

@implementation RollInfoModel
//  防止崩溃
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if([key isEqualToString:@"id"]){
        self.rollId = value ;
        
    }
}

+ (RollInfoModel *)setModelWithDictionary:(NSDictionary *)dic {
    
    RollInfoModel *tick = [[RollInfoModel alloc] init];
    
    [tick setValuesForKeysWithDictionary:dic];
    
    return tick;
}


@end
