//
//  TicketAddViewController.m
//  LongHaoLi
//
//  Created by Guang shen on 2017/8/8.
//  Copyright © 2017年 fanfan. All rights reserved.
//

#import "TicketAddViewController.h"
#import "TicketAddTableViewCell.h"
#import "TicketDragonTableViewCell.h"
#import "TicketFinishTableViewCell.h"
#import "TicketPackageModel.h"

@interface TicketAddViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain)UITableView *tableView;
@property (nonatomic, retain)NSMutableArray *marr;
@property (nonatomic, assign)int page;


@end

@implementation TicketAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49 - 40)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    //    [self.tableView registerNib:[UINib nibWithNibName:@"TicketAddTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"TicketDragonTableViewCell" bundle:nil] forCellReuseIdentifier:@"dragon"];
    [self.tableView registerNib:[UINib nibWithNibName:@"TicketFinishTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.view addSubview: self.tableView];
    self.marr = [NSMutableArray array];
    _page = 1;
    // Do any additional setup after loading the view.
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    //默认【上拉加载】
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    self.tableView.tableFooterView = [[UIView alloc]  init];
    [self getMessage];
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    addObserver(@selector(refresh), @"tabBarItembadgeValue");
    // Do any additional setup after loading the view.
}

- (void)dealloc{
    removeObserver();
}


- (void)refresh{
    _page = 1;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.marr removeAllObjects];
            [self getMessage];
            
        });
    });
}

- (void)loadMore{
    _page++;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self getMessage];
            
            
            
        });
    });
}

