//
//  AutoPlay.m
//  Food
//
//  Created by yy on 2016/11/20.
//  Copyright © 2016年 fanfan. All rights reserved.
//
#import "AutoPlay.h"
#import "UIImageView+WebCache.h"

@interface AutoPlay ()

//这些属性是外界不需要的
@property (nonatomic,assign) NSUInteger    ImageCount;
@property (nonatomic,strong) UIScrollView  *Scrollview;
@property (nonatomic,strong) UIPageControl *Page;
@property (nonatomic,assign) NSUInteger    mark;
@property (nonatomic,strong) NSTimer       *timer;
@property (nonatomic,assign) BOOL          AUTO;


@end
@implementation AutoPlay



- (instancetype)initWithFrame:(CGRect)frame ImageArray:(NSArray *)Imagearray AutoPaly:(BOOL)Auto placeholdrImageName:(NSString *)imageName
{
    self = [super initWithFrame:frame];
    if (self) {
        _ImageCount = Imagearray.count;
        _mark = 0;
        _AUTO = Auto;
        _Scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _Scrollview.contentSize = CGSizeMake(frame.size.width*(Imagearray.count+2), frame.size.height);
        _Scrollview.showsHorizontalScrollIndicator = NO;
        for (int i = 0; i < Imagearray.count+2; i++) {
            if (i<Imagearray.count){
                NSString *str = [Imagearray[i] objectForKey:@"photo"];
                str = [MyBase64 stringConpanSteing:str ];
           
               NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE,str]];
               UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((i+1)*frame.size.width, 0, frame.size.width, frame.size.height)];
 
                [imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"loadingimg.png"] options:SDWebImageAllowInvalidSSLCertificates completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
 
                }];
 
               [_Scrollview addSubview:imageView];
               self.Scrollview.pagingEnabled = YES;
               imageView.userInteractionEnabled = YES;
                imageView.tag = i+1;
               UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClick:)];
               [imageView addGestureRecognizer:tap];
                
            }
            if (i==0) {
                NSString *str = [Imagearray[Imagearray.count-1] objectForKey:@"photo"];
                str = [MyBase64 stringConpanSteing:str ];
         
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE,str]];
               
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*frame.size.width, 0, frame.size.width, frame.size.height)];
                [imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:imageName] options:SDWebImageAllowInvalidSSLCertificates    ];
                [_Scrollview addSubview:imageView];
                self.Scrollview.pagingEnabled = YES;
            }
            if (i==Imagearray.count+1) {
                
                NSString *str = [Imagearray[0] objectForKey:@"photo"];
                str = [MyBase64 stringConpanSteing:str ];
           
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE,str]];
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*frame.size.width, 0, frame.size.width, frame.size.height)];
                [imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:imageName]options:SDWebImageAllowInvalidSSLCertificates    ];
                [_Scrollview addSubview:imageView];
                self.Scrollview.pagingEnabled = YES;
            }
        }
        _Scrollview.delegate = self;
        _Scrollview.contentOffset = CGPointMake(frame.size.width, 0);
        [self addSubview:_Scrollview];
        
        _Page = [[UIPageControl alloc] initWithFrame:CGRectMake(0,frame.size.height-30, frame.size.width, 30)];
        _Page.numberOfPages = Imagearray.count;
        _Page.currentPage = 0;
        _Page.currentPageIndicatorTintColor = [UIColor orangeColor];
        _Page.pageIndicatorTintColor = [UIColor whiteColor];
        [_Page addTarget:self action:@selector(PageClick:) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:_Page];
        [self play];
    }
    return self;
}


