//
//  HSLoginViewController.m
//  HousekeepingServer
//
//  Created by Jacob on 15/9/30.
//  Copyright (c) 2015年 com.jacob. All rights reserved.
//

#import "HSLoginViewController.h"
#import "HSInfoTextFieldItem.h"
#import "HSInfoGroup.h"
#import "HSLoginHeaderView.h"
#import "HSLoginFooterView.h"
#import "XBConst.h"
#import "HSInfoTableViewCell.h"
#import "MBProgressHUD.h"
#import "HSTabBarViewController.h"
#import "HSRegistViewController.h"
#import "HSNavigationViewController.h"

@interface HSLoginViewController () <UIGestureRecognizerDelegate, UITextFieldDelegate, HSLoginFooterViewDelegate>{
    HSInfoTextFieldItem* _userNum;
    HSInfoTextFieldItem* _userPwd;
    UIButton* _loginBtn;
    HSLoginFooterView* _footerView;
}
@end

@implementation HSLoginViewController 
- (void)viewDidLoad{
    [super viewDidLoad];
    // 设置背景
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"login_wallpaper"]];
    // 取消滚动
    self.tableView.scrollEnabled = NO;
    // 创建第一组
    [self setupGroup0];
    
    // 取消键盘
    // 设置敲击手势，取消键盘
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
    
}
/**
 *  取消键盘
 */
- (void)dismissKeyboard {
    [self.view endEditing:YES];
}

- (void)setupGroup0{
    NSMutableDictionary *placeholderAttr = [NSMutableDictionary dictionary];
    placeholderAttr[NSFontAttributeName] = [UIFont systemFontOfSize:16];
    
    NSAttributedString *userNumPh =
    [[NSAttributedString alloc] initWithString:@"邮箱/手机号"
                                    attributes:placeholderAttr];
    NSAttributedString *userPwdPh =
    [[NSAttributedString alloc] initWithString:@"请输入密码"
                                    attributes:placeholderAttr];

    HSInfoTextFieldItem *userNum = [HSInfoTextFieldItem itemWithIcon:@"login_user" placeholder:userNumPh];
    userNum.enable = YES;
    userNum.loginDelegateVc = self;
    _userNum = userNum;
    
    HSInfoTextFieldItem *userPwd = [HSInfoTextFieldItem itemWithIcon:@"login_key" placeholder:userPwdPh];
    userPwd.enable = YES;
    userPwd.loginDelegateVc = self;
    userPwd.secure = YES;
    _userPwd = userPwd;
    
    HSInfoGroup *g0 = [[HSInfoGroup alloc]init];
    g0.items = @[userNum, userPwd];
    
    [self.data addObject:g0];
    
    // 表头
    self.tableView.tableHeaderView = [HSLoginHeaderView headerView];
    
    // 表尾
    HSLoginFooterView *footerView = [HSLoginFooterView footerView];
    CGFloat footerX = 0;
    CGFloat footerY = 0;
    CGFloat footerW = XBScreenWidth;
    CGFloat footerH = XBScreenHeight - 3 * 44 - self.tableView.tableHeaderView.frame.size.height;
    footerView.frame = CGRectMake(footerX, footerY, footerW, footerH);
    self.tableView.tableFooterView = footerView;
    footerView.delegate = self;
    _footerView = footerView;
    _loginBtn = footerView.loginBtn;

}

#pragma mark - UIGestureRecognizerDelegate
/**
 *  重写UIGestureRecognizerDelegate解决tap手势与didSelectRowAtIndexPath的冲突
 */
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
       shouldReceiveTouch:(UITouch *)touch {
    NSString *tapPlace = NSStringFromClass([touch.view class]);
    // 若为UITableView（即点击了UITableView），则截获Touch事件
    if ([tapPlace isEqualToString:@"UITableView"] || [tapPlace isEqualToString:@"HSLoginHeaderView"]) {
        return YES;
    }
    return NO;
}


#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    HSInfoTableViewCell *cell = (HSInfoTableViewCell *)[textField superview];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (indexPath.row == 0) {
        _userNum.text = textField.text;
    }else{
        _userPwd.text = textField.text;
    }
    if (_userNum.text.length && _userPwd.text.length) {
        _loginBtn.enabled = YES;
        _loginBtn.alpha = 1;
    } else{
        _loginBtn.enabled = NO;
        _loginBtn.alpha = 0.66;
    }
    
}

#pragma mark - HSLoginFooterViewDelegate
- (void)loginButtonDidClicked{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在登录";
    if ([_userNum.text isEqualToString:@"1234"] && [_userPwd.text isEqualToString:@"1234"]) {
        hud.labelText = @"登录成功";
        hud.mode = MBProgressHUDModeCustomView;
        hud.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"success"]];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self dismissViewControllerAnimated:YES completion:nil];
            [hud hide:YES];
        });
    }else{
        hud.labelText = @"用户名或密码错误";
        hud.mode = MBProgressHUDModeCustomView;
        hud.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"error"]];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [hud hide:YES];
        });
    }
}

- (void)registButtonDidClicked{
    HSRegistViewController *registVc = [[HSRegistViewController alloc]init];
    HSNavigationViewController *nav = [[HSNavigationViewController alloc]init];
    [nav addChildViewController:registVc];
    [self presentViewController:nav animated:YES completion:nil];
}
@end
