//
//  ConTableViewCell.m
//  Foods
//
//  Created by yy on 2016/11/29.
//  Copyright © 2016年 fanfan. All rights reserved.
//

#import "ConTableViewCell.h"


#import "SMKCycleScrollView.h"

@interface ConTableViewCell ()
{
    SMKCycleScrollView *cycleScrollView;
}
@end


@implementation ConTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
     
        UIImageView *image = [[UIImageView alloc] initWithFrame:RECTMACK(15, 14, 74, 18)];
        float temp = 46;
        
        image.image = [UIImage imageNamed:@"home_head_message.png"];
        [self addSubview: image];
        UILabel *name = [[UILabel alloc] initWithFrame:RECTMACK(96, 5, 1, 36)];
        name.backgroundColor = COLOUR(240, 240, 240);
        [self addSubview: name];
        cycleScrollView = [[SMKCycleScrollView alloc]initWithFrame:RECTMACK(103, 0, 300, temp)];
        cycleScrollView.titleColor = COLOUR(155, 155, 155);
       
     
        [self addSubview: cycleScrollView];
        
        
    }
    return self;
}

#pragma mark ScyleScrollViewDelegate
- (void)noticeViewSelectNoticeActionAtIndex:(NSInteger)index{
//    NSLog(@"%@",self.dataArr[index]);
}

- (void)setArr:(NSArray *)arr{
    if (arr.count >0) {
        cycleScrollView.titleArray = [NSArray arrayWithArray:arr];
        __weak ConTableViewCell *weakSelf = self;
        [cycleScrollView setSelectedBlock:^(NSInteger index, NSString *title) {
          
            [weakSelf.delegate passMassage:arr[index]];
        }];
    }
}



- (void)changeStringColor:(NSString *)allString lable:(UILabel *)hintLabel changeString:(NSString *)str forColor:(UIColor *)color andFont:(UIFont *)font{
    NSMutableAttributedString *hintString=[[NSMutableAttributedString alloc]initWithString:allString];
    NSRange range1=[[hintString string]rangeOfString:str];
    [hintString addAttribute:NSForegroundColorAttributeName value:color range:range1];
    [hintString addAttribute:NSFontAttributeName value:font range:range1];
    hintLabel.attributedText=hintString;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
