//
//  LaunchView.m
//  Longhaoli
//
//  Created by 亿缘 on 2017/7/7.
//  Copyright © 2017年 亿缘. All rights reserved.
//


#import "LaunchView.h"

@interface LaunchView () 
@property (weak, nonatomic) UIImageView *imageBackView;
@property (weak, nonatomic) UIButton *enterBtn;
@property (weak, nonatomic) UILabel *label;
@property (weak, nonatomic) UIView *labelBackView;
@end

@implementation LaunchView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
//        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(enterBtnClick)];
//        [self addGestureRecognizer:tapGes];
//        tapGes.delegate = self;
//        tapGes.cancelsTouchesInView = NO;
        [self initImageView];
        [self initLabelView];
        [self initEnterBtn];
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    _imageBackView.frame = self.frame;
    CGPoint viewCenter = self.center;
    CGSize labelSize = CGSizeMake(self.frame.size.width * 0.85, 120);
    _labelBackView.frame = CGRectMake(viewCenter.x - labelSize.width * 0.5, CGRectGetMidY(self.frame), labelSize.width, labelSize.height);
    _label.frame = CGRectMake(20, 0, labelSize.width - 40, labelSize.height);
    CGFloat viewCenterX = CGRectGetMidX(self.frame);
    _enterBtn.frame = CGRectMake(viewCenterX - 80, CGRectGetMaxY(self.frame) - 76, 160, 36);
}

-(void)initImageView {
    UIImageView *imageBackView = [[UIImageView alloc] init];
    [imageBackView setImage:[UIImage imageNamed:@"welcome_scre.png"]];
    imageBackView.userInteractionEnabled = YES;
    [self addSubview:imageBackView];
    _imageBackView = imageBackView;
}

-(void)initLabelView {
    UILabel *label = [[UILabel alloc] init];
    UIView *labelBackView = [[UIView alloc] init];
    label.textColor = [UIColor whiteColor];
    label.numberOfLines = 4;
    label.font = [UIFont systemFontOfSize:17];
//    label.textAlignment = NSTextAlignmentCenter;
    labelBackView.backgroundColor = COLOUR(23, 171, 253);
    labelBackView.layer.cornerRadius = 10;
    labelBackView.layer.masksToBounds = YES;
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    if ([[user objectForKey:@"login"] isEqualToString:@"1"]){
        NSString * nick = [user objectForKey:@"nickName"];
        if (nick.length > 0) {
            label.text = [NSString stringWithFormat:@"尊敬的会员,欢迎%@使用龙好礼系统,天天好礼抢不停",nick];
        }else{
            label.text = [NSString stringWithFormat:@"尊敬的会员,欢迎%@使用龙好礼系统,天天好礼抢不停",[user objectForKey:@"tel"]];
        }
    }else{
        label.text = @"欢迎使用龙好礼系统,天天好礼抢不停";
    }
    
   
    [labelBackView addSubview:label];
    [self addSubview:labelBackView];
    _label = label;
    _labelBackView = labelBackView;
}

-(void)initEnterBtn {
    UIButton  *enterBtn = [[UIButton alloc] init];
    enterBtn.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
    [enterBtn setTitle:@"进   入" forState:UIControlStateNormal];
    [enterBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    enterBtn.layer.cornerRadius = 18;
    enterBtn.layer.masksToBounds = YES;
    [enterBtn addTarget:self action:@selector(enterBtnClick) forControlEvents:UIControlEventTouchUpInside];
    enterBtn.enabled = YES;
    [self addSubview:enterBtn];
    _enterBtn = enterBtn;
//    [self bringSubviewToFront:self.enterBtn];
    
}

-(void)enterBtnClick {
//    NSLog(@"btn click");
    [self removeFromSuperview];
}

//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//    return YES;
//}



@end
