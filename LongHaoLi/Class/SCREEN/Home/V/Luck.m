//
//  Luck.m
//  抽奖
//  fan

//  Created by 亿缘 on 2017/7/15.
//  Copyright © 2017年 亿缘. All rights reserved.
//

#import "Luck.h"
#import "UIImageView+WebCache.h"


@interface Luck () {
    
    NSTimer *startTimer;
    
    int currentTime;
    int stopTime;
    UIButton *btn0;
    UIButton *btn1;
    UIButton *btn2;
    UIButton *btn3;
    UIButton *btn4;
    UIButton *btn5;
    UIButton *btn6;
    UIButton *btn7;
}



@property (strong, nonatomic) NSMutableArray * btnArray;
@property (strong, nonatomic) UIButton * startBtn;
@property (assign, nonatomic) CGFloat time;
@property (assign,nonatomic)UIButton *temp; // 循环的上个按钮
@property (assign, nonatomic) int stopCount;

@end
@implementation Luck



- (NSMutableArray *)btnArray {
    if (!_btnArray) {
        _btnArray = [NSMutableArray array];
    }
    return _btnArray;
}




- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.time = 0.1;
    }
    return self;
}



- (void)setImageArray:(NSMutableArray *)imageArray {
    _imageArray = imageArray;
    float width = self.frame.size.width;
    // 后面背景按钮
    for (int i = 0; i < imageArray.count + 1; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake((i%3)* (width - 10)/3 ,((i/3)* (width - 10)/3), (width-10)/3, (width-10)/3);
        btn.backgroundColor = [UIColor clearColor];
        btn.layer.cornerRadius = 5;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        btn.tag = i;
        
        // 优惠券图片
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(5,5, (width - 10)/3 - 10 , (width - 10)/3 - 10)];
        //        [image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE,[_imageArray objectAtIndex:i > 4? i -1: i]] ]placeholderImage:[UIImage imageNamed:@"hhh.png"] options:SDWebImageAllowInvalidSSLCertificates];
        
        image.image = [UIImage imageNamed:@"home_luck_gift.png"];
        if (i == 4) {
            //            [btn setTitle:@"开始" forState:UIControlStateNormal];
            //            [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"home_luck_start.png"] forState:UIControlStateNormal];
            //            btn.layer.cornerRadius = 10;
            //            [btn setImage:[UIImage imageNamed:@"sub"] forState:UIControlStateNormal];
            btn.tag = 10;
            self.startBtn = btn;
            continue;
            
        }
        if (i != 4) {
            [btn addSubview: image];
        }
        
        btn.backgroundColor = [UIColor clearColor];
        switch (i) {
            case 0:
                btn0 = btn;
                break;
            case 1:
                btn1 = btn;
                break;
            case 2:
                btn2 = btn;
                break;
            case 3:
                btn3 = btn;
                break;
            case 5:
                btn4 = btn;
                break;
            case 6:
                btn5 = btn;
                break;
            case 7:
                btn6= btn;
                break;
            case 8:
                btn7 = btn;
                break;
                
            default:
                
                break;
        }
        
        [self.btnArray addObject:btn];
    }
    // 交换按钮位置
    [self TradePlacesWithBtn1:btn3 btn2:btn4];
    [self TradePlacesWithBtn1:btn4 btn2:btn7];
    [self TradePlacesWithBtn1:btn5 btn2:btn6];
    
    
}

- (void)TradePlacesWithBtn1:(UIButton *)firstBtn btn2:(UIButton *)secondBtn {
    CGRect frame = firstBtn.frame;
    firstBtn.frame = secondBtn.frame;
    secondBtn.frame = frame;
}

- (void)btnClick:(UIButton *)btn {
    
    if (self.prizeTime > 0) {
        if (btn.tag == 10) {
            //点击开始抽奖
            // 设置随机数
            _stopCount = 0;
            currentTime = 0;
            int temp = arc4random()%100;
            float max = 0;
            float min = 0;
            for (int i = 0; i < self.luckArr.count ; i++) {
                NSDictionary *dic = self.luckArr[i];
                int luck = [[dic objectForKey:@"probability"] floatValue];
                if (i == 0) {
                    min = 0;
                }else{
                    min = min + [[self.luckArr[i - 1] objectForKey:@"probability"] floatValue];
                }
                max = max + luck;
                
                if (min < temp && temp <= max) {
                    _stopCount = i+1;
                    [self start];
                    return;
                }
            }
        }
        self.prizeTime--;
    }else{
        ALERT(@"抽奖次数不足！");
    }
}

- (void)start{
    self.time = 0.1;
    stopTime = 7+8*self.circleNum + self.stopCount;
    [self.startBtn setEnabled:NO];
    startTimer = [NSTimer scheduledTimerWithTimeInterval:self.time target:self selector:@selector(start:) userInfo:nil repeats:YES];
}



- (void)setCircleNum:(int)circleNum{
    _circleNum = circleNum;
}

- (void)start:(NSTimer *)timer {
    if (self.temp ) {
        self.temp.backgroundColor = [UIColor clearColor];
    }
    UIButton *oldBtn = [self.btnArray objectAtIndex:currentTime % self.btnArray.count];
    oldBtn.backgroundColor = [UIColor yellowColor];
    self.temp = oldBtn;
    currentTime++;
    // 停止循环
    if (currentTime > stopTime) {
        [timer invalidate];
        [self.startBtn setEnabled:YES];
        [self stopWithCount:currentTime%self.btnArray.count];
        return;
    }
    
    // 一直循环
    if (currentTime > stopTime - 6) {
        self.time += 0.1;
        [timer invalidate];
        startTimer = [NSTimer scheduledTimerWithTimeInterval:self.time target:self selector:@selector(start:) userInfo:nil repeats:YES];
    }
}



- (void)stopWithCount:(NSInteger)count {
    //    NSLog(@"%ld",count);
    if (count == 0) {
        count = self.luckArr.count;
    }
    if ([self.delegate respondsToSelector:@selector(luckViewDidStopWithArrayCount:)]) {
        [self.delegate luckViewDidStopWithArrayCount:count];
    }
}




/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
