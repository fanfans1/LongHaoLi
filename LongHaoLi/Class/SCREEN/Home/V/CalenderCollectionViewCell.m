//
//  CalenderCollectionViewCell.m
//  HB
//
//  Created by 王小康 on 16/1/18.
//  Copyright © 2016年 范强伟. All rights reserved.
//

#import "CalenderCollectionViewCell.h"

@implementation CalenderCollectionViewCell

- (UILabel *)lable{
    if (!_lable) {
        _lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.viewForFirstBaselineLayout.bounds.size.width , self.viewForFirstBaselineLayout.bounds.size.height )];
        _lable.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview: _lable];
    }
    return _lable;
}

- (UIImageView *)image{
    if (!_image) {
        _image = [[UIImageView alloc ] initWithFrame:CGRectMake(0, 0, 20, 20)];
        _image.layer.cornerRadius = 10;
        _image.layer.masksToBounds = YES;
        [self.contentView addSubview: _image];
    }
    return _image;
}




@end
