//
//  HomeTemplePayViewController.m
//  LongHaoLi
//
//  Created by Guang shen on 2017/8/19.
//  Copyright © 2017年 fanfan. All rights reserved.
//

#import "HomeTemplePayViewController.h"
#import "HomeTemplePayTypeTableViewCell.h"
#import "HomeTemplePayPersonTableViewCell.h"
#define myDotNumbers     @"0123456789.\n"

#define myNumbers          @"0123456789\n"

@interface HomeTemplePayViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic, retain)UITableView *tableView;
@property (nonatomic, retain)UIButton *temp;
@property (nonatomic, retain)UITextField *name;
@property (nonatomic, retain)UITextField *price;

@end

@implementation HomeTemplePayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //    self.title = @"善行天下";
    
    self.view.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Resign)];
    [self.view addGestureRecognizer:tap];
    [self setTableView];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(50, SCREEN_HEIGHT - 80, SCREEN_WIDTH - 100, 40);
    [btn setTitle:@"确认支付" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.backgroundColor = BACKGROUNDCOLOR;
     [btn addTarget:self action:@selector(templeList) forControlEvents:UIControlEventTouchUpInside];
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 5;
    [self.view addSubview: btn];
    
    // Do any additional setup after loading the view.
}

- (void)Resign{
    [self.view endEditing: YES];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSCharacterSet *cs;
    
    if ([textField isEqual: self.price]) {
        
        NSUInteger nDotLoc = [textField.text rangeOfString:@"."].location;
        
        if (NSNotFound == nDotLoc && 0 != range.location) {
            
            cs = [[NSCharacterSet characterSetWithCharactersInString:myDotNumbers] invertedSet];
            
        }
    
        else {
            
            cs = [[NSCharacterSet characterSetWithCharactersInString:myNumbers] invertedSet];
            
        }
    
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        
        BOOL basicTest = [string isEqualToString:filtered];
        
        if (!basicTest) {
            
            
            
            ALERT(@"只能输入数字和小数点");
            
            return NO;
            
        }
    
        if (NSNotFound != nDotLoc && range.location > nDotLoc + 2) {
            
            ALERT(@"小数点后最多三位");
            
            return NO;
            
        }
    }
    
    return YES;
    
}

- (void)templeList{
    
    
    
    NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [mdic setValue:[user objectForKey:@"id"] forKey:@"userId"];
    [mdic setValue:self.shopId forKey:@"shopId"];
    [mdic setValue:[self.shopDic objectForKey:@"id"] forKey:@"bFactId"];
    [mdic setValue:self.price.text forKey:@"payAmount"];
    [mdic setValue:self.name.text forKey:@"name"];
    NSString *time = [MyBase64 getCurrentTimestamp];
    NSString *str = [MyBase64 base64EncodingWithData:[MD5 md5: [NSString stringWithFormat:@"%@%@%@%@%@%@",[MD5 md5: time],[user objectForKey:@"id"],self.shopId,[self.shopDic objectForKey:@"id"],self.price.text,self.name.text]]];
    [mdic setObject:time forKey:@"date"];
    [mdic setObject:str forKey:@"token"];
    
    [MJPush postWithURLString:CONTRIBUTION parameters:mdic success:^(id sucess) {
       
        if ([sucess[@"code"] isEqualToString:@"001"]) {
            ALERT(sucess[@"message"]);
        }else if ([sucess[@"code"] isEqualToString:@"000"]){
            WebServerViewController *web = [[WebServerViewController alloc] init];
            web.url = [NSString stringWithFormat:@"%@%@",ORDERNUMBER,[[sucess objectForKey:@"data"] objectForKey:@"orderNum"]];
            //                  web.url = [NSString stringWithFormat:@"%@123456",ORDERNUMBER ];
            [self.navigationController pushViewController:web animated:YES];
        }
        
    } failure:^(NSError *error) {
        
    }];
    
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return  YES;
}


- (void)setTableView{
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64-100)];
    table.dataSource = self;
    table.delegate =self;
    self.tableView = table;
    // 取消分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"HomeTemplePayTypeTableViewCell" bundle:nil] forCellReuseIdentifier:@"type"];
        [self.tableView registerNib:[UINib nibWithNibName:@"HomeTemplePayPersonTableViewCell" bundle:nil] forCellReuseIdentifier:@"person"];
    
    [self.view addSubview: table];
    self.tableView.showsVerticalScrollIndicator = NO;
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
 
    
}

- (void)getMassage{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    
    [dic setValue:[NSString stringWithFormat:@"%f",APPDELEGATE.latitude] forKey:@"latitudeX"];
    [dic setValue:[NSString stringWithFormat:@"%f",APPDELEGATE.longitude]  forKey:@"latitudeY"];
    
    
    [MJPush postWithURLString:ROLLINFO parameters:dic success:^(id sucess) {
        
        
    } failure:^(NSError *error) {
        
    }];
    
    
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //#warning Incomplete implementation, return the number of rows
    
    return 3;
    
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        
        HomeTemplePayTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"type"];
        cell.payType.text = [self.shopDic objectForKey:@"benefactionActName"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
    }else if (indexPath.row == 1){
        HomeTemplePayPersonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"person"];
        cell.payTextFiled.placeholder = @"请输入施主姓名";
        cell.payTextFiled.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
        cell.payTextFiled.delegate = self;
        cell.payTextFiled.keyboardType= UIKeyboardTypeDefault;
        self.name = cell.payTextFiled;
        cell.payTextFiled.returnKeyType = UIReturnKeyGo;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
    }else{
        HomeTemplePayPersonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"person"];
        cell.payTextFiled.placeholder = @"请输入布施金额 /元";
        cell.payTextFiled.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
        cell.payTextFiled.delegate = self;
        cell.payTextFiled.keyboardType = UIKeyboardTypeDefault;
        self.price = cell.payTextFiled;
        cell.payTextFiled.returnKeyType = UIReturnKeyGo;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
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
