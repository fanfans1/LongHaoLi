//
//  ScanSuccessJumpVC.h
//  SGQRCodeExample
//
//
//  ViewController.h
//  ErWeiMa
//
//  Created by yy on 2016/12/8.
//  Copyright © 2016年 fanfan. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface ScanSuccessJumpVC : UIViewController

/** 接收扫描的二维码信息 */
@property (nonatomic, copy) NSString *jump_URL;
/** 接收扫描的条形码信息 */
@property (nonatomic, copy) NSString *jump_bar_code;

@end
