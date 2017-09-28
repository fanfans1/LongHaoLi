//
//  HomeTiceketDetialViewController.m
//  LongHaoLi
//
//  Created by Guang shen on 2017/8/17.
//  Copyright © 2017年 fanfan. All rights reserved.
//

#import "HomeTiceketDetialViewController.h"
#import "HomeTicketDetialHeadTableViewCell.h"
#import "HomeTicketDetialShopTableViewCell.h"
#import "HomeTicketDetialTicketTableViewCell.h"
#import "HomeTicketDetialTicketDiscountsTableViewCell.h"
#import "HomeTicketDetialShopOtherTableViewCell.h"
#import "HomeTicketShopListTableViewController.h"
#import "RollInfoModel.h"
#import "RollShopInfoModel.h"
#import "TicketModel.h"
#import "HomeTicketDetialTitle.h"
#import "PayTicketOrderViewController.h"
#import "PayPostOrderViewController.h"



@interface HomeTiceketDetialViewController ()<UITableViewDelegate,UITableViewDataSource,HomeTicketDetialShopTableViewCellDelegate>

@property (nonatomic, retain)UITableView *tableView;
@property (nonatomic, retain)UILabel *price;
@property (nonatomic, retain)RollInfoModel *rollInfo;
@property (nonatomic, retain)RollShopInfoModel *shopInfo;
@property (nonatomic, retain)NSMutableArray *marr;
@property (nonatomic, assign)int page;

@end

@implementation HomeTiceketDetialViewController

- (void)viewDidLoad {
    self.page = 1;
    self.marr = [NSMutableArray array];
    self.view.backgroundColor = [UIColor whiteColor];
    [super viewDidLoad];
    [self.navigationController.navigationBar setBarTintColor: BACKGROUNDCOLOR];
    [self setTableView];
 
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.scrollIndicatorInsets = _tableView.contentInset;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden =NO;
    [self getMassage];
}

- (void)setTableView{
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    table.dataSource = self;
    table.delegate =self;
    self.tableView = table;
    // 取消分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"HomeTicketDetialHeadTableViewCell" bundle:nil] forCellReuseIdentifier:@"head"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HomeTicketDetialShopTableViewCell" bundle:nil] forCellReuseIdentifier:@"shop"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HomeTicketDetialTicketTableViewCell" bundle:nil] forCellReuseIdentifier:@"ticket"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HomeTicketDetialTicketDiscountsTableViewCell" bundle:nil] forCellReuseIdentifier:@"discount"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HomeTicketDetialShopOtherTableViewCell" bundle:nil] forCellReuseIdentifier:@"other"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HomeHotCommodityTableViewCell" bundle:nil] forCellReuseIdentifier:@"like"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview: table];
    self.tableView.showsVerticalScrollIndicator = NO;
    // Do any additional setup after loading the view.
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    //默认【上拉加载】
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    
}

- (void)pay{
    ISLOGIN;
//    NSLog(@"%@",self.type);
    if (self.isTicketPackage) { // 券包
            if ([self.type isEqualToString: @"3"]) {
                
                PayPostOrderViewController *pay1 = [[PayPostOrderViewController alloc] init];
                pay1.rollInfo = self.rollInfo;
                pay1.recordID = self.model.recordID;
                pay1.srID = self.model.srID;
                [self.navigationController pushViewController:pay1 animated:YES];
            }else{
                PayTicketOrderViewController *pay = [[PayTicketOrderViewController alloc] init];
                pay.rollInfo = self.rollInfo;
                pay.recordID = self.model.recordID;
                pay.srID = self.model.srID;
                [self.navigationController pushViewController:pay animated:YES];
                
            }
    }else{
            if ([self.type isEqualToString: @"3"]) {
                
                PayPostOrderViewController *pay1 = [[PayPostOrderViewController alloc] init];
                pay1.rollInfo = self.rollInfo;
                [self.navigationController pushViewController:pay1 animated:YES];
            }else{
                PayTicketOrderViewController *pay = [[PayTicketOrderViewController alloc] init];
                pay.rollInfo = self.rollInfo;
                [self.navigationController pushViewController:pay animated:YES];
                
            }
    }
}

