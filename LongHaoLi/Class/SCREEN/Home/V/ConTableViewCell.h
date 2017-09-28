//
//  ConTableViewCell.h
//  Foods
//
//  Created by yy on 2016/11/29.
//  Copyright © 2016年 fanfan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ConTableViewCellDelegate <NSObject>

- (void)passMassage:(NSDictionary *)dic;
@end
 

@interface ConTableViewCell : UITableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

- (void)setArr:(NSArray *)arr;

@property (nonatomic, weak)id<ConTableViewCellDelegate>delegate;

@end

