//
//  AppDelegate.m
//  Longhaoli
//
//  Created by 亿缘 on 2017/7/7.
//  Copyright © 2017年 亿缘. All rights reserved.
//

#import "AppDelegate.h"

// 激光 18220525413  Daming.123    APPKey：db980cc1825773a5a0f3a921
//短信宝
//546174057
//daming.123

// 更新版本
#import "XHVersion.h"
#import "LoginViewController.h"

// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
// 如果需要使用idfa功能所需要引入的头文件（可选）
#import <AdSupport/AdSupport.h>

#import "JPushHelper.h" // 推送封装
#import "SoundMake.h"   // 推送声音
#import "LaunchView.h"

@interface AppDelegate ()

@property (strong, nonatomic) UIButton *launchBtn;
@property (strong, nonatomic) LaunchView *launchView;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

//    [user setObject:@"0" forKey:@"login"];
    APPDELEGATE.window.rootViewController = [[MainTabBarViewController alloc] init];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:@"西安" forKey:@"city"];
    self.longitude = 0;
    self.latitude = 0;
    [self setMap];
    [self VersionButton];
//    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[LoginViewController alloc] init] ];
  // 版本设置
//    546174057@qq.com
//    18220525413.Com
    
 
    // 极光推送
    [self JPushApplication:application didFinishLaunchingWithOptions:launchOptions];

    [self initLaunchView];
    // Override point for customization after application launch.
    return YES;
}

-(void)initLaunchView {
    //    CGRect launchRect = CGRectMake(-20, 0, screen_width + 40, screen_height);
    self.launchView = [[LaunchView alloc] initWithFrame:self.window.bounds];
    //    self.launchView.alpha = 0.99;
    [self.window addSubview:self.launchView];
    [self.window bringSubviewToFront:self.launchView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.launchView removeFromSuperview];
    });
}

 

-(void)JPushApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    
    [JPushHelper setupWithOption:launchOptions appKey:appKey channel:channel apsForProduction:isProduction advertisingIdentifier:nil];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Required - 注册 DeviceToken
    
    [JPushHelper registerDeviceToken:deviceToken];
    
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required,For systems with less than or equal to iOS6
    [JPushHelper handleRemoteNotification:userInfo completion:nil];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // IOS 7 Support Required
    SoundMake *sund = [[SoundMake alloc] initSystemSoundWithName:@"sms-received1" SoundType:@"caf"];
    [sund play];
    [JPushHelper handleRemoteNotification:userInfo completion:completionHandler];
    // 应用正处理前台状态下，不会收到推送消息，因此在此处需要额外处理一下
    if (application.applicationState == UIApplicationStateActive) {
        if ([userInfo[@"aps"][@"alert"] isEqualToString:@"请重新登录"] ) {
            RESIGIONLOGIN;
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"下线通知" message:@"你的账号在另一个设备登录，如非本人操作，请及时修改密码！" preferredStyle:UIAlertControllerStyleAlert];
 
            [alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                
            }]];
            
            [[self window].rootViewController presentViewController:alert animated:YES completion:nil];
        }else{
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"您有新消息"
                                  message:userInfo[@"aps"][@"alert"]
                                  delegate:nil
                                  cancelButtonTitle:@"取消"
                                  otherButtonTitles:@"确定",nil];
            postNotification(@"tabBarItembadgeValue");
            [alert show];
        }
 
    }else{
        if ([userInfo[@"aps"][@"alert"] isEqualToString:@"请重新登录"] ) {
            RESIGIONLOGIN;

        }else{

            postNotification(@"tabBarItembadgeValue");

        }

    }
}


- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    //    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}


- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    [JPushHelper showLocalNotificationAtFront:notification];
    return;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [application setApplicationIconBadgeNumber:0];
    return;
}


 

- (void)VersionButton{
    [XHVersion checkNewVersion];
    
}
- (void)setMap{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    self.locationManager.distanceFilter = 1.0;
    // 设置地图类型(标准)
    [AMapServices sharedServices].apiKey = @"1063d0d293efd5df797f894ec015ed31";
    
    [_locationManager requestAlwaysAuthorization];
    [_locationManager requestWhenInUseAuthorization];
    
    [self.locationManager startUpdatingLocation];
}


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    self.longitude = newLocation.coordinate.longitude;
    self.latitude = newLocation.coordinate.latitude;
    CLLocation *location = newLocation;
    //反向地理编码
    
    CLGeocoder *clGeoCoder = [[CLGeocoder alloc] init];
    
    CLLocation *cl = [[CLLocation alloc] initWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
    
    [clGeoCoder reverseGeocodeLocation:cl completionHandler: ^(NSArray *placemarks,NSError *error) {
        
        for (CLPlacemark *placeMark in placemarks) {
            
            NSDictionary *addressDic = placeMark.addressDictionary;
            
            NSString *city=[addressDic objectForKey:@"City"];
      
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            [user setObject:city forKey:@"city"];
      
            [_locationManager stopUpdatingLocation];
            
        }
        
    }];

    [self.locationManager stopUpdatingLocation];
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    ALERT(@"定位失败");
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}





- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
