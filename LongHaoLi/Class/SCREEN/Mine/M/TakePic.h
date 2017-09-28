//
//  TakePic.h
//  Longhaoli
//
//  Created by 亿缘 on 2017/7/19.
//  Copyright © 2017年 亿缘. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^TakeImageBlock)(NSData *image);

@interface TakePic : UIViewController


// 照相
- (void)alterHeadPortrait;



@property (nonatomic, copy) TakeImageBlock takeImageBlock;

// 图片返回Block
- (void)returnRoomName:(TakeImageBlock)block;


@end
