//
//  UserMassage.h
//  LongHaoLiShop
//
//  Created by 亿缘 on 2017/7/18.
//  Copyright © 2017年 亿缘. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserMassageModel : NSObject



// 是否登录 0 没有 1商户 2员工
@property (nonatomic, strong)NSString *isLogin;

// 用户ID
@property (nonatomic, strong)NSString *userid;

// 用户昵称
@property (nonatomic, strong)NSString *name;

// 用户电话
@property (nonatomic, strong)NSString *phone;

// 用户头像
@property (nonatomic, strong)NSString *alia;


- (instancetype)initWithDic:(NSDictionary *)dic;



@end
