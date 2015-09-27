//
//  HSChangPwdViewController.m
//  HousekeepingServer
//
//  Created by Jacob on 15/9/26.
//  Copyright (c) 2015年 com.jacob. All rights reserved.
//

#import "HSChangPwdViewController.h"
#import "HSInfoItem.h"
#import "HSInfoTextFieldItem.h"
#import "HSInfoGroup.h"
#import "HSInfoFooterView.h"
#import "XBConst.h"


@implementation HSChangPwdViewController
- (void)viewDidLoad{
    
    [self setupGroup0];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]   initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    [super viewDidLoad];
}

/**
 *  取消键盘
 */
-(void)dismissKeyboard {
    [self.view endEditing:YES];
}

- (void)setupGroup0{
    NSMutableDictionary *titleAttr = [NSMutableDictionary dictionary];
    titleAttr[NSFontAttributeName] = [UIFont systemFontOfSize:14];
    titleAttr[NSForegroundColorAttributeName] = [UIColor darkGrayColor];
    
    NSAttributedString *originPwdStr = [[NSAttributedString alloc]initWithString:@"原密码" attributes:titleAttr];
    NSAttributedString *newPwdStr = [[NSAttributedString alloc]initWithString:@"新密码" attributes:titleAttr];
    NSAttributedString *confirmPwdStr = [[NSAttributedString alloc]initWithString:@"确认密码" attributes:titleAttr];
    
    NSMutableDictionary *placeholderAttr = [NSMutableDictionary dictionary];
    placeholderAttr[NSFontAttributeName] = [UIFont systemFontOfSize:14];

    NSAttributedString *originPwdPh = [[NSAttributedString alloc]initWithString:@"请输入原密码" attributes:placeholderAttr];
    NSAttributedString *newPwdPh= [[NSAttributedString alloc]initWithString:@"6-18位数字、字母或其他符号" attributes:placeholderAttr];
    NSAttributedString *confirmPwdPh = [[NSAttributedString alloc]initWithString:@"请再次输入密码" attributes:placeholderAttr];
    
    HSInfoTextFieldItem *originPwd = [HSInfoTextFieldItem itemWithTitle:originPwdStr placeholder:originPwdPh];
    originPwd.secure = YES;
    originPwd.enable = YES;
    HSInfoTextFieldItem *newPwd = [HSInfoTextFieldItem itemWithTitle:newPwdStr placeholder:newPwdPh];
    newPwd.secure = YES;
    newPwd.enable = YES;
    HSInfoTextFieldItem *confirmPwd = [HSInfoTextFieldItem itemWithTitle:confirmPwdStr placeholder:confirmPwdPh];
    confirmPwd.secure = YES;
    confirmPwd.enable = YES;
    HSInfoGroup *g0 = [[HSInfoGroup alloc]init];
    g0.items = @[originPwd, newPwd, confirmPwd];
    
    [self.data addObject:g0];
    
    // footerView
    HSInfoFooterView *footerView = [HSInfoFooterView footerViewWithBtnTitle:@"提交"];
    self.tableView.tableFooterView = footerView;
    
}
@end
