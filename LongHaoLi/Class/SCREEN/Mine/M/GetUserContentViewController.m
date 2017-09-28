//
//  GetUserContentViewController.m
//  Longhaoli
//
//  Created by 亿缘 on 2017/7/21.
//  Copyright © 2017年 亿缘. All rights reserved.
//

#import "GetUserContentViewController.h"
#import <ContactsUI/ContactsUI.h>

@interface GetUserContentViewController ()<CNContactPickerDelegate>


@end

@implementation GetUserContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor clearColor];
    CNContactPickerViewController * contactPickerVc = [CNContactPickerViewController new];
    
    contactPickerVc.delegate = self;
    
    [self presentViewController:contactPickerVc animated:YES completion:nil];
}
#pragma mark - 选中一个联系人
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact{
    
 
    //phoneNumbers 包含手机号和家庭电话等
    for (CNLabeledValue * labeledValue in contact.phoneNumbers) {
        
        CNPhoneNumber * phoneNumber = labeledValue.value;
        // 去除-
        NSString *str = [phoneNumber.stringValue stringByReplacingOccurrencesOfString:@"-" withString:@""];
        self.phoneBlock(str);
    }
}


- (void)returnPhoneNum:(returnPhoneNum)block{
    
    self.phoneBlock  = block;
    
}
 
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
