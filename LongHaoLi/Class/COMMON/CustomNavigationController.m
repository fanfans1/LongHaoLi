//
//  CustomNavigationController.m
//  LongHaoLi
//
//  Created by Guang shen on 2017/8/14.
//  Copyright © 2017年 fanfan. All rights reserved.
//

#import "CustomNavigationController.h"

#import "UIImage+Image.h"

@interface CustomNavigationController ()

@end
//黄色导航栏
#define NavBarColor [UIColor colorWithRed:250/255.0 green:227/255.0 blue:111/255.0 alpha:1.0]

@implementation CustomNavigationController

//+ (void)load
//{
//    
//    
////    UIBarButtonItem *item=[UIBarButtonItem appearanceWhenContainedIn:self, nil ];
////    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
////    dic[NSFontAttributeName]=[UIFont systemFontOfSize:15];
////    dic[NSForegroundColorAttributeName]=[UIColor blackColor];
////    [item setTitleTextAttributes:dic forState:UIControlStateNormal];
//    
//    UINavigationBar *bar = [UINavigationBar appearanceWhenContainedInInstancesOfClasses:@[self]];
//    
//    [bar setBackgroundImage:[UIImage imageWithColor:BACKGROUNDCOLOR] forBarMetrics:UIBarMetricsDefault];
////    NSMutableDictionary *dicBar=[NSMutableDictionary dictionary];
//    
////    dicBar[NSFontAttributeName]=[UIFont systemFontOfSize:15];
////    [bar setTitleTextAttributes:dic];
//    
//    UIColor* color = [UIColor whiteColor];
//    NSDictionary* dict=[NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
//    bar.titleTextAttributes= dict;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    if (self.viewControllers.count > 0) {
        
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    return [super pushViewController:viewController animated:animated];
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
