//
//  AMapNaviViewController.m
//  Longhaoli
//
//  Created by 亿缘 on 2017/7/10.
//  Copyright © 2017年 亿缘. All rights reserved.
//

#import "AMapNaviViewController.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapNaviKit/AMapNaviKit.h>

@interface AMapNaviViewController ()<AMapNaviDriveManagerDelegate, AMapNaviDriveViewDelegate>

@property (nonatomic, strong) AMapNaviDriveManager *driveManager;
@property (nonatomic, strong) AMapNaviDriveView *driveView;
@property (nonatomic, strong) AMapNaviPoint *startPoint;
@property (nonatomic, strong) AMapNaviPoint *endPoint;


@end

@implementation AMapNaviViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
//    if (@available(iOS 11.0, *)) {
//        UIScrollViewContentInsetAdjustmentNever;
//    } else {
//        // Fallback on earlier versions
//    }
    //设置导航的起点和终点
    self.startPoint = [AMapNaviPoint locationWithLatitude:APPDELEGATE.latitude longitude:APPDELEGATE.longitude];
    self.endPoint   = [AMapNaviPoint locationWithLatitude:[self.latitudeX floatValue] longitude:[self.latitudeY floatValue]];
    
    //初始化AMapNaviDriveManager
    if (self.driveManager == nil)
    {
        self.driveManager = [[AMapNaviDriveManager alloc] init];
        [self.driveManager setDelegate:self];
    }
    
    //初始化AMapNaviDriveView
    if (self.driveView == nil)
    {
        self.driveView = [[AMapNaviDriveView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
        [self.driveView setDelegate:self];
    }
    
    //将AMapNaviManager与AMapNaviDriveView关联起来
    [self.driveManager addDataRepresentative:self.driveView];
    //将AManNaviDriveView显示出来
    [self.view addSubview:self.driveView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //路径规划
    [self.driveManager calculateDriveRouteWithStartPoints:@[self.startPoint]
                                                endPoints:@[self.endPoint]
                                                wayPoints:nil
                                          drivingStrategy:AMapNaviDrivingStrategySingleDefault];
}

//路径规划成功后，开始模拟导航
- (void)driveManagerOnCalculateRouteSuccess:(AMapNaviDriveManager *)driveManager
{
    [self.driveManager startGPSNavi];
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
