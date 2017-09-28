//
//  CityTableViewController.m
//  HB
//
//  Created by 王小康 on 16/1/11.
//  Copyright © 2016年 范强伟. All rights reserved.
//

#import "CityTableViewController.h"

@interface CityTableViewController ()
@property (nonatomic, retain)NSMutableArray *provincesArray;  // 用来承载解析完成的所有数据
@property (nonatomic, retain)NSString *cidString;  //  城市编号
@property (nonatomic, retain)NSString *nameString;  // 城市名
@property (nonatomic, retain)NSString *provincesString;  //  省份名
@end

@implementation CityTableViewController

- (void)ParserJsonData {
    NSString *pathString = [[NSBundle mainBundle] pathForResource:@"cities" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:pathString];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    self.provincesArray = [[NSMutableArray alloc] init];
    for (NSDictionary *provincestemp in [dic objectForKey:@"provinces"]) {
        [self.provincesArray addObject:provincestemp];
    }
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setBarTintColor: BACKGROUNDCOLOR];
    self.view.backgroundColor = [UIColor whiteColor];
    [self ParserJsonData];  //  得到所有的数据
//    self.navigationItem.title = [NSString stringWithFormat:@"当前城市 — %@", self.cityStr];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return self.provincesArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    NSArray *array = [self.provincesArray[section] objectForKey:@"cities"];
    return array.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    //  取出省份字典
    NSDictionary *cityDic = self.provincesArray[indexPath.section] ;
    //  取出城市字典
    NSDictionary *dic =  [cityDic objectForKey:@"cities"][indexPath.row];
    cell.textLabel.text = [dic objectForKey:@"name"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //  取出省份字典
    NSDictionary *cityDic = self.provincesArray[indexPath.section] ;
    //  取出城市字典
    NSDictionary *dic =  [cityDic objectForKey:@"cities"][indexPath.row];
    self.nameString = [dic objectForKey:@"name"];
    self.cidString = [dic objectForKey:@"cid"];
    self.provincesString = [cityDic objectForKey:@"name"];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:self.nameString forKey:@"city"];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(passValueWithDic:)]) {
        //  调用本类的代理方法，将值赋给代理方法的参数
        [self.delegate passValueWithDic:@{@"name":self.nameString,
                                          @"cid":self.cidString,
                                          @"provinces":self.provincesString,
                                          }];
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSDictionary *provincesDic = self.provincesArray[section];
    _provincesString = [provincesDic objectForKey:@"name"];
    return _provincesString;
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
