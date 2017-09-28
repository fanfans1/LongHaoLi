//
//  HomeModel.h
//  Longhaoli
//
//  Created by 亿缘 on 2017/7/19.
//  Copyright © 2017年 亿缘. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeModel : NSObject

@property(nonatomic,copy)NSString *familyName;//姓氏
@property(nonatomic,strong)NSArray *messageArray;//信息
- (instancetype)initWithDic:(NSDictionary *)dic;
@end

//第二个model
@interface HomeModel2 : NSObject
@property(nonatomic,copy)NSString *name;//姓名
@property(nonatomic,copy)NSString *sex;//性别
- (instancetype)initWithDic:(NSDictionary *)dic;

@end
