//
//  HomeLuckGiftViewController.m
//  LongHaoLi
//
//  Created by Guang shen on 2017/8/21.
//  Copyright © 2017年 fanfan. All rights reserved.
//

#import "HomeLuckGiftViewController.h"
#import "Luck.h"
#import "HomeLuckGiftHistoryTableViewController.h"

@interface HomeLuckGiftViewController ()<CAAnimationDelegate,LuckDelegate>

@property (nonatomic, retain)NSMutableArray *marr;
@property (nonatomic, retain)NSString *str;

@property (nonatomic, retain)UILabel *value;
@property (nonatomic, retain)UILabel *lable3;

@end

@implementation HomeLuckGiftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我要抽奖";
//    [self.navigationController.navigationBar setBarTintColor: BACKGROUNDCOLOR];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //    [self creatNavView];

    self.marr = [NSMutableArray array];
    
    
    
    UIImageView *image = [[UIImageView alloc] initWithFrame:RECTMACK(0, 0, 414, 736)];
    image.image = [UIImage imageNamed:@"home_luck_back.png"];
    image.userInteractionEnabled = YES;
    [self.view addSubview: image];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(15, 24, 30, 30);
    [btn setImage:[UIImage imageNamed:@"home_back.png"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(backView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: btn];
    
    UIButton *btn1= [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(SCREEN_WIDTH - 95, 24, 80, 30);
    [btn1 setTitle:@"历史记录"  forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(Gift) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: btn1];
    
    UILabel *lable = [[UILabel alloc] initWithFrame:RECTMACK(0, 540, 414, 27)];
    lable.font = FONT(20);
    lable.textColor = [UIColor yellowColor];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.text = @"中奖内容";
    [self.view addSubview: lable];
    
    UILabel *lable1 = [[UILabel alloc] initWithFrame:RECTMACK(91, 580, 230, 33)];
    lable1.font = FONT(18);
    lable1.backgroundColor = [UIColor yellowColor];
    lable1.textAlignment = NSTextAlignmentCenter;
    self.value = lable1;
    [self.view addSubview: self.value];
    
    
    UILabel *lable2 = [[UILabel alloc] initWithFrame:RECTMACK(0, 644, 414, 14)];
    lable2.font = FONT(14);
    lable2.textColor = [UIColor yellowColor];
    lable2.textAlignment = NSTextAlignmentCenter;
    lable2.text = @"使用规则";
    [self.view addSubview: lable2];
    
    _lable3 = [[UILabel alloc] initWithFrame:RECTMACK(100, 663, 260, 50)];
    _lable3.font = FONT(13);
    _lable3.textColor = [UIColor yellowColor];
    _lable3.textAlignment = NSTextAlignmentLeft;
    _lable3.numberOfLines = 0;
    _lable3.text = @"";
    [self.view addSubview: _lable3];
    
    
    
    [self getmassage];
    
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"历史记录" style:UIBarButtonItemStylePlain target:self action:@selector(Gift)];
    // Do any additional setup after loading the view.
}

- (void)backView{
    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)Gift{
    
    HomeLuckGiftHistoryTableViewController *hsitory = [[HomeLuckGiftHistoryTableViewController alloc] init];
    [self.navigationController pushViewController:hsitory animated:YES];
    
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = NO;
}

- (void)getmassage{
    NSUserDefaults *use = [NSUserDefaults standardUserDefaults];
    NSDictionary *mdic = [NSMutableDictionary dictionary];
    [mdic setValue:[use objectForKey:@"city"] forKey:@"address"];
    [mdic setValue:[use objectForKey:@"id"] forKey:@"userId"];
    NSString *time = [MyBase64 getCurrentTimestamp];
    NSString *str = [MyBase64 base64EncodingWithData:[MD5 md5: [NSString stringWithFormat:@"%@%@%@",[MD5 md5: time],[use objectForKey:@"city"],[use objectForKey:@"id"]]]];
    [mdic setValue:time forKey:@"date"];
    [mdic setValue:str forKey:@"token"];
    
    [MJPush postWithURLString:SELECTLOTTERYDRAW parameters:mdic success:^(id sucess) {
        
        if ([[sucess objectForKey:@"code"] isEqualToString:@"000"]) {
            NSMutableArray *marr = [NSMutableArray array];
            NSArray *arr = [NSArray arrayWithArray:[[sucess objectForKey:@"data"] objectForKey:@"rollApps"]];
            int temp = 100;
            if (arr.count != 7) {
                
                ALERT(@"暂时不能抽奖！");
                return ;
            }
            self.str = [[sucess objectForKey:@"data"] objectForKey:@"lotteryDrawID"];
            for (int i = 0; i < arr.count; i++) {
                temp = temp - [[arr[i] objectForKey:@"probability"] intValue];
            }
            [marr addObjectsFromArray:arr];
            NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
            [mdic setObject:@"0" forKey:@"id"];
            [mdic setObject:@"谢谢惠顾" forKey:@"name"];
            [mdic setObject:@"0" forKey:@"juli"];
            [mdic setObject:[NSString stringWithFormat:@"%d",temp] forKey:@"probability"];
            [marr addObject: mdic];
            [self.marr addObjectsFromArray:marr];
            
            Luck *luck = [[Luck alloc] initWithFrame:RECTMACK(90, 247, 240, 240)];
            luck.imageArray =  [@[@" ",@" ",@" ",@" ",@" ",@" ",@" ",@" "]mutableCopy];
            
            // 概率数组
            luck.luckArr = [NSArray arrayWithArray:marr];
            luck.prizeTime = [[[sucess objectForKey:@"data"] objectForKey:@"prizeTime"] intValue];
            // 基础循环次数
            luck.circleNum = 3;
            luck.delegate = self;
            [self.view addSubview: luck];
        }else if ([[sucess objectForKey:@"code"] isEqualToString:@"001"]){
            [self setVIew];
            ALERT([sucess objectForKey:@"message"]);
        }else{
            [self setVIew];
        }
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)luckSelectBtn:(UIButton *)btn{
    //    NSLog(@"%ld",btn.tag);
}

- (void)luckViewDidStopWithArrayCount:(NSInteger)count{

    [self setGift:self.marr[count - 1]];
}

- (void)setGift:(NSDictionary *)dic{
    NSUserDefaults *use = [NSUserDefaults standardUserDefaults];

    NSDictionary *mdic = [NSMutableDictionary dictionary];
    [mdic setValue:[use objectForKey:@"id"] forKey:@"userId"];
    [mdic setValue:[dic objectForKey:@"id"] forKey:@"rollId"];
    [mdic setValue:self.str forKey:@"lotteryId"];
    
    
    NSString *time = [MyBase64 getCurrentTimestamp];
    NSString *str = [MyBase64 base64EncodingWithData:[MD5 md5: [NSString stringWithFormat:@"%@%@%@%@",[MD5 md5: time],[use objectForKey:@"id"],[dic objectForKey:@"id"],_str]]];
    [mdic setValue:time forKey:@"date"];
    [mdic setValue:str forKey:@"token"];
    [MJPush postWithURLString:STARTLOTTERYDRAW parameters:mdic success:^(id sucess) {
        if ([sucess[@"code"] isEqualToString:@"000"]) {
            self.value.text = dic[@"name"];
            _lable3.text = [NSString stringWithFormat:@"%@\n本次抽奖和苹果公司无关！", dic[@"rule"]];
        }else if ([sucess[@"code"] isEqualToString:@"001"]){
            ALERT(sucess[@"message"]);
        }else{
            ALERT(@"请重新抽取");
        }
        
        
    } failure:^(NSError *error) {
        
    }];
    
}

- (void)setVIew{
    UIView *view = [[UIView alloc] initWithFrame:RECTMACK(90, 247, 240, 240)];
    for (int i = 0; i < 9; i++) {
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake((i%3)* (view.frame.size.width - 10)/3 ,((i/3)* (view.frame.size.width - 10)/3), (view.frame.size.width-10 - 15)/3  , (view.frame.size.width-10 - 15)/3)  ];
        if (i == 4) {
            image.image = [UIImage imageNamed:@"home_luck_start.png"];
        }else{
            image.image = [UIImage imageNamed:@"home_luck_gift.png"];
        }
        [view addSubview: image];
    }
    
    [self.view addSubview: view];
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
