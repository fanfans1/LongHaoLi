//
//  GetUserContentViewController.h
//  Longhaoli
//
//  Created by 亿缘 on 2017/7/21.
//  Copyright © 2017年 亿缘. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^returnPhoneNum)(NSString *phone);


@interface GetUserContentViewController : UIViewController


@property (nonatomic, copy) returnPhoneNum phoneBlock;

// 图片返回Block
- (void)returnPhoneNum:(returnPhoneNum)block;

@end
