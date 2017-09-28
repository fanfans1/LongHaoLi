//
//  HomeTempleDetialDescTypeViewController.m
//  LongHaoLi
//
//  Created by Guang shen on 2017/8/19.
//  Copyright © 2017年 fanfan. All rights reserved.
//

#import "HomeTempleDetialDescTypeViewController.h"
#import "HomeTempleDetialDescTypeTableViewCell.h"
#import "HomeTemplePayViewController.h"

@interface HomeTempleDetialDescTypeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, retain)UITableView *tableView;
@property (nonatomic, retain)UIButton *temp;
@property (nonatomic, assign)int page;
@property (nonatomic, retain)NSMutableArray *marr;
@property (nonatomic, assign)NSInteger select;   // 选择类型

@end

@implementation HomeTempleDetialDescTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title = @"善行天下";
    self.marr = [NSMutableArray array];
    self.page = 1;
    self.select = 0;
    self.view.backgroundColor = [UIColor whiteColor];
    [self setTableView];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(50, SCREEN_HEIGHT - 80, SCREEN_WIDTH - 100,(SCREEN_WIDTH - 100)*112/1130);
    [btn setImage:[UIImage imageNamed:@"home_temple_next.png"] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    
//    btn.backgroundColor = BACKGROUNDCOLOR;
    [btn addTarget:self action:@selector(templeList) forControlEvents:UIControlEventTouchUpInside];
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 5;
    [self.view addSubview: btn];
    [self getMassage];
    // Do any additional setup after loading the view.
}

- (void)templeList{
    if (self.marr.count == 0) {
        ALERT(@"请选择类型");
        return;
    }
    
    
    HomeTemplePayViewController *type = [[HomeTemplePayViewController alloc ] init];
    type.shopId = self.shopId;
    type.shopDic = [NSDictionary dictionaryWithDictionary:self.marr[self.select] ] ;
    [self.navigationController pushViewController:type animated:YES];
}

- (void)setTableView{
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64-100)];
    table.dataSource = self;
    table.delegate =self;
    self.tableView = table;
    // 取消分割线
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"HomeTempleDetialDescTypeTableViewCell" bundle:nil] forCellReuseIdentifier:@"head"];
 
    
    [self.view addSubview: table];
    self.tableView.showsVerticalScrollIndicator = NO;
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    //默认【上拉加载】
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
 
}

- (void)refresh{
    _page = 1;
    [self.marr removeAllObjects];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        dispatch_async(dispatch_get_main_queue(), ^{
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

- (void)getMassage{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString *time = [MyBase64 getCurrentTimestamp];
    //    NSString *time = @"1500000000000";
    
    
    NSString *str = [MyBase64 base64EncodingWithData:[MD5 md5: [NSString stringWithFormat:@"%@%@",[MD5 md5: time],self.shopId]]];
    
    [dic setValue:[NSString stringWithFormat:@"%@",self.shopId] forKey:@"shopId"];
    [dic setValue:[NSString stringWithFormat:@"%d",self.page] forKey:@"page"];
    [dic setObject:time forKey:@"date"];
    [dic setObject:str forKey:@"token"];
    [MJPush postWithURLString:SELECTBSGOPACT parameters:dic success:^(id sucess) {
        if ([[sucess objectForKey:@"code"] isEqualToString:@"000"]) {
            
            [self.marr addObjectsFromArray:[sucess objectForKey:@"data"]];
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
    //#warning Incomplete implementation, return the number of rows
    
    return self.marr.count;
    
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary:self.marr[indexPath.row]];
    HomeTempleDetialDescTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"head"];
//    [cell.headImage sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"loadingimg.png"] options:SDWebImageAllowInvalidSSLCertificates];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.name.text = [dic objectForKey:@"benefactionActName"];
 
    if (indexPath.row == 0) {
        cell.select.selected = YES;
        self.temp = cell.select;
    }else{
        cell.select.selected = NO;
    }
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HomeTempleDetialDescTypeTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.select != self.temp) {
        cell.select.selected = YES;
        self.temp.selected = NO;
        self.temp = cell.select;
    }
    
    if (cell.select.selected) {
        self.select = indexPath.row;
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
