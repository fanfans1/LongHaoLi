//
//  MineComplainViewController.m
//  LongHaoLi
//
//  Created by Guang shen on 2017/8/9.
//  Copyright © 2017年 fanfan. All rights reserved.
//

#import "MineComplainViewController.h"

@interface MineComplainViewController ()<HSLimitTextDelegate>

@property (nonatomic,retain)HSLimitText *textView;
@end

@implementation MineComplainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
 
    self.title = @"投诉";
    HSLimitText *textView = [[HSLimitText alloc] initWithFrame:RECTMACK(50,120, 314, 200) type:TextInputTypeTextView];
    
    //    textView.backgroundColor = [UIColor whiteColor];
    textView.layer.borderWidth = 1;
    textView.layer.cornerRadius = 6;
    textView.layer.borderColor = COLOUR(222, 222, 222).CGColor;
    textView.layer.masksToBounds = YES;
    textView.placeholder = @"请输入您对我们的建议或意见";
    textView.delegate = self;
    textView.maxLength = 200;
    self.textView = textView;
    [self.view addSubview:textView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = RECTMACK(50, 370, 314, 50);
    [btn setTitle:@"提交" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.backgroundColor = BACKGROUNDCOLOR;
    [btn addTarget:self action:@selector(updateCom) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: btn];
    
}

- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
}

- (void)updateCom{
    if (self.textView.text.length == 0) {
        ALERT(@"请输入内容");
        return;
    }
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[user objectForKey:@"id"],@"userId",self.textView.text,@"content", nil];
    [MJPush postWithURLString:COMPLAINT parameters:dic success:^(id sucess) {
        [self.navigationController popViewControllerAnimated:YES];
        ALERT([sucess objectForKey:@"message"]);
//        self.textView.text = @"";
    } failure:^(NSError *error) {
        
    }];
    
}

- (void)limitTextLimitInputOverStop:(HSLimitText *)textLimitInput
{
    ALERT(@"字数超出限制");
}






- (void)limitTextLimitInput:(HSLimitText *)textLimitInput text:(NSString *)text
{
    
    self.textView.text = text;
    
    
}


- (BOOL)limitTextShouldBeginEditing:(HSLimitText *)textLimitInput{
    
    
    
    return YES;
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
