//
//  AppDelegate.h
//  Longhaoli
//
//  Created by 亿缘 on 2017/7/7.
//  Copyright © 2017年 亿缘. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MainTabBarViewController.h"

// 极光推送
static NSString *appKey = @"db980cc1825773a5a0f3a921";
static NSString *channel = @"Publish channel";
static BOOL isProduction = YES;


@interface AppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate>

//yiyuan.Foods

@property (nonatomic, retain) CLLocationManager *locationManager;
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;
//@property (nonatomic, retain)UIAlertController *alertC;

//@property (nonatomic, retain)MainTabBarViewController *main;

@end

