//
//  HSLoginViewController.m
//  HousekeepingServer
//
//  Created by Jacob on 15/9/30.
//  Copyright (c) 2015年 com.jacob. All rights reserved.
//

#import "HSLoginViewController.h"
#import "HSLoginHeaderView.h"
#import "HSLoginFooterView.h"
#import "XBConst.h"
#import "HSTabBarViewController.h"
#import "HSRegistViewController.h"
#import "HSNavigationViewController.h"
#import "AFNetworking.h"
#import "HSAccount.h"
#import "HSAccountTool.h"
#import "MJExtension.h"
#import "HSHTTPRequestOperationManager.h"
#import "MBProgressHUD+MJ.h"
#import "HSServant.h"
#import "HSServantTool.h"
#import "UIImageView+AFNetworking.h"
#import "BPush.h"
#import "LxDBAnything.h"
#import "HS_NetAPIManager.h"
#import "NSObject+Common.h"
@interface HSLoginViewController () <UIGestureRecognizerDelegate,
                                     UITextFieldDelegate,
                                     HSLoginFooterViewDelegate> {
  UIButton *_loginBtn;
  UIButton *_registBtn;
  HSLoginFooterView *_footerView;
}

@property(strong, nonatomic) RETextItem *userNum;
@property(strong, nonatomic) RETextItem *userPwd;
@property(strong, readwrite, nonatomic) REPickerItem *pickerItem;

@property(strong, nonatomic) RETableViewSection *loginInfoSection;

@property(strong, nonatomic) HSServant *servant;
@end

@implementation HSLoginViewController
- (void)viewDidLoad {
  [super viewDidLoad];
    __typeof (&*self) __weak weakSelf = self;
  // 取消滚动
  self.tableView.scrollEnabled = NO;
  self.loginInfoSection = [self addLoginInfo];
  [self loginBtnStateChange];

  // 取消键盘
  // 设置敲击手势，取消键盘
  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
      initWithTarget:self
              action:@selector(dismissKeyboard)];
  tap.delegate = self;
  [self.view addGestureRecognizer:tap];

  // footerView按钮点击
  [[_loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside]
      subscribeNext:^(id x) {
        [weakSelf loginButtonDidClicked];
      }];

  [[_registBtn rac_signalForControlEvents:UIControlEventTouchUpInside]
      subscribeNext:^(id x) {
        [weakSelf registButtonDidClicked];
      }];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
}

/**
 *  取消键盘
 */
- (void)dismissKeyboard {
  [self.view endEditing:YES];
}

- (RETableViewSection *)addLoginInfo {

  RETableViewSection *section =
      [RETableViewSection sectionWithHeaderView:[HSLoginHeaderView headerView]];
  [self.manager addSection:section];

  self.userNum =
      [RETextItem itemWithTitle:nil value:nil
                    placeholder:@"请输入用户名"];
  self.userNum.image = [UIImage imageNamed:@"login_user"];
  self.userNum.clearButtonMode = UITextFieldViewModeWhileEditing;

  self.userPwd =
      [RETextItem itemWithTitle:nil value:nil placeholder:@"请输入密码"];
  self.userPwd.secureTextEntry = YES;
  self.userPwd.image = [UIImage imageNamed:@"login_key"];
  self.userPwd.clearButtonMode = UITextFieldViewModeWhileEditing;
  [section addItem:self.userNum];
  [section addItem:self.userPwd];

  // 表尾
  HSLoginFooterView *footerView = [HSLoginFooterView footerView];
  CGFloat footerX = 0;
  CGFloat footerY = 0;
  CGFloat footerW = XBScreenWidth;
  CGFloat footerH =
      XBScreenHeight - 2 * 44 - section.headerView.frame.size.height;
  footerView.frame = CGRectMake(footerX, footerY, footerW, footerH);
  footerView.delegate = self;
  _footerView = footerView;
  _loginBtn = (UIButton *)footerView.loginBtn;
  _registBtn = footerView.registBtn;
  self.tableView.tableFooterView = footerView;

  return section;
}

