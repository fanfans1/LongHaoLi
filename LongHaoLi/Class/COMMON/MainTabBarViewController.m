//
//  MainTabBarViewController.m
//  Longhaoli
//
//  Created by 亿缘 on 2017/7/8.
//  Copyright © 2017年 亿缘. All rights reserved.
//

#import "MainTabBarViewController.h"
#import "ConsumptionViewController.h"       // 消费
#import "HomeViewController.h"              // 首页
#import "MineViewController.h"              // 我的
#import "TicketPackageViewController.h"     // 券包
#import "NearViewController.h"              // 附近

#import "CustomTabBar.h"
#import "CustomNavigationController.h"

@interface MainTabBarViewController ()<CustomTabBarDelegate>

@end

@implementation MainTabBarViewController


#pragma mark - 第一次使用当前类的时候对设置UITabBarItem的主题
+ (void)initialize
{
    UITabBarItem *tabBarItem = [UITabBarItem appearanceWhenContainedInInstancesOfClasses:@[self]];
    
    NSMutableDictionary *dictNormal = [NSMutableDictionary dictionary];
    dictNormal[NSForegroundColorAttributeName] = [UIColor grayColor];
    dictNormal[NSFontAttributeName] = [UIFont systemFontOfSize:11];
    
    NSMutableDictionary *dictSelected = [NSMutableDictionary dictionary];
    dictSelected[NSForegroundColorAttributeName] = [UIColor darkGrayColor];
    dictSelected[NSFontAttributeName] = [UIFont systemFontOfSize:11];
    
    [tabBarItem setTitleTextAttributes:dictNormal forState:UIControlStateNormal];
    [tabBarItem setTitleTextAttributes:dictSelected forState:UIControlStateSelected];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
     [self setUpAllChildVc];
   
    CustomTabBar *tabbar = [[CustomTabBar alloc] init];
    tabbar.myDelegate = self;
    [self setValue:tabbar forKey:@"tabBar"];
   
    
    self.tabBarItem.badgeValue = @"1";
    self.tabBarItem.badgeColor = [UIColor redColor];
    // Do any additional setup after loading the view.
}



#pragma mark - ------------------------------------------------------------------
#pragma mark - 初始化tabBar上除了中间按钮之外所有的按钮

- (void)setUpAllChildVc
{
    
    
    HomeViewController *HomeVC = [[HomeViewController alloc] init];
    [self setUpOneChildVcWithVc:HomeVC Image:@"home_normal" selectedImage:@"home_highlight" title:@"首页"];
    
    NearViewController *FishVC = [[NearViewController alloc] init];
    [self setUpOneChildVcWithVc:FishVC Image:@"fish_normal" selectedImage:@"fish_highlight" title:@"附近"];
//
    ConsumptionViewController *con = [[ConsumptionViewController alloc] init];
    [self setUpOneChildVcWithVc:con Image:@"message_highlight" selectedImage:@"message_highlight" title:@"消费"];
//
    TicketPackageViewController *MessageVC = [[TicketPackageViewController alloc] init];
    [self setUpOneChildVcWithVc:MessageVC Image:@"message_normal" selectedImage:@"message_highlight" title:@"券包"];

    MineViewController *MineVC = [[MineViewController alloc] init];
    [self setUpOneChildVcWithVc:MineVC Image:@"account_normal" selectedImage:@"account_highlight" title:@"我的"];
//
    
}

#pragma mark - 初始化设置tabBar上面单个按钮的方法

/**
 *  @author li bo, 16/05/10
 *
 *  设置单个tabBarButton
 *
 *  @param Vc            每一个按钮对应的控制器
 *  @param image         每一个按钮对应的普通状态下图片
 *  @param selectedImage 每一个按钮对应的选中状态下的图片
 *  @param title         每一个按钮对应的标题
 */
- (void)setUpOneChildVcWithVc:(UIViewController *)Vc Image:(NSString *)image selectedImage:(NSString *)selectedImage title:(NSString *)title
{
    CustomNavigationController *nav = [[CustomNavigationController alloc] initWithRootViewController:Vc];
    Vc.view.backgroundColor = [UIColor whiteColor];
  
    
    UIImage *myImage = [UIImage imageNamed:image];
    myImage = [myImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //tabBarItem，是系统提供模型，专门负责tabbar上按钮的文字以及图片展示
    Vc.tabBarItem.image = myImage;
    
    UIImage *mySelectedImage = [UIImage imageNamed:selectedImage];
    mySelectedImage = [mySelectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    Vc.tabBarItem.selectedImage = mySelectedImage;
    
    Vc.tabBarItem.title = title;
    
    Vc.navigationItem.title = title;
    
    [self addChildViewController:nav];
    UIColor* color = [UIColor whiteColor];
    NSDictionary* dict=[NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    nav.navigationBar.titleTextAttributes= dict;
    
}

#pragma mark - ------------------------------------------------------------------
#pragma mark - LBTabBarDelegate
//点击中间按钮的代理方法
- (void)tabBarPlusBtnClick:(CustomTabBar *)tabBar
{
    
//    NSLog(@"%@",self.tabBarController.selectedIndex);
    self.selectedIndex = 2;

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
