//
//  TempleModel.m
//  LongHaoLi
//
//  Created by Guang shen on 2017/8/17.
//  Copyright © 2017年 fanfan. All rights reserved.
//

#import "TempleModel.h"

@implementation TempleModel

//  防止崩溃
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if([key isEqualToString:@"id"]){
        self.shopId = value;
        
    }
}

+ (TempleModel *)setModelWithDictionary:(NSDictionary *)dic {
    
    TempleModel *tick = [[TempleModel alloc] init];
    
    [tick setValuesForKeysWithDictionary:dic];
    
    return tick;
}


@end
