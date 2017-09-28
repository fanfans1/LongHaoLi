//
//  MineShopAddTableViewController.m
//  LongHaoLi
//
//  Created by Guang shen on 2017/8/9.
//  Copyright © 2017年 fanfan. All rights reserved.
//

#import "MineShopAddTableViewController.h"

#import "MineShopIntroTableViewCell.h"
#import "MineShopAddAddressTableViewCell.h"
#import "MineShopNameTableViewCell.h"
#import "ShopLocalViewController.h" // 商户定位

@interface MineShopAddTableViewController ()<UITextViewDelegate,UITextFieldDelegate,ShopLocalViewControllerDelegate>

@property (nonatomic, strong)UITextField *shopName;
@property (nonatomic, strong)UITextField *shopPhone;
@property (nonatomic, strong)UITextField *shopUser;
@property (nonatomic, strong)UITextField *shopNum;
@property (nonatomic, strong)UILabel *shopAddress;
@property (nonatomic, strong)UITextView *shopDesc;

@end

@implementation MineShopAddTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.automaticallyAdjustsScrollViewInsets = YES;
 
    //    [self.tableView registerNib:[UINib nibWithNibName:@"MineShopNameTableViewCell" bundle:nil] forCellReuseIdentifier:@"shopName"];
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MineShopAddAddressTableViewCell" bundle:nil] forCellReuseIdentifier:@"address" ];
    [self.tableView registerNib:[UINib nibWithNibName:@"MineShopNameTableViewCell" bundle:nil] forCellReuseIdentifier:@"shopName"];
    [self.tableView registerNib:[UINib nibWithNibName:@"MineShopIntroTableViewCell" bundle:nil] forCellReuseIdentifier:@"intro"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    //    self.tableView.separatorStyle = UITableViewCellStyleDefault;
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.tableView.bounces = NO;
    self.tableView.tableFooterView = [[UIView alloc]  init];
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.tableView endEditing:YES];
    return  YES;
}



-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        
        
        [self.tableView endEditing:YES];
        return NO;
    }
    return YES;
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
    return 7;
}

- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < 3 || indexPath.row == 4) {
        MineShopNameTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"shopName"];
        if (indexPath.row == 0) {
            cell.type.text = @"商家名称";
            cell.desc.placeholder = @"请输入商户名称";
            self.shopName = cell.desc;
        } else if (indexPath.row == 1) {
            cell.type.text = @"联系人";
            cell.desc.placeholder = @"请输入姓名";
            self.shopUser = cell.desc;
        }else   if (indexPath.row == 2) {
            cell.type.text = @"联系电话";
            cell.desc.placeholder = @"请输入电话";
            self.shopPhone = cell.desc;
        } else{
            cell.type.text = @"推荐码";
            cell.desc.keyboardType = UIKeyboardTypeNumberPad;
            cell.desc.placeholder = @"选填";
            self.shopNum = cell.desc;
        }
        cell.desc.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else
        if (indexPath.row == 3){
            MineShopAddAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"address"];
            self.shopAddress = cell.address;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else if (indexPath.row == 5){
            MineShopIntroTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"intro"];
            cell.textFile.layer.cornerRadius = 5;
            cell.textFile.layer.masksToBounds = YES;
            cell.textFile.layer.borderColor = COLOUR(222, 222, 222).CGColor;
            cell.textFile.layer.borderWidth = 1;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            self.shopDesc = cell.textFile;
            cell.textFile.delegate = self;
            return cell;
            
        }else{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
            btn.frame = RECTMACK(50, 30, 314, 50);
            btn.layer.masksToBounds = YES;
            btn.layer.cornerRadius = 5;
            btn.backgroundColor = BACKGROUNDCOLOR;
            [btn setTitle:@"提交" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview: btn];
            
            return cell;
        }
}

- (void)btnAction{
    if (self.shopName.text.length < 1) {
        ALERT(@"请输入商户名");
        return;
    }
    if (self.shopUser.text.length < 1) {
        ALERT(@"请输入联系人");
            return;
    }
    if (self.shopNum.text.length < 1) {
        self.shopNum.text = @"";
    }
    if (self.shopPhone.text.length < 1) {
        ALERT(@"请输入联系方式");
        return;
    }
    if (self.shopAddress.text.length < 5) {
        ALERT(@"请选择商户地址");
        return;
    }
    if (self.shopDesc.text.length < 1) {
        ALERT(@"请输入商户描述");
        return;
    }
    NSString *time = [MyBase64 getCurrentTimestamp];
    NSString *str = [MyBase64 base64EncodingWithData:[MD5 md5: [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@",[MD5 md5: time],self.shopName.text,self.shopUser.text,self.shopPhone.text,self.shopAddress.text,self.shopDesc.text,[NSString stringWithFormat:@"%.6f",APPDELEGATE.latitude],[NSString stringWithFormat:@"%.6f",APPDELEGATE.longitude]]]];
    
    NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
    [mdic setValue:self.shopName.text forKey:@"name"];
    [mdic setValue:self.shopUser.text forKey:@"linkPerson"];
    [mdic setValue:self.shopNum.text forKey:@"employeeId"];
    [mdic setValue:self.shopPhone.text forKey:@"linkTel"];
    [mdic setValue:self.shopAddress.text forKey:@"address"];
    [mdic setValue:self.shopDesc.text forKey:@"intro"];
    [mdic setValue:[NSString stringWithFormat:@"%.6f",APPDELEGATE.longitude] forKey:@"latitudeY"];
    [mdic setValue:[NSString stringWithFormat:@"%.6f",APPDELEGATE.latitude] forKey:@"latitudeX"];
    [mdic setObject:time forKey:@"date"];
    [mdic setObject:str forKey:@"token"];
    [MJPush postWithURLString:APPLYFORSHOP parameters:mdic success:^(id sucess) {
        if ([[sucess objectForKey:@"code"] isEqualToString:@"000"]) {
            [self.navigationController popViewControllerAnimated:YES];
            ALERT(@"申请成功");
        }else if ([[sucess objectForKey:@"code"] isEqualToString:@"001"]){
            ALERT([sucess objectForKey:@"message"]);
        }
    } failure:^(NSError *error) {
        
    }];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 3) {
        ShopLocalViewController *local = [[ShopLocalViewController alloc] init];
        local.delegate = self;
        [self.navigationController pushViewController:local animated:YES];
    }
    
}

- (void)passValue:(double)la lo:(double)lo city:(NSString *)city det:(NSString *)det{
    
    APPDELEGATE.latitude = la;
    APPDELEGATE.longitude = lo;
    self.shopAddress.text = det;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < 5) {
        return 60;
    }else if(indexPath.row == 5){
        return 240;
    }else{
        return 100;
    }
}


@end
