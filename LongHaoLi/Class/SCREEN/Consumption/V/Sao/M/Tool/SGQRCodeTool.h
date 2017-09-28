//
//  SGQRCodeTool.h
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
#import <CoreImage/CoreImage.h>

@interface SGQRCodeTool : NSObject
/** 生成一张普通的二维码 */
+ (UIImage *)SG_generateWithDefaultQRCodeData:(NSString *)data imageViewWidth:(CGFloat)imageViewWidth;
/** 生成一张带有logo的二维码 */
+ (UIImage *)SG_generateWithLogoQRCodeData:(NSString *)data logoImageName:(NSString *)logoImageName logoWidth:(CGFloat)logoWidth;
/** 生成一张彩色的二维码 */
+ (UIImage *)SG_generateWithColorQRCodeData:(NSString *)data backgroundColor:(CIColor *)backgroundColor mainColor:(CIColor *)mainColor;

@end
