//
//  MineViewController.m
//  Longhaoli
//
//  Created by 亿缘 on 2017/7/8.
//  Copyright © 2017年 亿缘. All rights reserved.
//

#import "MineViewController.h"
#import "LoginViewController.h"
// 用户头像选择
#import "TakePic.h"
//// 用户联系方式
//#import "GetUserContentViewController.h"

#import "MineHeadTableViewCell.h"
#import "MineVisionTableViewCell.h"
#import "MineAddressTableViewCell.h"
#import "MineUserNameTableViewCell.h"
#import "MineChangeLoginTableViewCell.h"

#import "MineComplainViewController.h"     // 投诉
#import "MineAddressDetialTableViewController.h" // 地址
#import "MineShopAddTableViewController.h"  // 申请商铺
#import "MinePayHistoryTableViewController.h"     // 交易记录
#import "MineChangeNameViewController.h"    // 更名


@interface MineViewController ()<UITableViewDelegate,UITableViewDataSource,MineChangeLoginTableViewCellDelegate>

@property (nonatomic, retain)UITableView *tableView;

@property (nonatomic, retain)NSArray *arr;
@property (nonatomic, retain)UIImageView *image;

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //    self.mainImageView.image = image;
    
    self.arr = [NSArray arrayWithObjects:@"我的地址",@"店铺申请",@"交易记录",@"投诉相关信息", nil];
    self.automaticallyAdjustsScrollViewInsets = NO;
  
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBarTintColor: BACKGROUNDCOLOR];
    //    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"拍照" style:UIBarButtonItemStyleDone target:self action:@selector(getUserMassage)];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView registerNib:[UINib nibWithNibName:@"MineHeadTableViewCell" bundle:nil] forCellReuseIdentifier:@"head"];
    [self.tableView registerNib:[UINib nibWithNibName:@"MineVisionTableViewCell" bundle:nil] forCellReuseIdentifier:@"vision"];
    [self.tableView registerNib:[UINib nibWithNibName:@"MineAddressTableViewCell" bundle:nil] forCellReuseIdentifier:@"address"];
    [self.tableView registerNib:[UINib nibWithNibName:@"MineUserNameTableViewCell" bundle:nil] forCellReuseIdentifier:@"userName"];
    [self.tableView registerNib:[UINib nibWithNibName:@"MineChangeLoginTableViewCell" bundle:nil] forCellReuseIdentifier:@"changeLogin"];
    self.tableView.bouncesZoom = NO;
    self.tableView.bounces = NO;
    [self.view addSubview: self.tableView];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 9;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        MineHeadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"head"];
        self.image = cell.head;
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        [cell.head sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE,[NSString stringWithFormat:@"%@",[MyBase64 stringConpanSteing:[user objectForKey:@"headPhoto"]]]]] placeholderImage:[UIImage imageNamed:@"loadingimg.png"] options:SDWebImageAllowInvalidSSLCertificates];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        NSLog(@"%@",[MyBase64 stringConpanSteing:[user objectForKey:@"headPhoto"]]);
        return cell;
    }else if (indexPath.row == 1 || indexPath.row == 2){
        MineUserNameTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userName"];
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        if (indexPath.row == 1) {
            cell.name.text = @"用户名";
            cell.value.text = [user objectForKey:@"nickName"];
        }else{
            cell.name.text = @"手机号码";
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            NSString *tel = [[user objectForKey:@"tel"] stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
            cell.value.text = tel;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.row > 2 && indexPath.row < 7){
        MineAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"address"];
        
        cell.name.text = self.arr[indexPath.row - 3];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.row == 7){
        MineVisionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"vision"];
        
        cell.phone.text = [NSString stringWithFormat:@"客服电话:%@",@"888888"];
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        
        
        NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        cell.vision.text = [NSString stringWithFormat:@"版本号%@",app_Version];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        MineChangeLoginTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"changeLogin"];
        cell.delegate = self;
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (void)change{
    UIAlertController *alertControllera = [UIAlertController alertControllerWithTitle:@"退出登录" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertControllera addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        RESIGIONLOGIN;
        
    }]];
    [alertControllera addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        
    }]];
    [self presentViewController:alertControllera animated:YES completion:^{
        
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < 8) {
        return 60;
    }else{
        return 90;
    }
}



- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    ISLOGIN
    self.tabBarController.tabBar.hidden = NO;
    if (self.tableView) {
        
        [self.tableView reloadData];
    }
    
}

//// 获取手机通讯录
//- (void)getUserMassage{
//    GetUserContentViewController *content = [[GetUserContentViewController alloc] init];
//    content.phoneBlock = ^(NSString *phone) {
////        NSLog(@"%@",phone);
//    };
//    [self addChildViewController:content];
//    [self.view addSubview: content.view];
//    
//}




// 设置用户头像
- (void)setUserAlias{
    
    TakePic *take = [[TakePic alloc] init];
    [self addChildViewController: take];
    [self.view addSubview: take.view];
    [take alterHeadPortrait];
    [take returnRoomName:^(NSData *image) {
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[user objectForKey:@"id"],@"id", nil];
        [MJPush uploadWithURLString:IMAGEUPLOAD parameters:dic uploadData:image uploadName:@"file" success:^(id sucess) {
            if ([[sucess objectForKey:@"code"] isEqualToString:@"000"]) {
                self.image.image = [UIImage imageWithData:image];
                NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                [user setObject:[sucess objectForKey:@"data"] forKey:@"headPhoto"];
                ALERT(@"修改成功");
            }else if ([[sucess objectForKey:@"code"] isEqualToString:@"001"]){
                ALERT([sucess objectForKey:@"message"]);
            }
            [take.view removeFromSuperview];
            
        } failure:^(NSError *err) {
            [take.view removeFromSuperview];
            
        }];
    }];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        [self setUserAlias];
    }else if (indexPath.row == 1){
        MineChangeNameViewController *mine = [[MineChangeNameViewController alloc] init];
        [self.navigationController pushViewController:mine animated:YES];
    }else if (indexPath.row == 3){
        MineAddressDetialTableViewController *mine = [[MineAddressDetialTableViewController alloc] init];
        [self.navigationController pushViewController:mine animated:YES];
    }else if (indexPath.row == 4){
        MineShopAddTableViewController *shop = [[MineShopAddTableViewController alloc] init];
        [self.navigationController pushViewController:shop animated:YES];
    }else if (indexPath.row == 5){
 
        MinePayHistoryTableViewController *pay = [[MinePayHistoryTableViewController alloc] init];
        [self.navigationController pushViewController:pay animated:YES];
    }else if (indexPath.row == 6){
        
        MineComplainViewController *mine = [[MineComplainViewController alloc] init];
        [self.navigationController pushViewController:mine animated:YES];
    }else if (indexPath.row == 7){
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"是否拨打客服热线：029-33264160" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *OK = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",@"029-33264160"]]];
        }];
        
        [alertC addAction: OK];
        
        UIAlertAction *concal = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alertC addAction: concal];
        
        [self presentViewController:alertC animated:NO completion:^{
            
        }];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:YES];
    
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
