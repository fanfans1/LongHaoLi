//
//  HomeTicketFinishViewController.m
//  LongHaoLi
//
//  Created by Guang shen on 2017/9/8.
//  Copyright © 2017年 fanfan. All rights reserved.
//

#import "HomeTicketFinishViewController.h"
#import "HomeTicketDetialHeadTableViewCell.h"
#import "HomeTicketDetialShopTableViewCell.h"
#import "HomeTicketDetialTicketTableViewCell.h"
#import "HomeTicketDetialTicketDiscountsTableViewCell.h"
#import "HomeTicketDetialShopOtherTableViewCell.h"
#import "HomeTicketShopListTableViewController.h"
#import "RollInfoModel.h"
#import "RollShopInfoModel.h"
#import "TicketModel.h"
#import "HomeTicketDetialFinishTitle.h"
#import "SGQRCodeTool.h"


@interface HomeTicketFinishViewController ()<UITableViewDelegate,UITableViewDataSource,HomeTicketDetialShopTableViewCellDelegate>

@property (nonatomic, retain)UITableView *tableView;
@property (nonatomic, retain)UILabel *price;
@property (nonatomic, retain)RollInfoModel *rollInfo;
@property (nonatomic, retain)RollShopInfoModel *shopInfo;
@property (nonatomic, retain)NSMutableArray *marr;
@property (retain, nonatomic) UIImageView *QRImage;

@property (nonatomic, retain)UIView *questView;
@end

@implementation HomeTicketFinishViewController

- (void)viewDidLoad {
    self.marr = [NSMutableArray array];
    self.view.backgroundColor = [UIColor whiteColor];
    [super viewDidLoad];
    [self.navigationController.navigationBar setBarTintColor: BACKGROUNDCOLOR];
    [self setTableView];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden =NO;
    [self getMassage];
}

- (void)setTableView{
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-24) style:UITableViewStylePlain];
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
 
 
    
}

- (void)pay{
    
}

- (void)getMassage{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *time = [MyBase64 getCurrentTimestamp];
    
    NSString *str = [MyBase64 base64EncodingWithData:[MD5 md5: [NSString stringWithFormat:@"%@%@%@%@%@",[MD5 md5: time],self.rollId,[NSString stringWithFormat:@"%f",APPDELEGATE.latitude],[NSString stringWithFormat:@"%f",APPDELEGATE.longitude],self.type]]];
    
    [dic setValue:self.rollId forKey:@"rollId"];
    [dic setValue:[NSString stringWithFormat:@"%f",APPDELEGATE.latitude] forKey:@"latitudeX"];
    [dic setValue:[NSString stringWithFormat:@"%f",APPDELEGATE.longitude]  forKey:@"latitudeY"];
    [dic setValue:self.type forKey:@"type"];
    [dic setValue:[user objectForKey:@"id"] forKey:@"user_id"];
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
        return  4;
        
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
    }else {
        HomeTicketDetialTicketDiscountsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"discount"];
        cell.discounts.text = self.rollInfo.offerDetails;
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
        NSArray  *apparray= [[NSBundle mainBundle]loadNibNamed:@"HomeTicketDetialFinishTitle" owner:nil options:nil];
        HomeTicketDetialFinishTitle *appView  = [apparray firstObject];
        appView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 115);
        appView.name.text = self.rollInfo.name;
        appView.price.text = [NSString stringWithFormat:@"%.2f",self.rollInfo.salePrice];
        appView.shopPrice.text = [NSString stringWithFormat:@"门市价:%.2f元",self.rollInfo.originalPrice];
        appView.orderNum.text = [NSString stringWithFormat:@"订单号: %@",self.orderNum];
        self.QRImage = appView.QRimage;
        
        self.QRImage.image = [SGQRCodeTool SG_generateWithLogoQRCodeData:self.orderNum logoImageName:@"AppIcon" logoWidth:20];
        [appView addSubview: self.QRImage];
        self.QRImage.userInteractionEnabled = YES;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(SCREEN_WIDTH - 130, 15, 80, 80);
        [btn addTarget:self action:@selector(changeQRImage) forControlEvents:UIControlEventTouchUpInside];
        [appView addSubview: btn];
        
        return appView;
    }else{
        UIView *view = [[UIView alloc] initWithFrame:RECTMACK(0, 0, 414, 8)];
        view.backgroundColor = COLOUR(243, 243, 243);
        return view;
    }
    
}

- (void)changeQRImage{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ahrefBack.png"]];

    UIImageView *images = [[UIImageView alloc] initWithFrame:CGRectMake(40, (SCREEN_HEIGHT - SCREEN_WIDTH)/2, SCREEN_WIDTH-80, SCREEN_WIDTH-80)];
    images.image =[SGQRCodeTool SG_generateWithLogoQRCodeData:self.orderNum logoImageName:@"AppIcon" logoWidth:20];
    images.userInteractionEnabled = YES;
    [view addSubview: images];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeRequest1)];
    [view addGestureRecognizer: tap];
    [images addGestureRecognizer: tap];
    [APPDELEGATE.window addSubview: view];
    self.questView = view;
}

- (void)removeRequest1{
    
    [_questView removeFromSuperview];
    
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
    }else{
        return 75 + [self heightForStringWidth:(SCREEN_WIDTH - 30)];
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 2) {
        HomeTicketShopListTableViewController *list = [[HomeTicketShopListTableViewController alloc] init];
        list.rollId = self.rollId;
        [self.navigationController pushViewController:list animated:YES];
    }
    
}

- (float) heightForStringWidth:(float)width{
    UITextView *text = [[UITextView alloc] init];
    text.text = self.rollInfo.offerDetails;
    text.font = [UIFont systemFontOfSize:17];
    CGSize sizeToFit = [text sizeThatFits:CGSizeMake(width, MAXFLOAT)];
    return sizeToFit.height;
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
