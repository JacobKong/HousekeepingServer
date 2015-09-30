//
//  HSRegistViewController.m
//  HousekeepingServer
//
//  Created by Jacob on 15/9/30.
//  Copyright (c) 2015年 com.jacob. All rights reserved.
//

#import "HSRegistViewController.h"
#import "HSInfoTextFieldItem.h"
#import "HSInfoGroup.h"
#import "HSInfoFooterView.h"
#import "HSNavBarBtn.h"

@interface HSRegistViewController (){
    HSInfoTextFieldItem *_userNum;
    HSInfoTextFieldItem *_phoneNum;
    HSInfoTextFieldItem *_userPwd;
    HSInfoTextFieldItem *_confirmPwd;
}

@end

@implementation HSRegistViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    // 设置标题
    self.title = @"注册";
    // 添加第一组
    [self setupGroup0];
    // 添加导航栏标题
    [self setupNavBtn];
}

- (void)setupGroup0{
    NSMutableDictionary *titleAttr = [NSMutableDictionary dictionary];
    titleAttr[NSFontAttributeName] = [UIFont systemFontOfSize:16];
    titleAttr[NSForegroundColorAttributeName] = [UIColor darkGrayColor];
    
    NSAttributedString *userNumStr =
    [[NSAttributedString alloc] initWithString:@"用户账号"
                                    attributes:titleAttr];

    NSAttributedString *phoneNumberStr =
    [[NSAttributedString alloc] initWithString:@"联系电话"
                                    attributes:titleAttr];
    
    NSAttributedString *userPwdStr =
    [[NSAttributedString alloc] initWithString:@"登录密码"
                                    attributes:titleAttr];
    
    NSAttributedString *confirmPwdStr =
    [[NSAttributedString alloc] initWithString:@"确认密码"
                                    attributes:titleAttr];
    
    
    
    
    NSMutableDictionary *placeholderAttr = [NSMutableDictionary dictionary];
    placeholderAttr[NSFontAttributeName] = [UIFont systemFontOfSize:16];
    
    NSAttributedString *userNumPh =
    [[NSAttributedString alloc] initWithString:@"请输入6至8位的账户名"
                                    attributes:placeholderAttr];
    
    NSAttributedString *phoneNumberPh =
    [[NSAttributedString alloc] initWithString:@"请输入您的联系电话"
                                    attributes:placeholderAttr];
    
    NSAttributedString *userPwdPh =
    [[NSAttributedString alloc] initWithString:@"请输入密码"
                                    attributes:placeholderAttr];
    
    NSAttributedString *confirmPwdPh =
    [[NSAttributedString alloc] initWithString:@"请再次输入密码"
                                    attributes:placeholderAttr];

    
    HSInfoTextFieldItem *userNum = [HSInfoTextFieldItem itemWithTitle:userNumStr placeholder:userNumPh];
    userNum.enable = YES;
    userNum.registDelegateVc = self;
    _userNum = userNum;
    
    HSInfoTextFieldItem *phoneNum = [HSInfoTextFieldItem itemWithTitle:phoneNumberStr placeholder:phoneNumberPh];
    phoneNum.enable = YES;
    phoneNum.registDelegateVc = self;
    phoneNum.keyboardtype = UIKeyboardTypePhonePad;
    _phoneNum = phoneNum;
    
    HSInfoTextFieldItem *userPwd = [HSInfoTextFieldItem itemWithTitle:userPwdStr placeholder:userPwdPh];
    userPwd.enable = YES;
    userPwd.secure = YES;
    userPwd.registDelegateVc = self;
    _userPwd = userPwd;
    
    HSInfoTextFieldItem *confirmPwd = [HSInfoTextFieldItem itemWithTitle:confirmPwdStr placeholder:confirmPwdPh];
    confirmPwd.enable = YES;
    confirmPwd.secure = YES;
    confirmPwd.registDelegateVc = self;
    _confirmPwd = confirmPwd;
    
    HSInfoGroup *g0 = [[HSInfoGroup alloc]init];
    g0.items = @[userNum, phoneNum, userPwd, confirmPwd];
    
    [self.data addObject:g0];
    
    // 表尾
    HSInfoFooterView *footerView = [HSInfoFooterView footerViewWithBtnTitle:@"注册"];
    self.tableView.tableFooterView = footerView;
}

- (void)setupNavBtn{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(backBtnClicked)];
}

- (void)backBtnClicked{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
