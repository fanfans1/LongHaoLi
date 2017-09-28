//
//  CalendarModel.h
//  LongHaoLi
//
//  Created by Guang shen on 2017/8/25.
//  Copyright © 2017年 fanfan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalendarModel : NSObject


@property (nonatomic, strong)NSString *calendarid; // 地址


@property (nonatomic, strong)NSString *userId;
@property (nonatomic, assign)NSInteger  time;
@property (nonatomic, strong)NSString *reminderTime;
@property (nonatomic, strong)NSString *title;


+(CalendarModel *)setModelWithDictionary:(NSDictionary *)dic;

@end
