//
//  TicketModel.m
//  LongHaoLi
//
//  Created by Guang shen on 2017/8/16.
//  Copyright © 2017年 fanfan. All rights reserved.
//

#import "TicketModel.h"

@implementation TicketModel



//  防止崩溃
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if([key isEqualToString:@"id"]){
        self.rollId = value;
    }
}

+ (TicketModel *)setModelWithDictionary:(NSDictionary *)dic {
    
    TicketModel *tick = [[TicketModel alloc] init];
    
    [tick setValuesForKeysWithDictionary:dic];
    
    return tick;
}



@end
