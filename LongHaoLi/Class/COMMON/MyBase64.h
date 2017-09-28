//
//  MyBase64.h
//  LongHaoLi
//
//  Created by Guang shen on 2017/8/29.
//  Copyright © 2017年 fanfan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyBase64 : NSObject
+(NSString *)base64EncodingWithData:(NSString *)sourceData;//base64加密
+(id)base64EncodingWithString:(NSString *)sourceString;//base64解密
+(NSString*)getCurrentTimestamp; // 获取时间戳
+(NSString *)timestampSwitchTime:(NSInteger)timestamp; // 时间戳转时间


+ (NSString *)stringConpanSteing:(NSString *)str; // 字符串替换


@end
