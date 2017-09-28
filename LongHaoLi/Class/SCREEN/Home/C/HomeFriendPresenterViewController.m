//
//  HomeFriendPresenterViewController.m
//  LongHaoLi
//
//  Created by Guang shen on 2017/8/22.
//  Copyright © 2017年 fanfan. All rights reserved.
//

#import "HomeFriendPresenterViewController.h"
#import "HomeFriendPresenterTableViewCell.h"
 
#import "HomeFriendPresenterDetialViewController.h"
#import "HomeFriendCalendarViewController.h"

@interface HomeFriendPresenterViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>


@property (nonatomic, retain)UITableView *tableView;
@property (nonatomic, retain)NSMutableArray *searchArr;
@property (nonatomic, assign)int page;


@end

@implementation HomeFriendPresenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 1;
//    self.automaticallyAdjustsScrollViewInsets =NO;
 
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.searchArr = [[NSMutableArray alloc ] init];
    self.view.backgroundColor = [UIColor whiteColor];
     [self.navigationController.navigationBar setBarTintColor: BACKGROUNDCOLOR];
    [self getMessage];
    [self setTableView];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"便签" style:UIBarButtonItemStylePlain target:self action:@selector(Gift)];
    // Do any additional setup after loading the view.
}

- (void)Gift{
    
//        CalendarViewController *calender = [[CalendarViewController alloc] init];
//        DataBaseHelper *dataBase = [DataBaseHelper sharedDataBaseHelper];
//        [dataBase DBFilePathWithFileName:@"hdjr"];
//        calender.arr1 = [dataBase queryDBWithSqlString:@"select * from '黄历数据库'"];
//        [self.navigationController pushViewController:calender animated:YES];
    HomeFriendCalendarViewController *calendar = [[HomeFriendCalendarViewController alloc] init];
    [self.navigationController pushViewController:calendar animated:YES];
    
}


-(void)viewWillAppear:(BOOL)animated{
    //    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.tabBarController.tabBar.hidden = YES;
    [super viewWillAppear:YES];
}

- (void)setTableView{
  
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    table.dataSource = self;
    table.delegate =self;
    self.tableView = table;
    // 取消分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"HomeFriendPresenterTableViewCell" bundle:nil] forCellReuseIdentifier:@"like"];
    [self.view addSubview: table];
    // Do any additional setup after loading the view.
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    //默认【上拉加载】
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
        self.tableView.tableFooterView = [[UIView alloc] init];
    // Do any additional setup after loading the view.
}

 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
     HomeHotCommodityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"like"];
     cell.headImage.layer.masksToBounds = YES;
     cell.headImage.layer.cornerRadius = 5;
     //            [cell.headImage sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"loadingimg"] options:SDWebImageAllowInvalidSSLCertificates];
     //            cell.name.text = @"喜欢😍喜欢";
     //            cell.num.text = [NSString stringWithFormat:@"剩余%d份",55];
     //            cell.address.text = @"西部云谷商圈";
     //            cell.price.text = [NSString stringWithFormat:@"%.1f元",-96.8];
     //            cell.shopprice.text = [NSString stringWithFormat:@"门市价%.1f",1000.0];
     cell.selectionStyle = UITableViewCellSelectionStyleNone;
     TicketModel *model = self.searchArr[indexPath.row ];
     cell.headImage.layer.masksToBounds = YES;
     cell.headImage.layer.cornerRadius = 5;

         
     [cell.headImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE,[MyBase64 stringConpanSteing:model.photo ]] ]placeholderImage:[UIImage imageNamed:@"loadingimg"] options:SDWebImageAllowInvalidSSLCertificates];
    
     cell.name.text = model.name;
     cell.num.text = [NSString stringWithFormat:@"剩余%d份",model.surplusCount];
     cell.address.text = model.addressShop;
     cell.price.text = [NSString stringWithFormat:@"%0.2f元",model.salePrice];
     cell.shopprice.text = [NSString stringWithFormat:@"门市价%0.2f",model.originalPrice];
     cell.selectionStyle = UITableViewCellSelectionStyleNone;
     return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return   130 * SCREEN_WIDTH/414;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.searchArr.count;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TicketModel *model = self.searchArr[indexPath.row];
    HomeFriendPresenterDetialViewController *detial = [[HomeFriendPresenterDetialViewController alloc] init];
    detial.rollId =[NSString stringWithFormat:@"%@",model.rollId];
    detial.type = @"4";
    [self.navigationController pushViewController:detial animated:YES];
}

- (void)getMessage{
    NSString *page = [NSString stringWithFormat:@"%d",_page];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:_type,@"type",page,@"page",[NSString stringWithFormat:@"%f",APPDELEGATE.latitude],@"latitudeX",[NSString stringWithFormat:@"%f",APPDELEGATE.longitude],@"latitudeY", nil];
    [MJPush postWithURLString:LIST parameters:dic success:^(id sucess) {
        
        if ([[sucess objectForKey:@"code"] isEqualToString:@"000"]) {
            NSArray *arr = [NSArray arrayWithArray:[sucess objectForKey:@"data"]];
            if (arr.count > 0) {
                for (NSDictionary *dic in arr) {
                    TicketModel *model = [TicketModel setModelWithDictionary:dic];
                    [self.searchArr addObject:model];
                }
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

- (void)refresh{
    _page = 1;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.searchArr removeAllObjects];
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

 



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
