//
//  CityViewController.h
//  MySelectCityDemo
//
//  Created by 亿缘 on 2017/4/8.
//  Copyright © 2017年 fanfan. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface CityViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
}
@property (nonatomic,copy)void(^selectString)(NSString *string);
@property (nonatomic,copy)NSString *currentCityString;
@end
