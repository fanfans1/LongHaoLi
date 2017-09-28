//
//  CityTableViewController.h
//  HB
//
//  Created by 王小康 on 16/1/11.
//  Copyright © 2016年 范强伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CityTableViewControllerDelegate <NSObject>

- (void)passValueWithDic:(NSDictionary *)dic;

@end

@interface CityTableViewController : UITableViewController

@property (nonatomic, retain)NSString *cityStr;  //  当前城市


@property (nonatomic, assign)id<CityTableViewControllerDelegate>delegate;

@end
