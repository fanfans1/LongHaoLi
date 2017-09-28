
//
//  CalendarModel.m
//  LongHaoLi
//
//  Created by Guang shen on 2017/8/25.
//  Copyright © 2017年 fanfan. All rights reserved.
//

#import "CalendarModel.h"

@implementation CalendarModel

//  防止崩溃
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if([key isEqualToString:@"id"]){
        self.calendarid = value;
        
    }
}

+ (CalendarModel *)setModelWithDictionary:(NSDictionary *)dic {
    
    CalendarModel *tick = [[CalendarModel alloc] init];
    
    [tick setValuesForKeysWithDictionary:dic];
    
    return tick;
}

@end
