//
//  ConsumptionViewController.m
//  LongHaoLi
//
//  Created by Guang shen on 2017/8/9.
//  Copyright © 2017年 fanfan. All rights reserved.
//

#import "ConsumptionViewController.h"
#import "SGQRCodeTool.h"
#import "SGAlertView.h"
#import "SGScanningQRCodeVC.h"
#import "ConsumptionSuccessViewController.h"

@interface ConsumptionViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *QRImage;
@property (weak, nonatomic) IBOutlet UIView *back;

@end

@implementation ConsumptionViewController

- (void)viewDidLoad {
    //123131123123123
    [super viewDidLoad];
    [self.navigationController.navigationBar setBarTintColor: BACKGROUNDCOLOR];
    self.QRImage.image = [SGQRCodeTool SG_generateWithLogoQRCodeData:@"123456789" logoImageName:@"" logoWidth:0];
    
    self.back.layer.masksToBounds = YES;
    self.back.layer.cornerRadius = 5;
    self.back.layer.borderColor = COLOUR(222, 222, 222).CGColor;
    self.back.layer.borderWidth = 1;
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)QRAction:(id)sender {
//    ConsumptionSuccessViewController *success= [[ConsumptionSuccessViewController alloc] init];
//    success.isChange = NO;
//    success.text = @"19.9";
//    [self.navigationController pushViewController: success animated:YES];
//    return;
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device) {
        SGScanningQRCodeVC *VC = [[SGScanningQRCodeVC alloc] init];
        VC.views = self;
        [self.navigationController pushViewController:VC animated:YES];
    } else {
        SGAlertView *alertView = [SGAlertView alertViewWithTitle:@"⚠️ 警告" delegate:nil contentTitle:@"未检测到您的摄像头, 请在真机上测试" alertViewBottomViewType:(SGAlertViewBottomViewTypeOne)];
        [alertView show];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
    ISLOGIN
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
