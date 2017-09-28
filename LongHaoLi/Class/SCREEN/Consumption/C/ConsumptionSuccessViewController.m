//
//  ConsumptionSuccessViewController.m
//  LongHaoLi
//
//  Created by Guang shen on 2017/8/31.
//  Copyright © 2017年 fanfan. All rights reserved.
//

#import "ConsumptionSuccessViewController.h"
#import "ConsumptionTableViewCell.h"
#import "ConsumptionSucessViewFoot.h"

@interface ConsumptionSuccessViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, retain)UITextField *textField;
@property (nonatomic, retain)UITableView *tableView;
 



@end
@implementation ConsumptionSuccessViewController
{
    float price;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COLOUR(249, 249, 249);
    self.title = @"确认支付";
 
    
    [self setpayView];
    // Do any additional setup after loading the view.
}

- (void)setpayView{
 
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIView *back = [[UIView alloc] initWithFrame:CGRectMake(0, 70, SCREEN_WIDTH, 50)];
    back.backgroundColor = [UIColor whiteColor];
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 60, 50)];
    lable.text = @"金额";
    [back addSubview: lable];
    
    UITextField *text = [[UITextField alloc] initWithFrame:CGRectMake(100, 0, SCREEN_WIDTH - 120, 50)];
    text.textAlignment = NSTextAlignmentRight;
    self.textField = text;
    self.textField.textColor = BACKGROUNDCOLOR;
    self.textField.delegate = self;
    self.textField.userInteractionEnabled = self.isChange;
    text.text = self.text;
    text.placeholder = self.placeHolder;
    [back addSubview: text];
    [self.view addSubview: back];
    
    [self tableViewSet];
    
    
    
    NSArray  *apparray= [[NSBundle mainBundle]loadNibNamed:@"ConsumptionSucessViewFoot" owner:nil options:nil];
    ConsumptionSucessViewFoot *appView  = [apparray firstObject];
    appView.frame = CGRectMake(0, SCREEN_HEIGHT - 150, SCREEN_WIDTH, 150);
    appView.price.text = [NSString stringWithFormat:@"%f",price];
//////    __weak ConsumptionSuccessViewController *success = self;
    appView.pay.layer.masksToBounds = YES;
    appView.pay.layer.cornerRadius = 5;
    [appView.pay addTarget:self action:@selector(payOrder) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: appView];
    
}

// 支付
- (void)payOrder{
    
}

- (void)tableViewSet{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 130, SCREEN_WIDTH, SCREEN_HEIGHT - 130 - 150)];
    self.tableView.delegate = self;
    self.tableView.dataSource =self;
    self.tableView.showsVerticalScrollIndicator = NO;
     [self.tableView registerNib:[UINib nibWithNibName:@"ConsumptionTableViewCell" bundle:nil] forCellReuseIdentifier:@"like"];
    
    [self.view addSubview: self.tableView];
    
    
    
    
//    NSArray  *apparray= [[NSBundle mainBundle]loadNibNamed:@"HomeTicketDetialTitle" owner:nil options:nil];
//    HomeTicketDetialTitle *appView  = [apparray firstObject];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ConsumptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"like"];
    
    cell.name.text =@"羊肉薄膜";
    cell.price.text =[NSString stringWithFormat:@"￥%0.2f",15.2];
    
    cell.btn.selected = cell.isSelect;
//    [cell.btn addTarget: self action:@selector(BtnSelect:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

//- (void)BtnSelect:(UIButton *)btn{
//    btn.selected = !btn.selected;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ConsumptionTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.btn.selected= !cell.btn.selected;
    cell.isSelect = cell.btn.selected;
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return  YES;
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
