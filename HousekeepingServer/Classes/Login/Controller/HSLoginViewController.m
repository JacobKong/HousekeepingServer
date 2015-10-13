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
#import "HSTabBarViewController.h"
#import "HSRegistViewController.h"
#import "HSNavigationViewController.h"
#import "AFNetworking.h"
#import "HSAccount.h"
#import "HSAccountTool.h"
#import "MJExtension.h"
#import "HSTabBar.h"
#import "HSHTTPRequestOperationManager.h"
#import "MBProgressHUD+MJ.h"
#import "HSServant.h"
#import "HSServantTool.h"
@interface HSLoginViewController () <UIGestureRecognizerDelegate,
                                     UITextFieldDelegate,
                                     HSLoginFooterViewDelegate> {
  HSInfoTextFieldItem *_userNum;
  HSInfoTextFieldItem *_userPwd;
  UIButton *_loginBtn;
  HSLoginFooterView *_footerView;
}
@property (strong, nonatomic) HSServant *servant;
//@property (strong, nonatomic) MBProgressHUD *hud;
@end

@implementation HSLoginViewController
- (void)viewDidLoad {
  [super viewDidLoad];
  // 设置背景
  self.tableView.backgroundColor =
      [UIColor colorWithPatternImage:[UIImage imageNamed:@"login_wallpaper"]];
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

- (void)setupGroup0 {
  NSMutableDictionary *placeholderAttr = [NSMutableDictionary dictionary];
  placeholderAttr[NSFontAttributeName] = [UIFont systemFontOfSize:16];

  NSAttributedString *userNumPh =
      [[NSAttributedString alloc] initWithString:@"请输入用户名"
                                      attributes:placeholderAttr];
  NSAttributedString *userPwdPh =
      [[NSAttributedString alloc] initWithString:@"请输入密码"
                                      attributes:placeholderAttr];

  HSInfoTextFieldItem *userNum =
      [HSInfoTextFieldItem itemWithIcon:@"login_user" placeholder:userNumPh];
  userNum.enable = YES;
  userNum.loginDelegateVc = self;
  _userNum = userNum;

  HSInfoTextFieldItem *userPwd =
      [HSInfoTextFieldItem itemWithIcon:@"login_key" placeholder:userPwdPh];
  userPwd.enable = YES;
  userPwd.loginDelegateVc = self;
  userPwd.secure = YES;
  _userPwd = userPwd;

  HSInfoGroup *g0 = [[HSInfoGroup alloc] init];
  g0.items = @[ userNum, userPwd ];

  [self.data addObject:g0];

  // 表头
  self.tableView.tableHeaderView = [HSLoginHeaderView headerView];

  // 表尾
  HSLoginFooterView *footerView = [HSLoginFooterView footerView];
  CGFloat footerX = 0;
  CGFloat footerY = 0;
  CGFloat footerW = XBScreenWidth;
  CGFloat footerH = XBScreenHeight - 3 * 44 -
                    self.tableView.tableHeaderView.frame.size.height;
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
  if ([tapPlace isEqualToString:@"UITableView"] ||
      [tapPlace isEqualToString:@"HSLoginHeaderView"]) {
    return YES;
  }
  return NO;
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
  HSInfoTableViewCell *cell = (HSInfoTableViewCell *)[textField superview];
  NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (![textField.text isEqualToString:@""]){
        if (indexPath.row == 0) {
            _userNum.text = textField.text;
        } else {
            _userPwd.text = textField.text;
        }
    }else{
        if (indexPath.row == 0) {
            _userNum.text = NULL;
        } else {
            _userPwd.text = NULL;
        }

    }
  if (_userNum.text.length && _userPwd.text.length) {
    _loginBtn.enabled = YES;
    _loginBtn.alpha = 1;
  } else {
    _loginBtn.enabled = NO;
    _loginBtn.alpha = 0.66;
  }
}

#pragma mark - HSLoginFooterViewDelegate
- (void)loginButtonDidClicked {
    __weak HSLoginViewController *weakSelf = self;
    // 创建hud
   __weak MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在登录";

  // 访问服务器
    AFHTTPRequestOperationManager *manager = (AFHTTPRequestOperationManager *)[HSHTTPRequestOperationManager manager];
  // 数据体
  NSMutableDictionary *attrParams = [NSMutableDictionary dictionary];
  attrParams[@"servantID"] = _userNum.text;
  attrParams[@"loginPassword"] = _userPwd.text;
  NSString *urlStr =
      [NSString stringWithFormat:@"%@/MobileServantInfoAction?operation=_login",
                                 kHSBaseURL];
  [manager POST:urlStr
      parameters:attrParams
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
          // 登录成功
        if ([kServiceResponse isEqualToString:@"Success"]) {
            // 创建模型
            HSAccount *account = [HSAccount objectWithKeyValues:responseObject];
            NSLog(@"%@", responseObject);
            // 存储模型数据
            [HSAccountTool saveAccount:account];

            hud.mode = MBProgressHUDModeCustomView;
            hud.labelText = @"登录成功";
            hud.customView = MBProgressHUDSuccessView;
            [hud hide:YES afterDelay:1.0];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                hud.labelText = @"正在存储用户信息";
                // 根据servantID找出当前登录用户的信息
                NSString *servantInfoURLStr = [NSString stringWithFormat:@"%@/MobileServantInfoAction?operation=_queryByServantID",
                                               kHSBaseURL];
                NSMutableDictionary *servantInfoAttrParams = [NSMutableDictionary dictionary];
                servantInfoAttrParams[@"servantID"] = attrParams[@"servantID"];
                [manager POST:servantInfoURLStr parameters:servantInfoAttrParams success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                    NSString *response = responseObject[@"serverResponse"];
                    if ([response isEqualToString:@"Success"]) {
                        // 创建模型
                        weakSelf.servant = [HSServant objectWithKeyValues:kDataResponse];
                        // 存储模型
                        [HSServantTool saveServant:weakSelf.servant];
                        hud.mode = MBProgressHUDModeCustomView;
                        hud.labelText = @"存储成功";
                        hud.customView = MBProgressHUDSuccessView;
                        [hud hide:YES afterDelay:1.0];
                        hud.completionBlock = ^{
                            [weakSelf dismissViewControllerAnimated:YES completion:nil];
                        };
                    }else{
                        hud.mode = MBProgressHUDModeCustomView;
                        hud.labelText = @"存储失败，请重新登陆";
                        hud.customView = MBProgressHUDErrorView;
                        [hud hide:YES afterDelay:1.0];
                        
                        _servant = [[HSServant alloc]init];
                    }
                } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
                    hud.mode = MBProgressHUDModeCustomView;
                    hud.labelText = @"网络错误,请重新登录";
                    hud.customView = MBProgressHUDErrorView;
                    [hud hide:YES afterDelay:1.0];
                    NSLog(@"%@", error);
                }];

            });
        } else {
            hud.mode = MBProgressHUDModeCustomView;
            hud.labelText = @"用户名或密码错误";
            hud.customView = MBProgressHUDErrorView;
            [hud hide:YES afterDelay:1.0];
        }

      }
      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          hud.mode = MBProgressHUDModeCustomView;
          hud.labelText = @"网络错误,请重新登录";
          hud.customView = MBProgressHUDErrorView;
          [hud hide:YES afterDelay:1.0];
      }];
}

- (void)registButtonDidClicked {
  HSRegistViewController *registVc = [[HSRegistViewController alloc] init];
  HSNavigationViewController *nav = [[HSNavigationViewController alloc] init];
  [nav addChildViewController:registVc];
  [self presentViewController:nav animated:YES completion:nil];
}
@end
