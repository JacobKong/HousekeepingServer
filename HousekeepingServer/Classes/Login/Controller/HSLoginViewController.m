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

- (void)dealloc
{
    NSLog(@"LoginDealloc------"); 
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
  __weak MBProgressHUD *hud =
      [MBProgressHUD showHUDAddedTo:self.view animated:YES];
  hud.labelText = @"正在登录";

  // 访问服务器
  AFHTTPRequestOperationManager *manager =
      (AFHTTPRequestOperationManager *)[HSHTTPRequestOperationManager manager];
  // 数据体
  NSMutableDictionary *attrParams = [NSMutableDictionary dictionary];
  attrParams[@"servantID"] = self.userNum.value;
  attrParams[@"loginPassword"] = self.userPwd.value;
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
          XBLog(@"%@", responseObject);
          // 存储模型数据
          [HSAccountTool saveAccount:account];

          hud.mode = MBProgressHUDModeCustomView;
          hud.labelText = @"登录成功";
          hud.customView = MBProgressHUDSuccessView;
          [hud hide:YES afterDelay:1.0];
          hud.completionBlock = ^{
            [weakSelf saveServantWithServantID:attrParams[@"servantID"]];
          };
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

- (void)saveServantWithServantID:(NSString *)servantID {
    __typeof (&*self) __weak weakSelf = self;
  // 访问服务器
  AFHTTPRequestOperationManager *manager =
      (AFHTTPRequestOperationManager *)[HSHTTPRequestOperationManager manager];
  MBProgressHUD *hud1 = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
  hud1.labelText = @"正在存储用户信息";
  // 根据servantID找出当前登录用户的信息
  NSString *servantInfoURLStr =
      [NSString stringWithFormat:
                    @"%@/MobileServantInfoAction?operation=_queryByServantID",
                    kHSBaseURL];
  NSMutableDictionary *servantInfoAttrParams = [NSMutableDictionary dictionary];
  servantInfoAttrParams[@"servantID"] = servantID;
  [manager POST:servantInfoURLStr
      parameters:servantInfoAttrParams
      success:^(AFHTTPRequestOperation *_Nonnull operation,
                id _Nonnull responseObject) {
        NSString *response = responseObject[@"serverResponse"];
        if ([response isEqualToString:@"Success"]) {
          // 创建模型
          weakSelf.servant = [HSServant objectWithKeyValues:kDataResponse];
          // 存储模型
          [HSServantTool saveServant:weakSelf.servant];
          hud1.mode = MBProgressHUDModeCustomView;
          hud1.labelText = @"存储成功";
          hud1.customView = MBProgressHUDSuccessView;
          [hud1 hide:YES afterDelay:1.0];
          hud1.completionBlock = ^{
            HSTabBarViewController *tabVc =
                [[HSTabBarViewController alloc] init];
            weakSelf.view.window.rootViewController = tabVc;
            // 注册推送
            [weakSelf registNotification];
          };
        } else {
          hud1.mode = MBProgressHUDModeCustomView;
          hud1.labelText = @"存储失败，请重新登陆";
          hud1.customView = MBProgressHUDErrorView;
          [hud1 hide:YES afterDelay:1.0];

          _servant = [[HSServant alloc] init];
        }
      }
      failure:^(AFHTTPRequestOperation *_Nonnull operation,
                NSError *_Nonnull error) {
        hud1.mode = MBProgressHUDModeCustomView;
        hud1.labelText = @"网络错误,请重新登录";
        hud1.customView = MBProgressHUDErrorView;
        [hud1 hide:YES afterDelay:1.0];
        XBLog(@"%@", error);
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
