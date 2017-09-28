//
//  PayTicketOrderViewController.m
//  LongHaoLi
//
//  Created by Guang shen on 2017/8/24.
//  Copyright © 2017年 fanfan. All rights reserved.
//

#import "PayTicketOrderViewController.h"

@interface PayTicketOrderViewController ()

@end

@implementation PayTicketOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *back = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    back.backgroundColor = COLOUR(249, 249, 249);
    [back addSubview:[self setViewHei:0 tit:self.rollInfo.name desc:self.rollInfo.intro image:[MyBase64 stringConpanSteing:self.rollInfo.photo] price:[NSString stringWithFormat:@"￥%.2f",self.rollInfo.originalPrice]]];
    [back addSubview:[self setViewHei:111 tit:@"实付金额:" desc:[NSString stringWithFormat:@"￥%.2f",self.rollInfo.salePrice]]];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [back addSubview:[self setViewHei:162 tit:@"手机号:" desc:[user objectForKey:@"tel"]]];
    
    
    
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

- (void)btn2Action{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
    NSString *time = [MyBase64 getCurrentTimestamp];
    NSString *str;
    if (self.recordID) {
        str =  [MyBase64 base64EncodingWithData:[MD5 md5: [NSString stringWithFormat:@"%@%@%@%@",[MD5 md5: time],[user objectForKey:@"id"],self.rollInfo.rollId,self.recordID]]];
        [mdic setObject:self.recordID forKey:@"recordID"];
    }else if (self.srID){
        str =  [MyBase64 base64EncodingWithData:[MD5 md5: [NSString stringWithFormat:@"%@%@%@%@",[MD5 md5: time],[user objectForKey:@"id"],self.rollInfo.rollId,self.srID]]];
        [mdic setObject:self.srID forKey:@"srID"];
    }else{
        str =  [MyBase64 base64EncodingWithData:[MD5 md5: [NSString stringWithFormat:@"%@%@%@",[MD5 md5: time],[user objectForKey:@"id"],self.rollInfo.rollId]]];
    }
    [mdic setObject:self.rollInfo.rollId forKey:@"rollId"];
    [mdic setObject:[user objectForKey:@"id"] forKey:@"userId"];
    [mdic setObject:time forKey:@"date"];
    [mdic setObject:str forKey:@"token"];
    [MJPush postWithURLString:ROLL parameters:mdic success:^(id sucess) {
        if ([sucess[@"code"] isEqualToString:@"000"]) {
//            NSLog(@"%@",mdic);
            WebServerViewController *web = [[WebServerViewController alloc] init];
            web.url = [NSString stringWithFormat:@"%@%@",ORDERNUMBER,[[sucess objectForKey:@"data"] objectForKey:@"orderNum"]];
//                  web.url = [NSString stringWithFormat:@"%@123456",ORDERNUMBER ];
            [self.navigationController pushViewController:web animated:YES];
        }else if ([sucess[@"code"] isEqualToString:@"001"]) {
            ALERT(sucess[@"message"]);
        }
          NSLog(@"%@",mdic);
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
    cen.numberOfLines = 0;
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

- (void)viewWillAppear:(BOOL)animated{
    ISLOGIN
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
