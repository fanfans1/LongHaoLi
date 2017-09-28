//
//  PayPostOrderViewController.m
//  LongHaoLi
//
//  Created by Guang shen on 2017/9/11.
//  Copyright © 2017年 fanfan. All rights reserved.
//

#import "PayPostOrderViewController.h"

@interface PayPostOrderViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, retain)UITextField *textField;
@property (nonatomic, retain)UITableView *tableView;
@property (nonatomic, retain)NSMutableArray *marr;
@end

@implementation PayPostOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIView *back = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    back.backgroundColor = COLOUR(249, 249, 249);
    [back addSubview:[self setViewHei:0 tit:self.rollInfo.name desc:self.rollInfo.intro image:[MyBase64 stringConpanSteing:self.rollInfo.photo] price:[NSString stringWithFormat:@"￥%.2f",self.rollInfo.originalPrice]]];
    [back addSubview:[self setViewHei:111 tit:@"实付金额:" desc:[NSString stringWithFormat:@"￥%.2f",self.rollInfo.salePrice]]];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [back addSubview:[self setViewHei:162 tit:@"手机号:" desc:[user objectForKey:@"tel"]]];
    [back addSubview:[self setViewHei:213 tit:@"邮寄地址" palce:@"请输入邮寄地址"]];
    
 
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeSystem];
    button2.frame = RECTMACK(50, 450, 314, 40);
    button2.layer.masksToBounds = YES;
    button2.layer.cornerRadius = 5;
    button2.backgroundColor = BACKGROUNDCOLOR;
    [button2 setTitle:@"提交订单" forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(btn2Action) forControlEvents:UIControlEventTouchUpInside];
    [back addSubview: button2];
    self.marr = [NSMutableArray array];
    
    [self.view addSubview: back];
    [self addressTableView:back];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    ISLOGIN
}



- (BOOL)isNum:(NSString *)checkedNumString {
    checkedNumString = [checkedNumString stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(checkedNumString.length > 0) {
        return NO;
    }
    return YES;
}

- (void)addressTableView:(UIView *)back{
    
    self.tableView = [[UITableView alloc] initWithFrame:RECTMACK(0, 264, 414, 150)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.hidden = YES;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    [back addSubview: self.tableView];
    [self getAdderss];
}

- (void)getAdderss{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *time = [MyBase64 getCurrentTimestamp];
    NSString *str = [MyBase64 base64EncodingWithData:[MD5 md5: [NSString stringWithFormat:@"%@%@",[MD5 md5: time],[user objectForKey:@"id"]]]];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[user objectForKey:@"id"],@"userId", time,@"date",str  ,@"token",nil];
    [MJPush postWithURLString:SELECTADDRESSLIST parameters:dic success:^(id sucess) {
        
        if ([[sucess objectForKey:@"code"] isEqualToString:@"000"]) {
            
            [self.marr addObjectsFromArray:[sucess objectForKey:@"data"]];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                    
                });
            });
      
        }
    } failure:^(NSError *error) {
        
    }];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    NSDictionary *dic = self.marr[indexPath.row];
    cell.textLabel.text = [dic objectForKey:@"address"];
    NSString *str = [NSString stringWithFormat:@"%@",[dic objectForKey:@"status"]];
    if ([str isEqualToString:@"0"]) {
    }else{
        self.textField.text =  [dic objectForKey:@"address"];
    }

    
    return cell;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.marr.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = self.marr[indexPath.row];
    
    self.textField.text =  [dic objectForKey:@"address"];
    self.tableView.hidden = YES;
}



