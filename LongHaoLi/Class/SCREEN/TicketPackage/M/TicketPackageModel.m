//
//  TicketPackageModel.m
//  LongHaoLi
//
//  Created by Guang shen on 2017/9/8.
//  Copyright © 2017年 fanfan. All rights reserved.
//

#import "TicketPackageModel.h"

@implementation TicketPackageModel

//  防止崩溃
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if([key isEqualToString:@"id"]){
        self.rollId = value;
        
    }
}

+ (TicketPackageModel *)setModelWithDictionary:(NSDictionary *)dic {
    
    TicketPackageModel *tick = [[TicketPackageModel alloc] init];
    
    [tick setValuesForKeysWithDictionary:dic];
    
    return tick;
}

@end
