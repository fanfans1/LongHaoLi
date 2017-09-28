//
//  TempleModel.h
//  LongHaoLi
//
//  Created by Guang shen on 2017/8/17.
//  Copyright © 2017年 fanfan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TempleModel : NSObject

@property (nonatomic, retain)NSString *shopId;
@property (nonatomic, retain)NSString *name;
@property (nonatomic, retain)NSString *intro;
@property (nonatomic, retain)NSString *photo;


+(TempleModel*)setModelWithDictionary:(NSDictionary *)dic;
@end