- (void)getMessage{
    
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *time = [MyBase64 getCurrentTimestamp];
    //    NSString *time = @"1500000000000";
    
    
    
    NSString *str = [MyBase64 base64EncodingWithData:[MD5 md5: [NSString stringWithFormat:@"%@%@%@%@",[MD5 md5: time],[user objectForKey:@"id"],@"1",[NSString stringWithFormat:@"%d",_page]]]];
    
    [dic setValue:@"1" forKey:@"type"];
    [dic setValue:[user objectForKey:@"id"] forKey:@"userId"];
    [dic setValue:[NSString stringWithFormat:@"%d",self.page] forKey:@"page"];
    [dic setObject:str forKey:@"token"];
    [dic setObject:time forKey:@"date"];
    [MJPush postWithURLString:ROLLPACKAGE parameters:dic success:^(id sucess) {
        if ([[sucess objectForKey:@"code"] isEqualToString:@"000"]) {
            for (NSDictionary *dic in sucess[@"data"]) {
                
                TicketPackageModel *model = [TicketPackageModel setModelWithDictionary:dic];
                [self.marr addObject:model];
            }
            
            [self.tableView reloadData];
        }else if ([[sucess objectForKey:@"code"] isEqualToString:@"001"]){
            ALERT([sucess objectForKey:@"message"]);
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.marr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        TicketPackageModel *model = self.marr[indexPath.row];
    if (model.ItemType  == 1 || model.ItemType == 3 || model.ItemType == 6) {
    
        return 120;
    }else{
        return 180;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TicketPackageModel *model = self.marr[indexPath.row];
    if (model.ItemType  == 1) {
        
        TicketDragonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"dragon"];
        [cell.picture sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE,[MyBase64 stringConpanSteing:model.photo]]] placeholderImage:[UIImage imageNamed:@"loadingimg"] options:SDWebImageAllowInvalidSSLCertificates];
        
        cell.name.text = [NSString stringWithFormat:@"%@(抽奖券)",model.name];
        cell.price.text = [NSString stringWithFormat:@"￥%.2f",model.salePrice];
        cell.address.text = [NSString stringWithFormat:@"%@",model.addressShop];
        cell.buy.layer.masksToBounds = YES;
        cell.buy.layer.cornerRadius = 5;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (model.ItemType  == 2){
        TicketFinishTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        [cell.picture sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE,[MyBase64 stringConpanSteing:model.photo]]] placeholderImage:[UIImage imageNamed:@"loadingimg"] options:SDWebImageAllowInvalidSSLCertificates];
        cell.add.hidden = YES;
        cell.name.text =[NSString stringWithFormat:@"%@(抽奖券)",model.name ];
        cell.desc.text = [NSString stringWithFormat:@"￥%.2f",model.salePrice];
        cell.address.text = [NSString stringWithFormat:@"%@",model.addressShop];
        cell.type.text =@"待使用";
        cell.type.layer.borderWidth = 1;
        cell.type.layer.masksToBounds = YES;
        cell.type.layer.cornerRadius = 3;
        cell.type.layer.borderColor = COLOUR(249, 249, 249).CGColor;
        
        cell.butTime.text = [NSString stringWithFormat:@"购买时间:%@",[MyBase64 timestampSwitchTime:model.StartTime]];
        cell.useTime.text = [NSString stringWithFormat:@"过期时间:%@", [MyBase64 timestampSwitchTime:model.EndTime]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (model.ItemType  == 3){
        TicketDragonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"dragon"];
        [cell.picture sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE,[MyBase64 stringConpanSteing:model.photo]]] placeholderImage:[UIImage imageNamed:@"loadingimg"] options:SDWebImageAllowInvalidSSLCertificates];
        
        cell.name.text = [NSString stringWithFormat:@"%@(赠)",model.name];
        cell.price.text = [NSString stringWithFormat:@"￥%.2f",model.salePrice];
        cell.address.text = [NSString stringWithFormat:@"%@",model.addressShop];
        cell.buy.layer.masksToBounds = YES;
        cell.buy.layer.cornerRadius = 5;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (model.ItemType  == 4){
        TicketFinishTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        [cell.picture sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE,[MyBase64 stringConpanSteing:model.photo]]] placeholderImage:[UIImage imageNamed:@"loadingimg"] options:SDWebImageAllowInvalidSSLCertificates];
        cell.add.hidden = YES;
        cell.name.text = [NSString stringWithFormat:@"%@(赠)",model.name];
        cell.desc.text = [NSString stringWithFormat:@"￥%.2f",model.salePrice];
        cell.address.text = [NSString stringWithFormat:@"%@",model.addressShop];
        cell.type.text = @"待使用";
        cell.type.layer.borderWidth = 1;
        cell.type.layer.masksToBounds = YES;
        cell.type.layer.cornerRadius = 3;
        cell.type.layer.borderColor = COLOUR(249, 249, 249).CGColor;
        
        cell.butTime.text = [NSString stringWithFormat:@"购买时间:%@",[MyBase64 timestampSwitchTime:model.StartTime]];
        cell.useTime.text = [NSString stringWithFormat:@"过期时间:%@", [MyBase64 timestampSwitchTime:model.EndTime]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (model.ItemType  == 5){
        TicketFinishTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        [cell.picture sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE,[MyBase64 stringConpanSteing:model.photo]]] placeholderImage:[UIImage imageNamed:@"loadingimg"] options:SDWebImageAllowInvalidSSLCertificates];
        cell.add.hidden = NO;
        cell.name.text = [NSString stringWithFormat:@"%@",model.name];
        cell.desc.text = [NSString stringWithFormat:@"￥%.2f",model.salePrice];
        cell.address.text = [NSString stringWithFormat:@"%@",model.addressShop];
        cell.type.text =@"待使用";
        cell.type.layer.borderWidth = 1;
        cell.type.layer.masksToBounds = YES;
        cell.type.layer.cornerRadius = 3;
        cell.type.layer.borderColor = COLOUR(249, 249, 249).CGColor;
        
        cell.butTime.text = [NSString stringWithFormat:@"购买时间:%@",[MyBase64 timestampSwitchTime:model.StartTime]];
        cell.useTime.text = [NSString stringWithFormat:@"过期时间:%@", [MyBase64 timestampSwitchTime:model.EndTime]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (model.ItemType  == 6){
        TicketDragonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"dragon"];
        [cell.picture sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE,[MyBase64 stringConpanSteing:model.photo]]] placeholderImage:[UIImage imageNamed:@"loadingimg"] options:SDWebImageAllowInvalidSSLCertificates];
        
        cell.name.text = [NSString stringWithFormat:@"%@(通用券)",model.name];
        cell.price.text = [NSString stringWithFormat:@"￥%.2f",model.salePrice];
        cell.address.text = [NSString stringWithFormat:@"%@",model.addressShop];
        cell.buy.layer.masksToBounds = YES;
        cell.buy.layer.cornerRadius = 5;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else {
        TicketFinishTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        [cell.picture sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE,[MyBase64 stringConpanSteing:model.photo]]] placeholderImage:[UIImage imageNamed:@"loadingimg"] options:SDWebImageAllowInvalidSSLCertificates];
        cell.add.hidden = YES;
        cell.name.text = [NSString stringWithFormat:@"%@(通用券)",model.name];
        cell.desc.text = [NSString stringWithFormat:@"￥%.2f",model.salePrice];
        cell.address.text = [NSString stringWithFormat:@"%@",model.addressShop];
        cell.type.text =@"待使用";
        cell.type.layer.borderWidth = 1;
        cell.type.layer.masksToBounds = YES;
        cell.type.layer.cornerRadius = 3;
        cell.type.layer.borderColor = COLOUR(249, 249, 249).CGColor;
        
        cell.butTime.text = [NSString stringWithFormat:@"购买时间:%@",[MyBase64 timestampSwitchTime:model.StartTime]];
        cell.useTime.text = [NSString stringWithFormat:@"过期时间:%@", [MyBase64 timestampSwitchTime:model.EndTime]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TicketPackageModel *model = self.marr[indexPath.row];
    if (model.ItemType  == 1 || model.ItemType == 3 || model.ItemType == 6) {
        
        HomeTiceketDetialViewController *detial = [[HomeTiceketDetialViewController alloc] init];
        TicketPackageModel *model = self.marr[indexPath.row];
        detial.model = model;
        detial.isTicketPackage = YES;
        detial.rollId = model.rollId;
        detial.type = [NSString stringWithFormat:@"%d",model.modelType];
        [self.navigationController pushViewController:detial animated:YES];
        
    }else{
        HomeTicketFinishViewController *detial = [[HomeTicketFinishViewController alloc] init];
        TicketPackageModel *model = self.marr[indexPath.row];
        detial.rollId = model.rollId;
        detial.orderNum = model.orderNum;
        detial.type = [NSString stringWithFormat:@"%d",model.modelType];
        [self.navigationController pushViewController:detial animated:YES];
    }
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
