//
//  TicketPackageViewController.m
//  Longhaoli
//
//  Created by 亿缘 on 2017/7/8.
//  Copyright © 2017年 亿缘. All rights reserved.
//

// 卡券

#import "TicketPackageViewController.h"
#import "TicketDragonViewController.h"  // 龙好礼
#import "TicketAddViewController.h" //赠券
#import "TicketBuyViewController.h" // 易购券
#import "TicketFinishViewController.h"  //已使用
#import "YYTopTitleView.h"




@interface TicketPackageViewController ()
@property (nonatomic,strong) YYTopTitleView *titleView;
@end

@implementation TicketPackageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
     [self.navigationController.navigationBar setBarTintColor: BACKGROUNDCOLOR];
    [self setScroll];

    addObserver(@selector(tabBarControllerDragon), @"tabBarControllerDragon");
    addObserver(@selector(tabBarControllergift), @"tabBarControllergift");
    addObserver(@selector(tabBarItembadgeValue), @"tabBarItembadgeValue");
    // Do any additional setup after loading the view.
}



- (void)tabBarItembadgeValue{
    self.tabBarItem.badgeValue = @"1";
    self.tabBarItem.badgeColor = [UIColor redColor];
}

- (void)tabBarControllergift{
    [_titleView.pageScrollView setContentOffset:CGPointMake(SCREEN_WIDTH,0) animated:NO];
    _titleView.titleSegment.selectedSegmentIndex = 1;
}

- (void)tabBarControllerDragon{
    [_titleView.pageScrollView setContentOffset:CGPointMake(0,0) animated:NO];
    _titleView.titleSegment.selectedSegmentIndex = 0;
}

-(void)dealloc{
    removeObserver();
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    ISLOGIN
    self.tabBarController.tabBar.hidden = NO;
    self.tabBarItem.badgeValue = @" ";
    self.tabBarItem.badgeColor = [UIColor clearColor];
}

- (void)setScroll{
    
    TicketAddViewController *add = [[TicketAddViewController alloc] init];
    TicketDragonViewController *dragon = [[TicketDragonViewController alloc] init];
    TicketBuyViewController *buy = [[TicketBuyViewController alloc] init];
    TicketFinishViewController *finish = [[TicketFinishViewController alloc] init];
    
    
    self.titleView.title = @[@"龙好礼",@"赠券",@"已购券",@"已使用"];
     [self.titleView setupViewControllerWithFatherVC:self childVC:@[dragon,add,buy,finish]];
    
    [self.view addSubview:self.titleView];

    
}

- (void)viewWillDisappear:(BOOL)animated{
        [super viewWillDisappear:YES];
    
}

- (YYTopTitleView *)titleView{
    if (!_titleView) {
        _titleView = [[YYTopTitleView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, SCREEN_HEIGHT - 64 - 49)];
        _titleView.selectIndex = 0;
    }
    return _titleView;
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