#pragma mark - 结束减速
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (_Scrollview.contentOffset.x==(_ImageCount+1)*self.frame.size.width) {
        [_Scrollview setContentOffset:CGPointMake(self.frame.size.width, 0)];
    }else if (_Scrollview.contentOffset.x==0) {
        [_Scrollview setContentOffset:CGPointMake(_ImageCount*self.frame.size.width, 0)];
    }else{
        _mark = scrollView.contentOffset.x / scrollView.frame.size.width;
//        NSLog(@"%ld",_mark);
    }
    [_Page setCurrentPage:_Scrollview.contentOffset.x/(self.frame.size.width)-1];
    

    
    
}
#pragma mark - 定时器方法
- (void)TimeAutoPlay{
    _mark++;
    [UIView animateWithDuration:0.5 animations:^{
    _Scrollview .contentOffset = CGPointMake(_mark*self.frame.size.width, 0);
    } completion:^(BOOL finished) {
        if (_mark==_ImageCount+1) {
            [_Scrollview setContentOffset:CGPointMake(self.frame.size.width, 0) animated:NO];
            _mark = 1;
        }
        [_Page setCurrentPage:_mark-1];
    }];
   
//    if ([self.delegate respondsToSelector:@selector(didScrollIndex:)]) {
//        [_delegate didScrollIndex:_Scrollview.contentOffset.x/(self.frame.size.width)-1];
//    }
    
};
-(void)PageClick:(UIPageControl *)page{
    [_Scrollview setContentOffset:CGPointMake((page.currentPage+1)*(self.frame.size.width), 0) animated:YES];
    
}

#pragma mark - 图片点击
- (void)imageClick:(UITapGestureRecognizer *)tap{
    if ([self.delegate respondsToSelector:@selector(imageClickWithIndex:)]) {
      [self.delegate imageClickWithIndex:tap.view.tag];
    }
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self stop];
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self play];
}
- (void)setImageSWithUrlS:(NSArray *)Imagearray placeholdrImageName:(NSString *)imageName{
    [self stop];
    _ImageCount = Imagearray.count;
    _mark = 0;
    CGRect frame = self.frame;
    _Scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    _Scrollview.contentSize = CGSizeMake(frame.size.width*(Imagearray.count+2), frame.size.height);
    for (int i = 0; i < Imagearray.count+2; i++) {
        if (i<Imagearray.count){
//            NSURL *url = [NSURL URLWithString:Imagearray[i]];
            NSString *str = [Imagearray[i] objectForKey:@"photo"];
            str = [MyBase64 stringConpanSteing:str ];
        
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE,str]];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((i+1)*frame.size.width, 0, frame.size.width, frame.size.height)];
            [imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:imageName] options:SDWebImageAllowInvalidSSLCertificates    ];
            [_Scrollview addSubview:imageView];
            self.Scrollview.pagingEnabled = YES;
            imageView.userInteractionEnabled = YES;
            imageView.tag = i+1;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClick:)];
            [imageView addGestureRecognizer:tap];
        }
        if (i==0) {
            
            NSString *str = [Imagearray[Imagearray.count-1] objectForKey:@"photo"];
            str = [MyBase64 stringConpanSteing:str ];

            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE,str]];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*frame.size.width, 0, frame.size.width, frame.size.height)];
            [imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:imageName] options:SDWebImageAllowInvalidSSLCertificates    ];
            [_Scrollview addSubview:imageView];
            self.Scrollview.pagingEnabled = YES;
        }
        if (i==Imagearray.count+1) {
            NSString *str = [Imagearray[0] objectForKey:@"photo"];
            str = [MyBase64 stringConpanSteing:str ];
        
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE,str]];
       
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*frame.size.width, 0, frame.size.width, frame.size.height)];
            [imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:imageName] options:SDWebImageAllowInvalidSSLCertificates    ];
            [_Scrollview addSubview:imageView];
            self.Scrollview.pagingEnabled = YES;
        }
    }
    _Scrollview.delegate = self;
    _Scrollview.contentOffset = CGPointMake(frame.size.width, 0);
    [self addSubview:_Scrollview];
    
    _Page = [[UIPageControl alloc] initWithFrame:CGRectMake(0,frame.size.height-30, frame.size.width, 30)];
    _Page.numberOfPages = Imagearray.count;
    _Page.currentPage = 0;
    _Page.currentPageIndicatorTintColor = [UIColor orangeColor];
    _Page.pageIndicatorTintColor = [UIColor whiteColor];
    [_Page addTarget:self action:@selector(PageClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:_Page];
    [self play];
}

//停止滚动
- (void)stop{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}


//继续滚动
- (void)play{
    if (!_AUTO) {
        _AUTO = YES;
    }
    if (_AUTO&&_ImageCount>=2) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:PlayTime target:self selector:@selector(TimeAutoPlay) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
}


@end
