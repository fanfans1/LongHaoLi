//
//  SGGenerateQRCodeVC.m
//  SGQRCodeExample
//
//
//  ViewController.h
//  ErWeiMa
//
//  Created by yy on 2016/12/8.
//  Copyright © 2016年 fanfan. All rights reserved.
//


#import "SGGenerateQRCodeVC.h"
#import "SGQRCodeTool.h"

@interface SGGenerateQRCodeVC ()

@end

@implementation SGGenerateQRCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
 
    
    // 生成二维码(中间带有图标)
    [self setupGenerate_Icon_QRCode];
    
 

}

// 生成二维码


#pragma mark - - - 中间带有图标二维码生成
- (void)setupGenerate_Icon_QRCode {
    
    // 1、借助UIImageView显示二维码
    UIImageView *imageView = [[UIImageView alloc] init];
    CGFloat imageViewW = 150;
    CGFloat imageViewH = imageViewW;
    CGFloat imageViewX = (self.view.frame.size.width - imageViewW) / 2;
    CGFloat imageViewY = 240;
    imageView.frame =CGRectMake(imageViewX, imageViewY, imageViewW, imageViewH);
    [self.view addSubview:imageView];
    
    // 2、将最终合得的图片显示在UIImageView上
    imageView.image = [SGQRCodeTool SG_generateWithLogoQRCodeData:self.str logoImageName:@"icon_image" logoWidth:100];
    
}




@end



