//
//  HomeTicketShopListTableViewController.m
//  LongHaoLi
//
//  Created by Guang shen on 2017/8/18.
//  Copyright © 2017年 fanfan. All rights reserved.
//

#import "HomeTicketShopListTableViewController.h"
#import "HomeTicketShopListTableViewCell.h"
#import "RollShopInfoModel.h"


@interface HomeTicketShopListTableViewController ()<HomeTicketShopListTableViewCellDelegate>

@property (nonatomic, strong)NSMutableArray *dataArr;
@property (nonatomic, assign)int page;

@end

@implementation HomeTicketShopListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArr = [NSMutableArray array];
    self.page = 1;
    [self.navigationController.navigationBar setBarTintColor: BACKGROUNDCOLOR];
    [self getMassage];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"HomeTicketShopListTableViewCell" bundle:nil] forCellReuseIdentifier:@"temple"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = NO;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //#warning Incomplete implementation, return the number of sections
    return self.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //#warning Incomplete implementation, return the number of rows
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HomeTicketShopListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"temple" forIndexPath:indexPath];
    RollShopInfoModel *model = self.dataArr[indexPath.section];
    cell.delegate = self;
    cell.name.text = model.name;
    cell.desc.text = model.name;
    cell.local.text = model.address;
    cell.local.numberOfLines = 0;
    cell.model = model;
    cell.shopImage.layer.masksToBounds = YES;
    cell.shopImage.layer.cornerRadius = 5;
    [cell.shopImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE,model.photo]] placeholderImage:[UIImage imageNamed:@"loadingimg.png"] options:SDWebImageAllowInvalidSSLCertificates];
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}



- (void)getMassage{
    NSString *time = [MyBase64 getCurrentTimestamp];
    //    NSString *time = @"1500000000000";
    
    
    NSString *str = [MyBase64 base64EncodingWithData:[MD5 md5: [NSString stringWithFormat:@"%@%@",[MD5 md5: time],self.rollId]]];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:self.rollId,@"rollId",time,@"date",str,@"token", nil];
    [MJPush postWithURLString:SELECTALLSHOPINFO parameters:dic success:^(id sucess) {
        
        if ([[sucess objectForKey:@"code"] isEqualToString:@"000"]) {
            NSArray *arr = [NSArray arrayWithArray:[sucess objectForKey:@"data"]];
            for (NSDictionary *dic in arr ) {
                RollShopInfoModel *shop = [RollShopInfoModel setModelWithDictionary:dic];
                [self.dataArr addObject: shop];
            }
            [self.tableView reloadData];
        }else if ([[sucess objectForKey:@"code"] isEqualToString:@"001"]){
            ALERT([sucess objectForKey:@"message"]);
        }
        
    } failure:^(NSError *error) {
        
    }];
}

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//
//}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section > 0) {
        
        UIView *view = [[UIView alloc] initWithFrame:RECTMACK(0, 0, 414, 8)];
        view.backgroundColor = COLOUR(243, 243, 243);
        return view;
    }else{
        UIView *view = [[UIView alloc] initWithFrame:RECTMACK(0, 0, 414, 50)];
        view.backgroundColor = [UIColor whiteColor];
        
        
        UIImageView *image = [[UIImageView alloc] initWithFrame:RECTMACK(15, 15, 20, 20)];
        image.image = [UIImage imageNamed:@"home_shop.png"];
        [view addSubview: image];
        
        UILabel *title = [[UILabel alloc] initWithFrame:RECTMACK(40, 15, 100, 20)];
        title.text = @"商铺列表";
        
        [view addSubview: title];
        
        UIView *l = [[UIView alloc] initWithFrame:RECTMACK(0, 49, 414, 1)];
        l.backgroundColor = COLOUR(249, 249, 249);
        [view addSubview: l];
        return view;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
 
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    //    return 0.01f;
    if (section > 0) {
        return 8*SCREEN_WIDTH/414;
    }else{
        return 50;
    }
}


- (void)makeLocal:(RollShopInfoModel *)dic{
    AMapNaviViewController *map = [[AMapNaviViewController alloc] init];
    map.latitudeX = dic.latitudeX;
    map.latitudeY = dic.latitudeY;
    [self.navigationController pushViewController:map animated:YES];
}

- (void)makePhone:(RollShopInfoModel *)dic{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"是否拨打客服热线" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *OK = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%d",dic.linkTel]]];
    }];
    
    [alertC addAction: OK];
    
    UIAlertAction *concal = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertC addAction: concal];
    
    [self presentViewController:alertC animated:NO completion:^{
        
    }];
}

/*
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
 
 // Configure the cell...
 
 return cell;
 }
 */

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
