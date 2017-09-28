//
//  HomeTempleDetialViewController.m
//  LongHaoLi
//
//  Created by Guang shen on 2017/8/19.
//  Copyright © 2017年 fanfan. All rights reserved.
//

#import "HomeTempleDetialViewController.h"
#import "HomeTicketDetialHeadTableViewCell.h"
#import "HomeTempleDetialDescTableViewCell.h"
#import "HomeTempleDetialDescTypeViewController.h"


@interface HomeTempleDetialViewController ()



@end

@implementation HomeTempleDetialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self getMassage];
    // Do any additional setup after loading the view.
}

- (void)setViewControl:(NSString *)shop desc:(NSString *)desc{
    UIImageView *back = [[UIImageView alloc] init];
    back.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    back.image = [UIImage imageNamed:@"home_temple_back.png"];
    
    UIImageView *shopImage = [[UIImageView alloc] initWithFrame:RECTMACK(0, (50 + 64*414/SCREEN_WIDTH), 414, 240)];
    [shopImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE,[MyBase64 stringConpanSteing:shop ]]] placeholderImage:[UIImage imageNamed:@"loadingimg.png"] options:SDWebImageAllowInvalidSSLCertificates];
    [self.view addSubview: shopImage];
    [self.view addSubview: back];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = RECTMACK(110,(340 + 64*414/SCREEN_WIDTH), 194, 44);
    [btn setImage:[UIImage imageNamed:@"home_temple_btn.png"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(templeList) forControlEvents:UIControlEventTouchUpInside];
//    btn.backgroundColor = BACKGROUNDCOLOR;
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 5;
    [self.view addSubview: btn];
    
    
    UIImageView *shopBackImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 233*SCREEN_WIDTH/414, SCREEN_WIDTH, 233*SCREEN_WIDTH/414)];
    shopBackImage.image = [UIImage imageNamed:@"home_temple_foot.png"];
    [self.view addSubview: shopBackImage];

    
    CoreTextView *text = [[CoreTextView alloc] initWithFrame:RECTMACK(30, 30, 354,  173)];
    text.text = desc;
    text.font = FONT(13);
    text.textColor = COLOUR(254, 247, 179);
    text.numberOfLines = 0;
    text.backgroundColor = [UIColor clearColor];
   text.baseLine  = CoreTextBaseLineCenter;
    [shopBackImage addSubview: text];
    
}

 

- (void)templeList{
    HomeTempleDetialDescTypeViewController *type = [[HomeTempleDetialDescTypeViewController alloc ] init];
    type.shopId = self.shopId;
    [self.navigationController pushViewController:type animated:YES];
}



- (void)getMassage{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString *time = [MyBase64 getCurrentTimestamp];
    //    NSString *time = @"1500000000000";
    
    
    NSString *str = [MyBase64 base64EncodingWithData:[MD5 md5: [NSString stringWithFormat:@"%@%@",[MD5 md5: time],self.shopId]]];
    
    [dic setValue:[NSString stringWithFormat:@"%@",self.shopId] forKey:@"shopID"];
    [dic setObject:time forKey:@"date"];
    [dic setObject:str forKey:@"token"];
    [MJPush postWithURLString:BENEFACTIONSHOPINFO parameters:dic success:^(id sucess) {
        if ([[sucess objectForKey:@"code"] isEqualToString:@"000"]) {
            
            [self setViewControl:[[sucess objectForKey:@"data"] objectForKey:@"photo"] desc:[[sucess objectForKey:@"data"] objectForKey:@"intro"]];
        }else if ([[sucess objectForKey:@"code"] isEqualToString:@"001"]){
            ALERT([sucess objectForKey:@"message"]);
        }
    } failure:^(NSError *error) {
        
    }];
    
    
    
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