- (void)btn2Action{
    if (self.textField.text.length < 1 ) {
        ALERT(@"邮寄地址有误！");
        return;
    }
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
    NSString *time = [MyBase64 getCurrentTimestamp];
    NSString *str;
    if (self.recordID) {
        [mdic setObject:self.recordID forKey:@"recordID"];
        str  = [MyBase64 base64EncodingWithData:[MD5 md5: [NSString stringWithFormat:@"%@%@%@%@%@",[MD5 md5: time],[user objectForKey:@"id"],self.rollInfo.rollId,self.textField.text,self.recordID]]];
    }else if (self.srID){
        [mdic setObject:self.srID forKey:@"srID"];
         str  = [MyBase64 base64EncodingWithData:[MD5 md5: [NSString stringWithFormat:@"%@%@%@%@%@",[MD5 md5: time],[user objectForKey:@"id"],self.rollInfo.rollId,self.textField.text,self.srID]]];
    }else{
        
        str  = [MyBase64 base64EncodingWithData:[MD5 md5: [NSString stringWithFormat:@"%@%@%@%@",[MD5 md5: time],[user objectForKey:@"id"],self.rollInfo.rollId,self.textField.text]]];
    }
    [mdic setObject:self.rollInfo.rollId forKey:@"rollId"];
    [mdic setObject:[user objectForKey:@"id"] forKey:@"userId"];
    [mdic setObject:self.textField.text forKey:@"address"];
    [mdic setObject:time forKey:@"date"];
    [mdic setObject:str forKey:@"token"];
    [MJPush postWithURLString:POSTGOODS parameters:mdic success:^(id sucess) {
        if ([sucess[@"code"] isEqualToString:@"000"]) {
            WebServerViewController *web = [[WebServerViewController alloc] init];
            web.url = [NSString stringWithFormat:@"%@%@",ORDERNUMBER,[[sucess objectForKey:@"data"] objectForKey:@"orderNum"]];
//            web.url = [NSString stringWithFormat:@"%@123456",ORDERNUMBER ];
            [self.navigationController pushViewController:web animated:YES];

        }else if ([sucess[@"code"] isEqualToString:@"001"]) {
            ALERT(sucess[@"message"]);
        }
        
    } failure:^(NSError *error) {
        
    }];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView *)setViewHei:(float)hei tit:(NSString *)tit desc:(NSString *)desc image:(NSString *)imagename price:(NSString *)str{
    UIView *view = [[UIView alloc] initWithFrame:RECTMACK(0, hei, 414, 110)];
    view.backgroundColor = [UIColor whiteColor];
    UIImageView *image = [[UIImageView alloc] init];
    image.frame = RECTMACK(15, 15, 80, 80);
    [image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE,imagename]] placeholderImage:[UIImage imageNamed:@"loadingimg.png"] options:SDWebImageAllowInvalidSSLCertificates];
    [view addSubview: image];
    
    UILabel *lable = [[UILabel alloc] initWithFrame:RECTMACK(110, 5, 300, 50)];
    lable.font = FONT(16);
    lable.text = tit;
    [view addSubview: lable];
    
    UILabel *cen = [[UILabel alloc] initWithFrame:RECTMACK(110, 55, 300 , 50)];
    cen.textColor = [UIColor grayColor];
    cen.textColor = [UIColor grayColor];
    cen.font = FONT(15);
    cen.text = desc;
    [view addSubview: cen];
    
    UILabel *price = [[UILabel alloc] initWithFrame:RECTMACK(250, 30, 150, 50)];
    price.textAlignment = NSTextAlignmentRight;
    price.font = FONT(17);
    price.textColor = BACKGROUNDCOLOR;
    price.text = str;
//    [view addSubview: price];
    
    return view;
}


- (UIView *)setViewHei:(float)hei tit:(NSString *)tit desc:(NSString *)desc{
    UIView *view = [[UIView alloc] initWithFrame:RECTMACK(0, hei, 414, 50)];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *lable = [[UILabel alloc] initWithFrame:RECTMACK(15, 0, 130, 50)];
    lable.font = FONT(15);
    lable.text = tit;
    [view addSubview: lable];
    
    UILabel *cen = [[UILabel alloc] initWithFrame:RECTMACK(200, 0, 200, 50)];
    cen.textAlignment = NSTextAlignmentRight;
    cen.font = FONT(15);
    cen.text = desc;
    [view addSubview: cen];
    
    return view;
}

- (UIView *)setViewHei:(float)hei tit:(NSString *)tit palce:(NSString *)desc{
    UIView *view = [[UIView alloc] initWithFrame:RECTMACK(0, hei, 414, 50)];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *lable = [[UILabel alloc] initWithFrame:RECTMACK(15, 0, 100, 50)];
    lable.font = FONT(15);
    lable.text = tit;
    [view addSubview: lable];
    
    UITextField *cen = [[UITextField alloc] initWithFrame:RECTMACK(120, 10, 240, 30) ];
    cen.font = FONT(15);
    cen.placeholder = desc;
    cen.keyboardType = UIKeyboardTypeNamePhonePad;
    cen.layer.masksToBounds = YES;
    self.textField = cen;
    cen.textAlignment = NSTextAlignmentRight;
    cen.delegate =self;
    cen.borderStyle = UITextBorderStyleRoundedRect;
    [view addSubview: cen];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = RECTMACK(375, 10, 30, 30);
    [btn setImage:[UIImage imageNamed:@"next.png"] forState:UIControlStateNormal];
    [view addSubview: btn];
    [btn addTarget:self action:@selector(ADDhone) forControlEvents:UIControlEventTouchUpInside];
    return view;
}

- (void)ADDhone{
    if (self.marr.count == 0) {
        self.tableView.hidden = YES;
        ALERT(@"请手动输入收货地址！");
        return;
    }
    self.tableView.hidden = !self.tableView.hidden;
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return  YES;
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
