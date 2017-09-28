//
//  HomeFriendCalendarViewController.m
//  LongHaoLi
//
//  Created by Guang shen on 2017/8/24.
//  Copyright © 2017年 fanfan. All rights reserved.
//

#import "HomeFriendCalendarViewController.h"

#import "GFCalendar.h"
#import "HomeFriendCalendarAddViewController.h"
#import "CalendarModel.h"


@interface HomeFriendCalendarViewController ()

@property (nonatomic, retain)NSMutableArray *mArr;

@end

@implementation HomeFriendCalendarViewController{
    UILabel *notic;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [self getData];
    self.view.backgroundColor = [UIColor whiteColor];
    
     self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(add)];
    self.mArr = [NSMutableArray array];
     [self setupCalendar];
    [self getMassage];
    // Do any additional setup after loading the view.
}

- (void)add{
    HomeFriendCalendarAddViewController *add = [[HomeFriendCalendarAddViewController alloc] init];
    if (self.mArr.count > 0) {
        add.arr = [NSArray arrayWithArray:self.mArr];
    }
    [self.navigationController pushViewController:add animated:YES];
}

- (void)setupCalendar {
    
    CGFloat width = self.view.bounds.size.width;
    CGPoint origin = CGPointMake(0, 64);
    
    GFCalendarView *calendar = [[GFCalendarView alloc] initWithFrameOrigin:origin width:width];
    calendar.calendarBasicColor = BACKGROUNDCOLOR; // 更改颜色
    
    // 点击某一天的回调
    calendar.didSelectDayHandler = ^(NSInteger year, NSInteger month, NSInteger day) {
      NSString *str =   [self getDatas:year month:month day:day];
        __weak HomeFriendCalendarViewController *view = self;
        for (CalendarModel *model in self.mArr) {
            if ([str isEqualToString: [NSString stringWithFormat:@"%ld",model.time]]) {
                notic.text = [NSString stringWithFormat:@"添加时间：%@\n\n添加内容：%@",[view getDate:model.time],model.title];
                return ;
            }else{
                notic.text = @"";
            }
            
        }
//        PushedViewController *pvc = [[PushedViewController alloc] init];
//        pvc.title = [NSString stringWithFormat:@"%ld年%ld月%ld日", year, month, day];
//        [self.navigationController pushViewController:pvc animated:YES];

    };
    // 设置标题
    calendar.changeDayHandler = ^(NSString* day){
        self.title = [NSString stringWithFormat:@"%@",day];
    };
    
    [self.view addSubview:calendar];
    [self setTitleView];
    
}

- (void)setTitleView{
    UIImageView *image = [[UIImageView alloc] init];
    image.frame = CGRectMake(20, SCREEN_WIDTH + 74, SCREEN_WIDTH - 40, SCREEN_HEIGHT - SCREEN_WIDTH - 74);
    image.image = [UIImage imageNamed:@"Home_beijing.png"];
    [self.view addSubview: image];
    notic = [[UILabel alloc] init];
    notic.frame = CGRectMake(20, 20, SCREEN_WIDTH - 80, SCREEN_HEIGHT - SCREEN_WIDTH - 114);
  
//    notic.backgroundColor = [UIColor grayColor];
    notic.numberOfLines = 0;
    [image addSubview: notic];
    
    
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)getMassage{
    NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [mdic setValue:[user objectForKey:@"id"] forKey:@"userId"];
    [MJPush postWithURLString:SELECTCALENDAR parameters:mdic success:^(id sucess) {
        if ([[sucess objectForKey:@"code"] isEqualToString:@"000"]) {
            NSArray *arr = [NSArray arrayWithArray:[sucess objectForKey:@"data"]];
            for (NSDictionary *dic in arr) {
                CalendarModel *model = [CalendarModel setModelWithDictionary:dic];
                [self.mArr addObject: model];
//                NSLog(@"%@",model.reminderTime);
            }
            
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:self.mArr,@"arr", nil];
            NSNotification *notify = [[NSNotification alloc] initWithName:@"HomeFriendCalendarReminderTime" object:nil userInfo:dic];
            [[NSNotificationCenter defaultCenter] postNotification:notify];
           
        }else if ([[sucess objectForKey:@"code"] isEqualToString:@"001"]){
            ALERT([sucess objectForKey:@"message"]);
        }
       
    } failure:^(NSError *error) {
        
    }];
    
    
    
}



// 获取当天12点时间戳
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
    // 获取各时间字段的数值
    
    
    
    //    NSTimeInterval  interval =8*60*60; //1:天数
    //    NSDate *date1 = [dateFromDateComponentsForDate initWithTimeIntervalSinceNow:interval];
    return [NSString stringWithFormat:@"%ld年%ld月",comp.year,comp.month];
}


// 获取日期data
- (NSString *)getDatas:(NSInteger)year month:(NSInteger)month day:(NSInteger)day{
    NSCalendar *greCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    [greCalendar setTimeZone: timeZone];

    NSDateComponents *dateComponentsForDate = [[NSDateComponents alloc] init];
    [dateComponentsForDate setDay:day];
    [dateComponentsForDate setMonth:month];
    [dateComponentsForDate setYear:year];
    [dateComponentsForDate setHour:00];
    [dateComponentsForDate setMinute:00];
    [dateComponentsForDate setSecond:00];
    
    NSDate *dateFromDateComponentsForDate = [greCalendar dateFromComponents:dateComponentsForDate];
    //    NSTimeInterval  interval =8*60*60; //1:天数
    //    NSDate *date1 = [dateFromDateComponentsForDate initWithTimeIntervalSinceNow:interval];
    
    NSString *str = [NSString stringWithFormat:@"%ld", (long)[dateFromDateComponentsForDate timeIntervalSince1970]*1000];
    return str;
}

- (NSString *)getDate:(NSInteger )str{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterFullStyle];// 修改下面提到的北京时间的日期格式
    [formatter setTimeStyle:NSDateFormatterFullStyle];// 修改下面提到的北京时间的时间格式
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSDate *date1 = [NSDate dateWithTimeIntervalSince1970:str/1000];
    NSString *dat = [formatter stringFromDate:date1];
    return dat;
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
