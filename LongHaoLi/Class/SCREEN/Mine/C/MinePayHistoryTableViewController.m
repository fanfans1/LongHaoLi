//
//  MinePayHistoryTableViewController.m
//  LongHaoLi
//
//  Created by Guang shen on 2017/8/10.
//  Copyright © 2017年 fanfan. All rights reserved.
//

#import "MinePayHistoryTableViewController.h"
#import "MinePayHistoryTableViewCell.h"

@interface MinePayHistoryTableViewController ()

@property (nonatomic, retain)NSMutableArray *marr;
@property (nonatomic, assign)int page;


@end

@implementation MinePayHistoryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _page = 1;
    self.marr = [NSMutableArray array];
    self.automaticallyAdjustsScrollViewInsets = YES;
  
    self.title = @"交易记录";
//    self.tableView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MinePayHistoryTableViewCell" bundle:nil] forCellReuseIdentifier:@"pay"];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    //默认【上拉加载】
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    [self getMassage];
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    self.tableView.tableFooterView = [[UIView alloc]  init];
    // 取消分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
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


- (void)getMassage{
    NSString *time = [MyBase64 getCurrentTimestamp];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *str = [MyBase64 base64EncodingWithData:[MD5 md5: [NSString stringWithFormat:@"%@%@%d",[MD5 md5: time],[user objectForKey:@"id"],_page]]];
    
    NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
    [mdic setValue:[user objectForKey:@"id"] forKey:@"userId"];
    [mdic setValue:[NSString stringWithFormat:@"%d",_page] forKey:@"page"];
 
    [mdic setObject:time forKey:@"date"];
    [mdic setObject:str forKey:@"token"];
    [MJPush postWithURLString:TRANSACTIONRECORD parameters:mdic success:^(id sucess) {
        if ([[sucess objectForKey:@"code"] isEqualToString:@"000"]) {
            
            [self.marr addObjectsFromArray: sucess[@"data"]];
            
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


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MinePayHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pay" forIndexPath:indexPath];
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary:self.marr[indexPath.row]];
    cell.name.text = [dic objectForKey:@"orderName"];
    cell.time.text = [MyBase64 timestampSwitchTime:[[dic objectForKey:@"time"] integerValue]];
    cell.order.text = [NSString stringWithFormat:@"订单号:%@",[dic objectForKey:@"orderNum"]];
    cell.price.text = [NSString stringWithFormat:@"￥%.2f", [[dic objectForKey:@"payPrice"] floatValue]];
    if ([dic[@"payStatus"] integerValue] == 1) {
         cell.payType.text = @"已支付";
    }else if ([dic[@"payStatus"] integerValue] == 0){
        cell.payType.text = @"未支付";
    }else{
        cell.payType.text = @"交易关闭";
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    // Configure the cell...
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
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


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
