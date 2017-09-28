//
//  MineChangeNameViewController.m
//  LongHaoLi
//
//  Created by Guang shen on 2017/8/10.
//  Copyright © 2017年 fanfan. All rights reserved.
//

#import "MineChangeNameViewController.h"

@interface MineChangeNameViewController ()

@property (nonatomic, retain)UITextField *textFile;

@end

@implementation MineChangeNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNameTextFile];
    // Do any additional setup after loading the view.
}
- (void)setNameTextFile{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(50, 15, SCREEN_WIDTH - 100, 30)];
    lable.text = @"请输入新的用户名";
    [view addSubview: lable];
    [self.view addSubview: view];
    UITextField *name = [[UITextField alloc] initWithFrame:CGRectMake( 50, 50, SCREEN_WIDTH - 100, 40)];
    name.layer.borderWidth = 0.5;
    name.layer.borderColor = COLOUR(77, 148, 201).CGColor;
    name.placeholder = @"请输入新的用户名";
    [view addSubview: name];
    name.layer.masksToBounds = YES;
    name.layer.cornerRadius = 2;
    self.textFile = name;
    UILabel *te = [[UILabel alloc] initWithFrame:CGRectMake(50 , 110, SCREEN_WIDTH - 100, 50)];
    te.text = @"以中文或英文开头,限4~16个字符，一个汉字为2个字符";
//    te.font = FONT(13);
    te.numberOfLines = 0;
    [view addSubview: te];
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    //    btn.frame = RECTMACK(38, 450, 414 - 76, 50);
    btn.frame = CGRectMake(50, 170, SCREEN_WIDTH - 100, 50);
    [btn setTitle:@"确认" forState:UIControlStateNormal];
    btn.backgroundColor = BACKGROUNDCOLOR;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 4;
    [view addSubview: btn];
    [btn addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
}

- (void)submit{
    if (self.textFile.text.length > 8) {
       ALERT(@"超出字数限制");
    }else{
        [self changename];
    }
}

- (void)changename{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[user objectForKey:@"id"],@"id",self.textFile.text,@"nickName", nil];
    
    
    [MJPush postWithURLString:NICKNAME parameters:dic success:^(id success) {
        
        if ([[success objectForKey:@"code"] isEqualToString:@"000"]) {
            
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            [user setObject:self.textFile.text forKey:@"nickName"];
            [self.navigationController popViewControllerAnimated:YES];
            ALERT(@"修改成功");
        }else{
            ALERT([success objectForKey:@"message"]);
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
