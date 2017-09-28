//
//  ShopLocalViewController.h
//  Foods
//
//  Created by yy on 2016/12/5.
//  Copyright © 2016年 fanfan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ShopLocalViewControllerDelegate <NSObject>

- (void)passValue:(double)la lo:(double)lo city:(NSString *)city det:(NSString *)det;

@end


@interface ShopLocalViewController : UIViewController

@property (nonatomic, assign)id<ShopLocalViewControllerDelegate>delegate;

@property (nonatomic, retain)UILabel *local;


@property (nonatomic, assign)double la;
@property (nonatomic, assign)double lo;

@end
