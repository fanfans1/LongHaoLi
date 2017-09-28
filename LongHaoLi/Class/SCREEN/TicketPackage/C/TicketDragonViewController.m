//
//  TicketDragonViewController.m
//  LongHaoLi
//
//  Created by Guang shen on 2017/8/8.
//  Copyright © 2017年 fanfan. All rights reserved.
//

#import "TicketDragonViewController.h"
#import "TicketDragonTableViewCell.h"
#import "TicketPackageModel.h"

@interface TicketDragonViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain)UITableView *tableView;
@property (nonatomic, retain)NSMutableArray *marr;
@property (nonatomic, assign)int page;

@end

@implementation TicketDragonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49 - 40)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TicketDragonTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.view addSubview: self.tableView];
    self.marr = [NSMutableArray array];
    _page = 1;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    //默认【上拉加载】
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    self.tableView.tableFooterView = [[UIView alloc]  init];
    [self getMessage];
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    // Do any additional setup after loading the view.
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
    
    
    NSString *str = [MyBase64 base64EncodingWithData:[MD5 md5: [NSString stringWithFormat:@"%@%@%@%@",[MD5 md5: time],[user objectForKey:@"id"],@"0",[NSString stringWithFormat:@"%d",_page]]]];
 
    [dic setValue:@"0" forKey:@"type"];
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
    return 120;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TicketDragonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    TicketPackageModel *model = self.marr[indexPath.row];
    [cell.picture sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE,[MyBase64 stringConpanSteing:model.photo]]] placeholderImage:[UIImage imageNamed:@"loadingimg"] options:SDWebImageAllowInvalidSSLCertificates];
    cell.name.text = model.name;
    cell.price.text = [NSString stringWithFormat:@"￥%.2f",model.salePrice];
    cell.address.text = [NSString stringWithFormat:@"%@",model.addressShop];
    cell.buy.layer.masksToBounds = YES;
    cell.buy.layer.cornerRadius = 5;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    HomeTiceketDetialViewController *detial = [[HomeTiceketDetialViewController alloc] init];
    TicketPackageModel *model = self.marr[indexPath.row];
    detial.model = model;
    detial.rollId = model.rollId;
    detial.isTicketPackage = YES;
    detial.type = [NSString stringWithFormat:@"%d",model.modelType];
    [self.navigationController pushViewController:detial animated:YES];
    
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
