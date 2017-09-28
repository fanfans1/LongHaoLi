//
//  HomeModel.m
//  Longhaoli
//
//  Created by 亿缘 on 2017/7/19.
//  Copyright © 2017年 亿缘. All rights reserved.
//

#import "HomeModel.h"

@implementation HomeModel

/**
 *  构造
 *
 *  @param dic <#dic description#>
 *
 *  @return <#return value description#>
 */
- (instancetype)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
        //创建一个可变数组加载soldarray
        NSMutableArray *newArray = [NSMutableArray array];
        for (NSDictionary *dic in self.messageArray) {
            HomeModel2 *model = [[HomeModel2 alloc]initWithDic:dic];
            [newArray addObject:model];
        }
        self.messageArray = newArray;
    }
    return self;
}
@end

//第二个model
@implementation HomeModel2
/**
 *  构造
 *
 *  @param dic <#dic description#>
 *
 *  @return <#return value description#>
 */
- (instancetype)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}



@end
