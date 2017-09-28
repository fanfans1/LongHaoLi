//
//  HomeFriendCalendarAddViewController.m
//  LongHaoLi
//
//  Created by Guang shen on 2017/8/24.
//  Copyright © 2017年 fanfan. All rights reserved.
//

#import "HomeFriendCalendarAddViewController.h"
#import "UICustomDatePicker.h"
#import "CalendarModel.h"

@interface HomeFriendCalendarAddViewController ()<HSLimitTextDelegate>

@property (nonatomic, retain)UILabel *time;
@property (nonatomic, retain)HSLimitText *textView;


@property (nonatomic, retain)NSString* remindertime;
@property (nonatomic, assign)BOOL isChange; // 用来判断是否修改
@property (nonatomic, retain)CalendarModel *model;
@end

@implementation HomeFriendCalendarAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _isChange = NO;
    self.title = @"添加便签";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setView];
    // Do any additional setup after loading the view.
}

- (void)setView{
    
    UIImageView *image = [[UIImageView alloc] initWithFrame:RECTMACK(20, 100, 374, 50)];
    image.image = [UIImage imageNamed:@"Home_beijing.png"];
    [self.view addSubview: image];
    image.userInteractionEnabled = YES;
    
    UILabel *tit = [[UILabel alloc] init];
    tit.frame = RECTMACK(50, 10, 80, 30);
    tit.text = @"添加时间:";
    tit.font = FONT(16);
    [image addSubview: tit];
    
    self.time = [[UILabel alloc] initWithFrame:RECTMACK( 150, 10, 200, 30)];
    self.time.layer.masksToBounds = YES;
    self.time.layer.borderWidth = 1;
    self.time.layer.borderColor = COLOUR(249, 249, 249).CGColor;
    self.time.layer.cornerRadius = 5;
    self.time.text =  [self getData];
    self.remindertime = [self getData:0];
    self.time.textAlignment = NSTextAlignmentCenter;
    self.time.font = FONT(16);
    [image addSubview: self.time];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(timeSelect)];
    [self.time addGestureRecognizer: tap];
    self.time.userInteractionEnabled = YES;
    
    [self setFootVIew];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeSystem];
    button1.frame = RECTMACK(50, 480, 120, 40);
    button1.layer.masksToBounds = YES;
    button1.layer.cornerRadius = 5;
    button1.backgroundColor = BACKGROUNDCOLOR;
    [button1 setTitle:@"取消" forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(btn1Action) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: button1];

    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeSystem];
    button2.frame = RECTMACK(244, 480, 120, 40);
    button2.layer.masksToBounds = YES;
    button2.layer.cornerRadius = 5;
    button2.backgroundColor = BACKGROUNDCOLOR;
    [button2 setTitle:@"确定" forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(btn2Action) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: button2];

    
}
- (void)btn1Action{
    self.textView.text = @"";
}

- (void)btn2Action{
    if (self.textView.text.length == 0) {
        ALERT(@"请输入内容");
        return;
    }
    
    if (_isChange) {
        // 更改提醒
        [self changeAction];
        return;
    }
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[user objectForKey:@"id"],@"userId",self.textView.text,@"title",self.remindertime,@"remindertime", nil];
    [MJPush postWithURLString:CALENDAR parameters:dic success:^(id sucess) {
        ALERT([sucess objectForKey:@"message"]);
        self.textView.text = @"";
    } failure:^(NSError *error) {
        
    }];

}

- (void)changeAction{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[user objectForKey:@"id"],@"userId",self.textView.text,@"title",self.model.calendarid,@"id", nil];
    [MJPush postWithURLString:UPDATECALENDAR parameters:dic success:^(id sucess) {
        ALERT([sucess objectForKey:@"message"]);
        self.textView.text = @"";
    } failure:^(NSError *error) {
        
    }];

}

