//
//  AutoPlay.h
//  Food
//
//  Created by yy on 2016/11/20.
//  Copyright © 2016年 fanfan. All rights reserved.
//

#import <UIKit/UIKit.h>
//自动滚动时间
#define PlayTime 4

//代理协议 可获取被点击的图片下标 从零开始
@protocol AutoPlayDelegate <NSObject>

@optional
//被点击的下标
-(void)imageClickWithIndex:(NSInteger)index;



@end



@interface AutoPlay : UIView<UIScrollViewDelegate>
@property (nonatomic,assign) id<AutoPlayDelegate> delegate;

//使用说明
//网络图片依赖SDWebIamge第三方图片缓存库 使用前请先在工程中引入SDWebIamge第三方库;


//frame位置和大小 Imagearray 存放字符串的数组 字符内容为网址    Auto是否需要自动播放 默认为no

- (instancetype)initWithFrame:(CGRect)frame ImageArray:(NSArray *)Imagearray AutoPaly:(BOOL)Auto placeholdrImageName:(NSString *)imageName;
//重设图片和占位符
- (void)setImageSWithUrlS:(NSArray *)Imagearray placeholdrImageName:(NSString *)imageName;
//停止滚动
- (void)stop;
//继续滚动
- (void)play;

@end
