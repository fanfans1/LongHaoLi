//
//  loginViewController.m
//  LongHaoLiShop
//
//  Created by 亿缘 on 2017/7/18.
//  Copyright © 2017年 亿缘. All rights reserved.
//

#import "LoginViewController.h"
#import "MainTabBarViewController.h"
#import "UUID.h"
#import <JPUSHService.h>
#import "MD5.h"

@interface LoginViewController (){
    
    
    int timeCount;
    NSTimer*timer;
    
}

@property (nonatomic, strong)UITextField *phone;
@property (nonatomic, strong)UITextField *resigNum;
@property (nonatomic, strong)UIButton *getResignNum; // 获取验证码按钮
@property(nonatomic,strong)UILabel *tipLabel;       // 倒数秒
@property (nonatomic,strong)NSString * temp;        // 验证码
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"龙好礼登录";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBarTintColor: BACKGROUNDCOLOR];
//    [self isLogin];
    [self setLoginView];
    // Do any additional setup after loading the view.
}

 

// 设置登录界面
- (void)setLoginView{
    
    self.phone = [[UITextField alloc] initWithFrame:RECTMACK(50, 100, 314, 50)];

    self.phone.keyboardType = UIKeyboardTypeNumberPad;
    self.phone.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.phone.leftView = [[UIView alloc] initWithFrame:RECTMACK(0, 0, 30, 50)];
    self.phone.placeholder = @"请输入手机号";
    
    self.phone.layer.masksToBounds = YES;
    self.phone.layer.borderWidth = 1;
    self.phone.layer.borderColor = COLOUR(222, 222, 222).CGColor;
   
    [self.view addSubview: self.phone];
//    UIView *line1 = [[UIView alloc] initWithFrame:RECTMACK(50, 150, 314, 1)];
//    line1.backgroundColor = COLOUR(191, 191, 191);
//    [self.view addSubview: line1];
    
    self.resigNum = [[UITextField alloc] initWithFrame:RECTMACK(50, 200, 200, 50)];
    
    self.resigNum.layer.masksToBounds = YES;
    
    self.resigNum.keyboardType = UIKeyboardTypeNumberPad;
    
    self.resigNum.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.resigNum.leftView = [[UIView alloc] initWithFrame:RECTMACK(0, 0, 30, 50)];
    self.resigNum.layer.masksToBounds = YES;
    self.resigNum.layer.borderWidth = 1;
    self.resigNum.layer.borderColor = COLOUR(222, 222, 222).CGColor;
    self.resigNum.placeholder = @"请输入验证码";
    
    [self.view addSubview: self.resigNum];
//    UIView *line2 = [[UIView alloc] initWithFrame:RECTMACK(50, 250, 314, 1)];
//    line2.backgroundColor = COLOUR(191, 191, 191);
//    [self.view addSubview: line2];
    
    UIButton *getResignNum = [UIButton buttonWithType:UIButtonTypeCustom];
    
    getResignNum.frame = RECTMACK(260, 200, 100, 50);
//    getResignNum.backgroundColor = [UIColor whiteColor];
    getResignNum.layer.masksToBounds = YES;
    getResignNum.layer.borderWidth = 1;
    getResignNum.layer.borderColor = COLOUR(222, 222, 222).CGColor;
    getResignNum.layer.cornerRadius = 8;
    getResignNum.backgroundColor = BACKGROUNDCOLOR;
    [getResignNum setTitle:@"发送验证码" forState:UIControlStateNormal];
    [getResignNum addTarget:self action:@selector(registYanZheng) forControlEvents:UIControlEventTouchUpInside];
    [getResignNum setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    getResignNum.titleLabel.font = [UIFont systemFontOfSize:14*SCREEN_WIDTH/414 weight:1];
    [self.view addSubview: getResignNum];
    self.getResignNum = getResignNum;
    
    //验证提交之后的跑秒提示防止用户的重复提交数据有效时间60秒
    timeCount = 180;
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = RECTMACK(50, 300, 314, 50);
    btn.backgroundColor = [UIColor whiteColor];
    
    [btn setTitle:@"立即登录" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.backgroundColor = BACKGROUNDCOLOR;
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 5;
    btn.titleLabel.font = [UIFont systemFontOfSize:18*SCREEN_WIDTH/414 weight:1.5];
    [btn addTarget:self action:@selector(loginAccountButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: btn];
    
    
}

//登录方法
-(void)loginAccountButton
{
    
    if ([_phone.text isEqualToString:@""]||_phone.text == nil||[_resigNum.text isEqualToString:@""]||_resigNum.text == nil) {
        ALERT(@"用户名或验证码不能为空");
        return;
    }else if (![_resigNum.text isEqualToString:_temp]){
        ALERT(@"验证码有误")
        return;
    }else{
//        // 登录
          [self loginAccountInter];
    }
    
    
}



-(void)loginAccountInter
{
    [self.view endEditing:YES];
    
    NSString *time = [MyBase64 getCurrentTimestamp];
    NSString *str = [NSString stringWithFormat:@"%@%@",[MD5 md5:time],_phone.text];
    
    
    NSString *uuid = [[UUID getUUID] stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSString *json = [NSString stringWithFormat:@"{\"tel\":\"%@\",\"latitudeY\":\"%f\",\"latitudeX\":\"%f\",\"uuid\":\"%@\",\"date\":\"%@\",\"token\":\"%@\"}",_phone.text ,APPDELEGATE.longitude,APPDELEGATE.latitude,uuid,time,[MyBase64 base64EncodingWithData:[MD5 md5:str]]];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:json,@"param", nil];
    [MJPush postWithURLString:LOGIN parameters:dic success:^(id sucess) {
        if ([[sucess objectForKey:@"code"] isEqualToString:@"000"]) {
            NSDictionary *dic = [NSDictionary dictionaryWithDictionary:[sucess objectForKey:@"data"]];
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            [user setObject:self.phone.text forKey:@"tel"];
            [user setObject:[dic objectForKey:@"id"] forKey:@"id"];
            [user setObject:[dic objectForKey:@"nickName"] forKey:@"nickName"];
            [user setObject:[dic objectForKey:@"headPhoto"] forKey:@"headPhoto"];
            [user setObject:[dic objectForKey:@"loginAddress"] forKey:@"city"];
//            NSString *uuid = [[UUID getUUID] stringByReplacingOccurrencesOfString:@"-" withString:@""];
            
            [user setObject:uuid forKey:@"uuid"];
           /* [JPUSHService setTags:nil alias:[NSString stringWithFormat:@"%@",uuid]fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias){
                //            NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, iTags, iAlias);
            }];
            */
            [JPUSHService setAlias:[NSString stringWithFormat:@"%@",uuid] completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
                
            } seq: 0];
            [user setObject:@"1" forKey:@"login"];// 用户登录成功标志
            postNotification(@"whiteUserAlert");
            APPDELEGATE.window.rootViewController = [[MainTabBarViewController alloc] init];
        }else if ([[sucess objectForKey:@"code"] isEqualToString:@"001"]){
            ALERT([sucess objectForKey:@"message"]);
        }
    } failure:^(NSError *error) {
        
    }];
    
    
}




#pragma mark-->读秒开始
-(void)readSecond{
    _getResignNum.userInteractionEnabled= NO;

    timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(dealTimer) userInfo:nil repeats:YES];
    timer.fireDate=[NSDate distantPast];
}

#pragma mark-->跑秒操作
-(void)dealTimer{
    [self.getResignNum setTitle:[[NSString alloc]initWithFormat:@"%ds",timeCount] forState:UIControlStateNormal];
    timeCount=timeCount - 1;
    if(timeCount== 0){
        timer.fireDate=[NSDate distantFuture];
        timeCount= 180;
        _getResignNum.userInteractionEnabled=YES;
         [self.getResignNum setTitle:[[NSString alloc]initWithFormat:@"获取验证码"] forState:UIControlStateNormal];
    }
    
}

//验证码
-(void)registYanZheng
{
    if ([_phone.text isEqualToString:@""]||_phone.text == nil || _phone.text.length != 11) {
        ALERT(@"手机号有误！");
        
    }else{
        [self readSecond];
        int x = 100000 + (arc4random()%100001);
        _temp = [NSString stringWithFormat:@"%d",x];
        self.resigNum.text = _temp;
 
//        NSString *httpUrl = @"https://api.smsbao.com/sms";
//        NSString *httpArg =  [NSString stringWithFormat:@"u=546174057&p=%@&m=%@&c=%@",[MD5 md5:@"daming.123"],_phone.text,[NSString stringWithFormat:@"【龙好礼】尊敬的%@您好！您的验证码为%d打死也不要告诉别人",_phone.text,x]];
//        
//        httpArg = [httpArg stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//        [self request:httpUrl withHttpArg: httpArg];
        
    }
}

-(void)request: (NSString*)httpUrl withHttpArg: (NSString*)HttpArg  {
    
    NSString *urlStr = [[NSString alloc]initWithFormat: @"%@?%@", httpUrl, HttpArg];
    NSURL *url = [NSURL URLWithString: urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 10];
    [request setHTTPMethod: @"GET"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            ALERT(@"发送失败");
            
        }
        
    }];
    [task resume];
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