- (void)setFootVIew{
    UIImageView *image = [[UIImageView alloc] initWithFrame:RECTMACK(20, 180, 374, 280)];
    image.image = [UIImage imageNamed:@"Home_beijing.png"];
    [self.view addSubview: image];
    image.userInteractionEnabled = YES;
    
    HSLimitText *textView = [[HSLimitText alloc] initWithFrame:RECTMACK(30,30, 314, 220) type:TextInputTypeTextView];
 
    textView.placeholder = @"请输入提示，最多输入200字";
    textView.delegate = self;
    textView.maxLength = 200;
    self.textView = textView;
    [image addSubview:textView];
}


- (void)limitTextLimitInputOverStop:(HSLimitText *)textLimitInput
{
    ALERT(@"字数超出限制");
}






- (void)limitTextLimitInput:(HSLimitText *)textLimitInput text:(NSString *)text
{
    
    
    
    
}


- (BOOL)limitTextShouldBeginEditing:(HSLimitText *)textLimitInput{
    
    
    
    return YES;
}


- (void)timeSelect{
    
    __weak HomeFriendCalendarAddViewController *weak = self;
    [UICustomDatePicker showCustomDatePickerAtView:self.view choosedDateBlock:^(NSDate *date) {
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];//创建一个日期格式化器
        
        dateFormatter.dateFormat=@"yyyy-MM-dd";//指定转date得日期格式化形式

        self.remindertime =  [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]*1000];
        
        self.time.text = [dateFormatter stringFromDate:date];
        
        
        
        if (self.arr.count > 0) {
            for (CalendarModel *model in self.arr) {
                
                if ([[weak  timestampSwitchTime:  model.time] isEqualToString:  self.time.text ]) {
                    self.textView.text = model.title;
                    self.model = model;
                    _isChange = YES;
                    break;
                }else{
                    self.textView.text = @"";
                    _isChange = NO;
                }
//                NSLog(@"%@  %@",[weak  timestampSwitchTime:  model.time],self.time.text);
            }
        }
        
        
        
    } cancelBlock:^{
        
    }];
}

- (NSString *)timestampSwitchTime:(NSInteger)timestamp{
    
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"yyyy-MM-dd"]; // （@"YYYY-MM-dd hh:mm:ss"）----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    
    [formatter setTimeZone:timeZone];
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timestamp/1000];
    
    
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    
    
    
    //NSLog(@"&&&&&&&confromTimespStr = : %@",confromTimespStr);
    
    
    
    return confromTimespStr;
    
}

//
- (NSString *)getData{
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    // 获取当前日期
    NSDate* dt = [NSDate date];
    // 定义一个时间字段的旗标，指定将会获取指定年、月、日、时、分、秒的信息
    unsigned unitFlags = NSCalendarUnitYear |
    NSCalendarUnitMonth |  NSCalendarUnitDay |
    NSCalendarUnitHour |  NSCalendarUnitMinute |
    NSCalendarUnitSecond | NSCalendarUnitWeekday;
    // 获取不同时间字段的信息
    NSDateComponents* comp = [gregorian components: unitFlags
                                          fromDate:dt];
    return [NSString stringWithFormat:@"%ld-%ld-%ld",comp.year,comp.month,comp.day];
}

- (NSString *)getData:(int)hours{
    NSCalendar *greCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    [greCalendar setTimeZone: timeZone];
    
    NSDateComponents *dateComponents = [greCalendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay  fromDate:[NSDate date]];
    
    //  定义一个NSDateComponents对象，设置一个时间点
    NSDateComponents *dateComponentsForDate = [[NSDateComponents alloc] init];
    [dateComponentsForDate setDay:dateComponents.day];
    [dateComponentsForDate setMonth:dateComponents.month];
    [dateComponentsForDate setYear:dateComponents.year];
    [dateComponentsForDate setHour:00];
    [dateComponentsForDate setMinute:00];
    [dateComponentsForDate setSecond:00];
    
    NSDate *dateFromDateComponentsForDate = [greCalendar dateFromComponents:dateComponentsForDate];
    //    NSTimeInterval  interval =8*60*60; //1:天数
    //    NSDate *date1 = [dateFromDateComponentsForDate initWithTimeIntervalSinceNow:interval];
                                  
    NSString *str = [NSString stringWithFormat:@"%ld", (long)[dateFromDateComponentsForDate timeIntervalSince1970]*1000];
    return str;
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