- (void)loginBtnStateChange {
    __typeof (&*self) __weak weakSelf = self;
  // 创建信号
  RACSignal *validUserNumSignal =
      [RACObserve(self.userNum, value) map:^id(id value) {
        return @([weakSelf isUserNumVaild:value]);
      }];
  RACSignal *validUserPwdSignal =
      [RACObserve(self.userPwd, value) map:^id(id value) {
        return @([weakSelf isPwdVaild:value]);
      }];
  RACSignal *loginActiveSignal = [RACSignal
      combineLatest:@[ validUserNumSignal, validUserPwdSignal ]
             reduce:^id(NSNumber *usernameValid, NSNumber *passwordValid) {
               return @([usernameValid boolValue] && [passwordValid boolValue]);
             }];

  [loginActiveSignal subscribeNext:^(NSNumber *loginActive) {
    _loginBtn.enabled = [loginActive boolValue];
    _loginBtn.alpha = 1;
  }];
}
- (BOOL)isUserNumVaild:(NSString *)userNum {
  return userNum.length > 1;
}

- (BOOL)isPwdVaild:(NSString *)userPwd {
  return userPwd.length > 5;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView
    willLayoutCellSubviews:(UITableViewCell *)cell
         forRowAtIndexPath:(NSIndexPath *)indexPath {
  for (UIView *view in cell.contentView.subviews) {
    if ([view isKindOfClass:[UILabel class]] ||
        [view isKindOfClass:[UITextField class]]) {
      ((UILabel *)view).font = [UIFont systemFontOfSize:16];
      CGRect temp = ((UITextField *)view).frame;
      temp.origin.x = 50;
      ((UITextField *)view).frame = temp;
    }
  }
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

#pragma mark - HSLoginFooterViewDelegate
- (void)loginButtonDidClicked {
  __weak HSLoginViewController *weakSelf = self;
  // 创建hud
  MBProgressHUD *hud =
      [MBProgressHUD showHUDAddedTo:self.view animated:YES];
  hud.labelText = @"正在登录";
    // 取消键盘
    [self.view endEditing:YES];
  // 访问服务器
    // 数据体
    NSMutableDictionary *attrParams = [NSMutableDictionary dictionary];
    attrParams[@"servantID"] = self.userNum.value;
    attrParams[@"loginPassword"] = self.userPwd.value;

    [[HS_NetAPIManager sharedManager]request_Login_WithParams:attrParams andBlock:^(id data, NSError *error) {
        hud.hidden = YES;
        if (data) {
            if ([(NSString *)data isEqualToString:@"Success"]) {
                [weakSelf saveServantWithServantID:attrParams[@"servantID"]];
            }else{
                [NSObject showHudTipStr:@"用户名与密码不匹配"];
            }
        }else{
            [NSObject showHudTipStr:@"似乎断开与服务器的连接"];
        }
    }];
}

- (void)saveServantWithServantID:(NSString *)servantID {
    __typeof (&*self) __weak weakSelf = self;
  // 访问服务器
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在存储用户信息";
    
    NSMutableDictionary *servantInfoAttrParams = [NSMutableDictionary dictionary];
    servantInfoAttrParams[@"servantID"] = servantID;

    [[HS_NetAPIManager sharedManager]request_Login_ServantInfoWithParams:servantInfoAttrParams andBlock:^(id data, NSError *error) {
        hud.hidden = YES;
        if (data) {
            if ([(NSString *)data isEqualToString:@"Success"]) {
                HSTabBarViewController *tabVc =
                [[HSTabBarViewController alloc] init];
                weakSelf.view.window.rootViewController = tabVc;
                // 注册推送
                [weakSelf registNotification];
            }else{
                [NSObject showHudTipStr:@"存储失败，请重新登陆"];
            }
        }else{
            [NSObject showHudTipStr:@"似乎断开与服务器的连接"];
        }
    }];
}

- (void)registButtonDidClicked {
  HSRegistViewController *registVc = [[HSRegistViewController alloc] init];
  HSNavigationViewController *nav = [[HSNavigationViewController alloc] init];
  [nav addChildViewController:registVc];
  [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - 注册推送服务
- (void)registNotification {
  UIApplication *application = [UIApplication sharedApplication];
  //  // 推送设置
  //-- Set Notification
  if ([application
          respondsToSelector:@selector(isRegisteredForRemoteNotifications)]) {
    // iOS 8 Notifications
    [application registerUserNotificationSettings:
                     [UIUserNotificationSettings
                         settingsForTypes:(UIUserNotificationTypeBadge |
                                           UIUserNotificationTypeAlert |
                                           UIRemoteNotificationTypeSound)
                               categories:nil]];

    [application registerForRemoteNotifications];
  } else {
    // iOS < 8 Notifications
    [application
        registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                            UIRemoteNotificationTypeAlert |
                                            UIRemoteNotificationTypeSound)];
  }
}

@end