- (void)getMassage{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *time = [MyBase64 getCurrentTimestamp];
    //    NSString *time = @"1500000000000";
    
    
    NSString *str = [MyBase64 base64EncodingWithData:[MD5 md5: [NSString stringWithFormat:@"%@%@%@%@%@",[MD5 md5: time],self.rollId,[NSString stringWithFormat:@"%f",APPDELEGATE.latitude],[NSString stringWithFormat:@"%f",APPDELEGATE.longitude],self.type]]];
    
    [dic setValue:self.rollId forKey:@"rollId"];
    [dic setValue:[NSString stringWithFormat:@"%f",APPDELEGATE.latitude] forKey:@"latitudeX"];
    [dic setValue:[NSString stringWithFormat:@"%f",APPDELEGATE.longitude]  forKey:@"latitudeY"];
    [dic setValue:self.type forKey:@"type"];
    [dic setValue:[user objectForKey:@"id"] forKey:@"user_id"];
    [dic setValue:[NSString stringWithFormat:@"%d",self.page] forKey:@"page"];
    [dic setObject:str forKey:@"token"];
    [dic setObject:time forKey:@"date"];
    [MJPush postWithURLString:ROLLINFO parameters:dic success:^(id sucess) {
        if ([[sucess objectForKey:@"code"] isEqualToString:@"000"]) {
            
            self.rollInfo = [RollInfoModel setModelWithDictionary:[[sucess objectForKey:@"data"] objectForKey:@"rollApp"]];
            self.shopInfo = [RollShopInfoModel setModelWithDictionary:[[sucess objectForKey:@"data"] objectForKey:@"shopApp"]];
            NSArray *arr = [NSArray arrayWithArray:[[sucess objectForKey:@"data"] objectForKey:@"likeRolls"]];
            for (NSDictionary *dic in arr) {
                TicketModel *model = [TicketModel setModelWithDictionary:dic];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.rollInfo) {
        return self.marr.count + 5;
        
    }else{
        return 0;
    }
}

- (void)setTableHeadView{
    if (self.tableView.tableHeaderView) {
        return;
    }
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 170)];
    
    [image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE,[MyBase64 stringConpanSteing:self.rollInfo.photo ]] ]placeholderImage:[UIImage imageNamed:@"loadingimg.png"] options:SDWebImageAllowInvalidSSLCertificates];
    
    self.tableView.tableHeaderView = image;
    
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    [self setTableHeadView];
    if (indexPath.row == 0) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        cell.textLabel.text = @"使用门店（离我最近）";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.row == 1){
        HomeTicketDetialShopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"shop"];
        cell.name.text = self.shopInfo.name;
        cell.desc.text = self.shopInfo.address;
        cell.address.text = self.shopInfo.addressShop;
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.row == 2){
        HomeTicketDetialShopOtherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"other"];
        cell.shopNum.text= [NSString stringWithFormat:@"共%d家",self.shopInfo.total];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.row == 3){
        HomeTicketDetialTicketDiscountsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"discount"];
        cell.discounts.text = self.rollInfo.offerDetails;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.row == 4) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        cell.textLabel.text = @"查看本券用户还看了";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        HomeHotCommodityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"like"];
        cell.headImage.layer.masksToBounds = YES;
        cell.headImage.layer.cornerRadius = 5;
        TicketModel *model = self.marr[indexPath.row - 5];
        [cell.headImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE,[MyBase64 stringConpanSteing:model.photo ]] ]placeholderImage:[UIImage imageNamed:@"loadingimg"] options:SDWebImageAllowInvalidSSLCertificates];
        cell.name.text = model.name;
        cell.num.text = [NSString stringWithFormat:@"剩余%d份",model.surplusCount];
        cell.address.text = model.addressShop;
        cell.price.text = [NSString stringWithFormat:@"%0.2f元",model.salePrice];
        cell.shopprice.text = [NSString stringWithFormat:@"门市价%0.2f",model.originalPrice];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}



- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:RECTMACK(0, 0, 414, 8)];
    view.backgroundColor = COLOUR(243, 243, 243);
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (self.rollInfo) {
        NSArray  *apparray= [[NSBundle mainBundle]loadNibNamed:@"HomeTicketDetialTitle" owner:nil options:nil];
        HomeTicketDetialTitle *appView  = [apparray firstObject];
        appView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 130);
        appView.name.text = self.rollInfo.name;
        appView.desc.text = self.rollInfo.intro;
        appView.price.text = [NSString stringWithFormat:@"%0.2f",self.rollInfo.salePrice];
        appView.shopPrice.text = [NSString stringWithFormat:@"门市价:%0.2f元",self.rollInfo.originalPrice];
        appView.count.text = [NSString stringWithFormat:@"剩余:%d份",self.rollInfo.surplusCount];
    
        [appView.buy addTarget:self action:@selector(pay) forControlEvents:UIControlEventTouchUpInside];
        return appView;
    }else{
        UIView *view = [[UIView alloc] initWithFrame:RECTMACK(0, 0, 414, 8)];
        view.backgroundColor = COLOUR(243, 243, 243);
        return view;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 130;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0){
        return 50;
    }else if (indexPath.row == 1){
        return 125;
    }else if (indexPath.row == 2){
        return 55;
    }else if (indexPath.row == 3){
        return 75 + [self heightForStringWidth:(SCREEN_WIDTH - 30)];
    }else if(indexPath.row == 4){
        return 50;
    }else{
        return 130;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 2) {
        HomeTicketShopListTableViewController *list = [[HomeTicketShopListTableViewController alloc] init];
        list.rollId = self.rollId;
        [self.navigationController pushViewController:list animated:YES];
    }
    else if (indexPath.row > 4){
        TicketModel *model = self.marr[indexPath.row - 5];
        HomeTiceketDetialViewController *detial = [[HomeTiceketDetialViewController alloc] init];
        detial.rollId = model.rollId;
        
        detial.type = [NSString stringWithFormat:@"%d",model.modelType];
        
        [self.navigationController pushViewController:detial animated:YES];
        
        
    }
}

- (float) heightForStringWidth:(float)width{
    UITextView *text = [[UITextView alloc] init];
    text.text = self.rollInfo.offerDetails;
    text.font = [UIFont systemFontOfSize:17];
    CGSize sizeToFit = [text sizeThatFits:CGSizeMake(width, MAXFLOAT)];
    return sizeToFit.height;
}


- (void)refresh{
    _page = 1;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.marr removeAllObjects];
            [self getMassage];
            
            
            
        });
    });
}

- (void)loadMore{
    _page++;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self getMassage];
        });
    });
}


// 定位
- (void)makeLogin{
    AMapNaviViewController *map = [[AMapNaviViewController alloc] init];
    map.latitudeX = self.shopInfo.latitudeX;
    map.latitudeY = self.shopInfo.latitudeY;
    [self.navigationController pushViewController:map animated:YES];
}
// 电话
- (void)callPhone{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"是否拨打客服热线" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *OK = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%d",self.shopInfo.linkTel]]];
    }];
    
    [alertC addAction: OK];
    
    UIAlertAction *concal = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertC addAction: concal];
    
    [self presentViewController:alertC animated:NO completion:^{
        
    }];
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
