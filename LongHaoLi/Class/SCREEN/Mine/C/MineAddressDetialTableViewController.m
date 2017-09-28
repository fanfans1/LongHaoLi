//
//  MineAddressDetialTableViewController.m
//  LongHaoLi
//
//  Created by Guang shen on 2017/8/9.
//  Copyright © 2017年 fanfan. All rights reserved.
//

#import "MineAddressDetialTableViewController.h"
#import "MineAddressDetialTableViewCell.h"
#import "ZmjPickView.h"

@interface MineAddressDetialTableViewController ()<MineAddressDetialTableViewCellDelegate>
@property (strong, nonatomic) ZmjPickView *zmjPickView;

@property (nonatomic, strong)UITextField *textField;
@property (nonatomic, strong)NSMutableArray *marr;
@property (nonatomic, retain)UIButton *temp;

@end

@implementation MineAddressDetialTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = YES;
   
    [self.tableView registerNib:[UINib nibWithNibName:@"MineAddressDetialTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addVIew)];
    [self getUserAdd];
    self.tableView.tableFooterView = [[UIView alloc]  init];
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
}

- (void)addVIew{
    
    
    [self zmjPickView];
    
    [_zmjPickView show];
    
    __weak typeof(self) weakSelf = self;
    _zmjPickView.determineBtnBlock = ^(NSInteger shengId, NSInteger shiId, NSInteger xianId, NSString *shengName, NSString *shiName, NSString *xianName){
        __strong typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf ShengId:shengId ShiId:shiId XianId:xianId];
        [strongSelf ShengName:shengName ShiName:shiName XianName:xianName];
        NSString *str = [NSString stringWithFormat:@"%@%@%@",shengName,shiName,xianName];
        [weakSelf alert:str];
    };
}


// 添加收货地址
- (void)alert:(NSString *)address{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请输入详细地址" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        //                text = textField;
        textField.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
        self.textField =textField;
        textField.text = address;
        
    }];
    
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (self.textField.text.length > 1) {
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            NSString *time = [MyBase64 getCurrentTimestamp];
            //    NSString *time = @"1500000000000";
            
            
            NSString *str = [MyBase64 base64EncodingWithData:[MD5 md5: [NSString stringWithFormat:@"%@%@%@",[MD5 md5: time],[user objectForKey:@"id"],self.textField.text]]];
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[user objectForKey:@"id"],@"userId",self.textField.text,@"address",time,@"date",str,@"token", nil];
            [MJPush postWithURLString:ADDRESS parameters:dic success:^(id sucess) {
                if ([[sucess objectForKey:@"code"] isEqualToString:@"000"]) {
                   
                    [self getUserAdd];
                    ALERT(@"添加成功");
                }else if ([[sucess objectForKey:@"code"] isEqualToString:@"001"]){
                    ALERT([sucess objectForKey:@"message"]);
                }
            } failure:^(NSError *error) {
                
            }];
        }
        
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
    
    
}

// 获取收货地址
- (void)getUserAdd{
    
    self.marr = [NSMutableArray array];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *time = [MyBase64 getCurrentTimestamp];
    NSString *str = [MyBase64 base64EncodingWithData:[MD5 md5: [NSString stringWithFormat:@"%@%@",[MD5 md5: time],[user objectForKey:@"id"]]]];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[user objectForKey:@"id"],@"userId", time,@"date",str  ,@"token",nil];
    [MJPush postWithURLString:SELECTADDRESSLIST parameters:dic success:^(id sucess) {
        
        if ([[sucess objectForKey:@"code"] isEqualToString:@"000"]) {
         
            [self.marr addObjectsFromArray:[sucess objectForKey:@"data"]];
            if (self.marr.count == 0) {
                [self addVIew];
            }
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                    
                });
            });
        }else if([[sucess objectForKey:@"code"] isEqualToString:@"001"]){
            [self addVIew];
        }else{
            ALERT([sucess objectForKey:@"message"]);
        }
    } failure:^(NSError *error) {
        
    }];
    
}

- (void)ShengId:(NSInteger)shengId ShiId:(NSInteger)shiId XianId:(NSInteger)xianId{
    
    //    NSLog(@"%ld,%ld,%ld",shengId,shiId,xianId);
}

- (void)ShengName:(NSString *)shengName ShiName:(NSString *)shiName XianName:(NSString *)xianName{
    
    //    NSLog(@"%@,%@,%@",shengName,shiName,xianName);
}

- (ZmjPickView *)zmjPickView {
    if (!_zmjPickView) {
        _zmjPickView = [[ZmjPickView alloc]init];
    }
    return _zmjPickView;
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MineAddressDetialTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.delegate = self;
    NSDictionary *dic = self.marr[indexPath.row];
    cell.address.text = [dic objectForKey:@"address"];
    NSString *str = [NSString stringWithFormat:@"%@",[dic objectForKey:@"status"]];
    if ([str isEqualToString:@"0"]) {
        cell.select.selected = NO;
    }else{
        cell.select.selected = YES;
        self.temp = cell.select;
    }
    cell.select.tag = indexPath.row;
    
    return cell;
}


// 改变收货地址
- (void)selectAddress:(UIButton *)btn{
    if (btn.selected) {
        return ;
    }
   
    NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [mdic setObject:[user objectForKey:@"id"] forKey:@"userId"];
    [mdic setObject:[self.marr[btn.tag] objectForKey:@"address"] forKey:@"address"];
    NSString *time = [MyBase64 getCurrentTimestamp];
    NSString *str = [MyBase64 base64EncodingWithData:[MD5 md5: [NSString stringWithFormat:@"%@%@%@",[MD5 md5: time],[user objectForKey:@"id"],[self.marr[btn.tag] objectForKey:@"address"]]]];
    [mdic setObject:time forKey:@"date"];
    [mdic setObject:str forKey:@"token"];
    
    
    [MJPush postWithURLString:DEFAULTADDRESS parameters:mdic success:^(id sucess) {
        if ([[sucess objectForKey:@"code"] isEqualToString:@"000"]) {
//            ALERT(@"设置成功")
            self.temp.selected = NO;
            btn.selected = !btn.selected;
            self.temp = btn;
            [self getUserAdd];
        }else if ([[sucess objectForKey:@"code"] isEqualToString:@"001"]){
            ALERT([sucess objectForKey:@"message"]);
        }
    } failure:^(NSError *error) {
        
    }];
    
    
//    btn.selected = !btn.selected;
}



@end
