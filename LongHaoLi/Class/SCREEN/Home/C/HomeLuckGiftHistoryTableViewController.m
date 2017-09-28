//
//  HomeLuckGiftHistoryTableViewController.m
//  LongHaoLi
//
//  Created by Guang shen on 2017/8/22.
//  Copyright © 2017年 fanfan. All rights reserved.
//

#import "HomeLuckGiftHistoryTableViewController.h"
#import "HomeLuckGiftHistorysTableViewCell.h"

@interface HomeLuckGiftHistoryTableViewController ()
@property (nonatomic, strong)NSMutableArray *marr;
@property (nonatomic, assign)int page;

@end

@implementation HomeLuckGiftHistoryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _page = 1;
    [self.navigationController.navigationBar setBarTintColor:BACKGROUNDCOLOR];
    self.automaticallyAdjustsScrollViewInsets = YES;

    self.marr = [NSMutableArray array];
    // Do any additional setup after loading the view.
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    //默认【上拉加载】
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    [self.tableView registerNib:[UINib nibWithNibName:@"HomeLuckGiftHistorysTableViewCell" bundle:nil]forCellReuseIdentifier:@"cell"];
    self.tableView.tableFooterView = [[UIView alloc]  init];
    [self getMassage];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    HomeLuckGiftHistorysTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary:self.marr[indexPath.row]];
    cell.name.text = dic[@"name"];
    cell.price.text = [MyBase64 timestampSwitchTime:[dic[@"time"] integerValue]];
    // Configure the cell...
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  50;
}


- (void)getMassage{
    NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [mdic setValue:[user objectForKey:@"id"] forKey:@"userId"];
    [mdic setValue:[NSString stringWithFormat:@"%d",_page] forKey:@"page"];
    NSString *time = [MyBase64 getCurrentTimestamp];
    NSString *str = [MyBase64 base64EncodingWithData:[MD5 md5: [NSString stringWithFormat:@"%@%@%@",[MD5 md5: time],[user objectForKey:@"id"],[NSString stringWithFormat:@"%d",_page]]]];
    [mdic setObject:time forKey:@"date"];
    [mdic setObject:str forKey:@"token"];
    
    [MJPush postWithURLString:SELECTLOTTERYDRAWRECORD parameters:mdic success:^(id sucess) {
        
        if ([[sucess objectForKey:@"code"] isEqualToString:@"000"]) {
//            for (NSDictionary *dic in [sucess objectForKey:@"data"]) {
//                
//            }
            [self.marr addObjectsFromArray: sucess[@"data"]];
            [self.tableView reloadData];
        }else if ([[sucess objectForKey:@"code"] isEqualToString:@"001"]){
            ALERT([sucess objectForKey:@"message"]);
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
    } failure:^(NSError *error) {
        
    }];

    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
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
