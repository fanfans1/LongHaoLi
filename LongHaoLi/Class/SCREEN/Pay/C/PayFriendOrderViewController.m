//
//  PayFriendOrderViewController.m
//  LongHaoLi
//
//  Created by Guang shen on 2017/8/25.
//  Copyright © 2017年 fanfan. All rights reserved.
//

#import "PayFriendOrderViewController.h"
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>
@interface PayFriendOrderViewController ()<CNContactPickerDelegate,UITextFieldDelegate>

@property (nonatomic, retain)UITextField *textField;

@end

@implementation PayFriendOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *back = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    back.backgroundColor = COLOUR(249, 249, 249);
    [back addSubview:[self setViewHei:0 tit:self.rollInfo.name desc:self.rollInfo.intro image:[MyBase64 stringConpanSteing:self.rollInfo.photo] price:[NSString stringWithFormat:@"￥%.2f",self.rollInfo.originalPrice]]];
    [back addSubview:[self setViewHei:111 tit:@"实付金额:" desc:[NSString stringWithFormat:@"￥%.2f",self.rollInfo.salePrice]]];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [back addSubview:[self setViewHei:162 tit:@"手机号:" desc:[user objectForKey:@"tel"]]];
    [back addSubview:[self setViewHei:213 tit:@"赠送好友" palce:@"请输入赠送人手机号"]];
    
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeSystem];
    button2.frame = RECTMACK(50, 450, 314, 40);
    button2.layer.masksToBounds = YES;
    button2.layer.cornerRadius = 5;
    button2.backgroundColor = BACKGROUNDCOLOR;
    [button2 setTitle:@"提交订单" forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(btn2Action) forControlEvents:UIControlEventTouchUpInside];
    [back addSubview: button2];
    
    
    [self.view addSubview: back];
    
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


- (void)btn2Action{
    if (self.textField.text.length != 11 || ![self isNum:self.textField.text]) {
        ALERT(@"赠送人联系方式有误！");
        return;
    }
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
    NSString *time = [MyBase64 getCurrentTimestamp];
    NSString *str = [MyBase64 base64EncodingWithData:[MD5 md5: [NSString stringWithFormat:@"%@%@%@%@",[MD5 md5: time],[user objectForKey:@"id"],self.rollInfo.rollId,self.textField.text]]];
    [mdic setObject:self.rollInfo.rollId forKey:@"rollId"];
    [mdic setObject:[user objectForKey:@"id"] forKey:@"userId"];
    [mdic setObject:self.textField.text forKey:@"fTel"];
    [mdic setObject:time forKey:@"date"];
    [mdic setObject:str forKey:@"token"];
    [MJPush postWithURLString:SENDFRIEND parameters:mdic success:^(id sucess) {
        if ([sucess[@"code"] isEqualToString:@"000"]) {
            WebServerViewController *web = [[WebServerViewController alloc] init];
            web.url = [NSString stringWithFormat:@"%@%@",ORDERNUMBER,[[sucess objectForKey:@"data"] objectForKey:@"orderNum"]];
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
    
    UILabel *cen = [[UILabel alloc] initWithFrame:RECTMACK(110, 55, 300, 50)];
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
    UILabel *lable = [[UILabel alloc] initWithFrame:RECTMACK(15, 0, 130, 50)];
    lable.font = FONT(15);
    lable.text = tit;
    [view addSubview: lable];
    
    UITextField *cen = [[UITextField alloc] initWithFrame:RECTMACK(200, 10, 160, 30) ];
    cen.font = FONT(15);
    cen.placeholder = desc;
    cen.keyboardType = UIKeyboardTypeNamePhonePad;
    cen.layer.masksToBounds = YES;
    self.textField = cen;
    cen.delegate =self;
    cen.borderStyle = UITextBorderStyleRoundedRect;
    [view addSubview: cen];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = RECTMACK(370, 10, 30, 30);
    [btn setImage:[UIImage imageNamed:@"home_friend_order_phone_add.png"] forState:UIControlStateNormal];
    [view addSubview: btn];
    [btn addTarget:self action:@selector(ADDhone) forControlEvents:UIControlEventTouchUpInside];
    return view;
}




- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return  YES;
}

- (void)ADDhone{
    // 1.创建选择联系人的控制器
    CNContactPickerViewController *contactVc = [[CNContactPickerViewController alloc] init];
    // 2.设置代理
    contactVc.delegate = self;
    // 3.弹出控制器
    [self presentViewController:contactVc animated:YES completion:nil];
}

- (void)contactPickerDidCancel:(CNContactPickerViewController *)picker
{
    ALERT(@"取消选择联系人");
}
// 2.当选中某一个联系人时会执行该方法
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact
{
//    // 1.获取联系人的姓名
//    NSString *lastname = contact.familyName;
//    NSString *firstname = contact.givenName;
////    NSLog(@"%@ %@", lastname, firstname);
    
    // 2.获取联系人的电话号码(此处获取的是该联系人的第一个号码,也可以遍历所有的号码)
    NSArray *phoneNums = contact.phoneNumbers;
    CNLabeledValue *labeledValue = phoneNums[0];
    CNPhoneNumber *phoneNumer = labeledValue.value;
    NSString *phoneNumber = [phoneNumer.stringValue stringByReplacingOccurrencesOfString:@"-" withString:@""];
//    NSLog(@"%@", phoneNumber);
    self.textField.text = phoneNumber;
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
