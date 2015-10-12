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
#import "HSOrangeButton.h"
#import "HSVerify.h"
#import "HSFinalRegistViewController.h"
#import "AFNetworking.h"
#import "HSHTTPRequestOperationManager.h"
#import "XBConst.h"
#import "MBProgressHUD+MJ.h"
#import "HSInfoLableItem.h"
#import "HSPickerView.h"

@interface HSRegistViewController () <
    UIGestureRecognizerDelegate, UITextFieldDelegate, HSPickerViewDelegate,
    UIPickerViewDelegate, UIPickerViewDataSource> {
  HSInfoTextFieldItem *_servantID;
  HSInfoTextFieldItem *_idCardNo;
  HSInfoTextFieldItem *_servantName;
  HSInfoLableItem *_sex;
  HSInfoTextFieldItem *_servantMobil;
  HSInfoTextFieldItem *_qqNumber;
  HSInfoLableItem *_location;
  HSInfoTextFieldItem *_contactAddress;

  HSInfoTextFieldItem *_userPwd;
  HSInfoTextFieldItem *_confirmPwd;
  HSOrangeButton *_nextBtn;

  NSString *_servantProvince;
  NSString *_servantCity;
  NSString *_servantCounty;
  NSAttributedString *_locationDefaultText;
  NSAttributedString *_sexDefaultText;
}
@property (strong, nonatomic) HSPickerView *sexPicker;
@property (strong, nonatomic) UIPickerView *sexPickerView;
@end

@implementation HSRegistViewController
- (HSPickerView *)sexPicker {
    if (!_sexPicker) {
        CGFloat sexPickerY = XBScreenHeight * 0.6;
        CGFloat sexPickerW = XBScreenWidth;
        CGFloat sexPickerH = XBScreenHeight * 0.4;
        _sexPicker = [HSPickerView picker];
        _sexPicker.frame = CGRectMake(0, sexPickerY, sexPickerW, sexPickerH);
    }
    return _sexPicker;
}

- (UIPickerView *)sexPickerView {
    if (!_sexPickerView) {
        _sexPickerView = self.sexPicker.picker;
    }
    return _sexPickerView;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // 设置标题
  self.title = @"快速注册";
  // 添加第一组
  [self setupGroup0];
  // 添加导航栏按钮
  [self setupNavBtn];
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
  [self.sexPicker removeFromSuperview];
  self.tableView.frame = CGRectMake(0, 0, XBScreenWidth, XBScreenHeight);
}

- (void)setupGroup0 {
  NSMutableDictionary *titleAttr = [NSMutableDictionary dictionary];
  titleAttr[NSFontAttributeName] = [UIFont systemFontOfSize:15];
  titleAttr[NSForegroundColorAttributeName] = [UIColor darkGrayColor];

  NSAttributedString *servantIDStr =
      [[NSAttributedString alloc] initWithString:@"用户名"
                                      attributes:titleAttr];

  NSAttributedString *idCardNoStr =
      [[NSAttributedString alloc] initWithString:@"身份证号"
                                      attributes:titleAttr];

  NSAttributedString *servantNameStr =
      [[NSAttributedString alloc] initWithString:@"用户姓名"
                                      attributes:titleAttr];

  NSAttributedString *servantGenderStr =
      [[NSAttributedString alloc] initWithString:@"性别"
                                      attributes:titleAttr];

  NSAttributedString *servantMobilStr =
      [[NSAttributedString alloc] initWithString:@"手机号码"
                                      attributes:titleAttr];

  NSAttributedString *qqNumberStr =
      [[NSAttributedString alloc] initWithString:@"QQ 帐号"
                                      attributes:titleAttr];
    

  NSAttributedString *userPwdStr =
      [[NSAttributedString alloc] initWithString:@"登录密码"
                                      attributes:titleAttr];

  NSAttributedString *confirmPwdStr =
      [[NSAttributedString alloc] initWithString:@"确认密码"
                                      attributes:titleAttr];

  NSMutableDictionary *placeholderAttr = [NSMutableDictionary dictionary];
  placeholderAttr[NSFontAttributeName] = [UIFont systemFontOfSize:15];

  NSAttributedString *servantIDPh = [[NSAttributedString alloc]
      initWithString:@"请输入20位以内的用户名"
          attributes:placeholderAttr];

  NSAttributedString *idCardNoPh =
      [[NSAttributedString alloc] initWithString:@"请输入18位身份证号"
                                      attributes:placeholderAttr];

  NSAttributedString *servantNamePh =
      [[NSAttributedString alloc] initWithString:@"请输入姓名"
                                      attributes:placeholderAttr];

  NSAttributedString *servantMobilPh =
      [[NSAttributedString alloc] initWithString:@"请输入您的联系电话"
                                      attributes:placeholderAttr];

  NSAttributedString *qqNumberPh =
      [[NSAttributedString alloc] initWithString:@"请输入您的QQ帐号"
                                      attributes:placeholderAttr];

  NSAttributedString *userPwdPh =
      [[NSAttributedString alloc] initWithString:@"请输入6~18位字母数字组合密码"
                                      attributes:placeholderAttr];

  NSAttributedString *confirmPwdPh =
      [[NSAttributedString alloc] initWithString:@"请再次输入密码"
                                      attributes:placeholderAttr];

  NSMutableDictionary *labelAttr = [NSMutableDictionary dictionary];
  labelAttr[NSFontAttributeName] = [UIFont systemFontOfSize:15];
  labelAttr[NSForegroundColorAttributeName] =
      XBMakeColorWithRGB(197, 197, 204, 1);

  NSAttributedString *sexDefaultText =
      [[NSAttributedString alloc] initWithString:@"请选择您的性别"
                                      attributes:labelAttr];

  _sexDefaultText = sexDefaultText;

  // 用户名
  HSInfoTextFieldItem *servantID =
      [HSInfoTextFieldItem itemWithTitle:servantIDStr placeholder:servantIDPh];
  servantID.enable = YES;
  servantID.registDelegateVc = self;
  _servantID = servantID;
  // 身份证号
  HSInfoTextFieldItem *idCardNo =
      [HSInfoTextFieldItem itemWithTitle:idCardNoStr placeholder:idCardNoPh];
  idCardNo.enable = YES;
  idCardNo.registDelegateVc = self;
  idCardNo.keyboardtype = UIKeyboardTypeNumberPad;
  _idCardNo = idCardNo;

  HSInfoTextFieldItem *servantName =
      [HSInfoTextFieldItem itemWithTitle:servantNameStr
                             placeholder:servantNamePh];
  servantName.enable = YES;
  servantName.registDelegateVc = self;
  _servantName = servantName;

  HSInfoLableItem *sex = [HSInfoLableItem itemWithTitle:servantGenderStr];
  sex.attrText = sexDefaultText;
  //    sex.text = @"请选择您的性别";
  sex.enable = YES;
  sex.option = ^{
    // 改变tableView的frame
    self.tableView.frame =
        CGRectMake(0, 0, XBScreenWidth, XBScreenHeight * 0.6);
    [self.tableView.superview addSubview:self.sexPicker];
    // 设置代理
    self.sexPicker.delegate = self;
    self.sexPickerView.delegate = self;
    self.sexPickerView.dataSource = self;

    // 选中第一个
    [self pickerView:self.sexPickerView didSelectRow:0 inComponent:1];

  };
  _sex = sex;

  HSInfoTextFieldItem *servantMobil =
      [HSInfoTextFieldItem itemWithTitle:servantMobilStr
                             placeholder:servantMobilPh];
  servantMobil.enable = YES;
  servantMobil.registDelegateVc = self;
  servantMobil.keyboardtype = UIKeyboardTypePhonePad;
  _servantMobil = servantMobil;

  HSInfoTextFieldItem *qqNumber =
      [HSInfoTextFieldItem itemWithTitle:qqNumberStr placeholder:qqNumberPh];
  qqNumber.enable = YES;
  qqNumber.registDelegateVc = self;
  qqNumber.keyboardtype = UIKeyboardTypeNumberPad;
  _qqNumber = qqNumber;

  HSInfoTextFieldItem *userPwd =
      [HSInfoTextFieldItem itemWithTitle:userPwdStr placeholder:userPwdPh];
  userPwd.enable = YES;
  userPwd.secure = YES;
  userPwd.registDelegateVc = self;
  _userPwd = userPwd;

  HSInfoTextFieldItem *confirmPwd =
      [HSInfoTextFieldItem itemWithTitle:confirmPwdStr
                             placeholder:confirmPwdPh];
  confirmPwd.enable = YES;
  confirmPwd.secure = YES;
  confirmPwd.registDelegateVc = self;
  _confirmPwd = confirmPwd;

  HSInfoGroup *g0 = [[HSInfoGroup alloc] init];
  g0.items = @[
    servantID,
    idCardNo,
    servantName,
    sex,
    servantMobil,
    qqNumber,
    userPwd,
    confirmPwd
  ];

  [self.data addObject:g0];

  // 表尾
  HSInfoFooterView *footerView = [HSInfoFooterView footerView];
  HSOrangeButton *nextBtn = [HSOrangeButton orangeButtonWithTitle:@"下一步"];
  CGFloat buttonX = 10;
  CGFloat buttonW = footerView.frame.size.width - 2 * buttonX;
  CGFloat buttonH = 50;
  CGFloat buttonY = footerView.frame.size.height * 0.5 - buttonH * 0.5;
  nextBtn.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
  nextBtn.enabled = NO;
  nextBtn.alpha = 0.66;
  [nextBtn addTarget:self
                action:@selector(nextBtnClicked)
      forControlEvents:UIControlEventTouchUpInside];
  [footerView addSubview:nextBtn];
  self.tableView.tableFooterView = footerView;
  _nextBtn = nextBtn;
}

/**
 *  下一步按钮点击
 */
- (void)nextBtnClicked {
    NSArray *basicInfoArray = @[
      _servantID.text,
      _idCardNo.text,
      _servantName.text,
      _sex.text,
      _servantMobil.text,
      _qqNumber.text,
      _userPwd.text,
      _confirmPwd.text
    ];
    MBProgressHUD *hud = [MBProgressHUD showMessage:@"请稍等"];
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.labelText = @"请稍等";
    
    // 访问服务器
    AFHTTPRequestOperationManager *manager =
        (AFHTTPRequestOperationManager *)[HSHTTPRequestOperationManager
        manager];
    // 数据体
    NSMutableDictionary *attrParams = [NSMutableDictionary dictionary];
    attrParams[@"servantID"] = _servantID.text;
    NSString *urlStr = [NSString
        stringWithFormat:@"%@/MobileServantInfoAction?operation=_checkServantID",
                         kHSBaseURL];
    // POST，判断用户名是否被占用
    [manager POST:urlStr
        parameters:attrParams
        success:^(AFHTTPRequestOperation *_Nonnull operation,
                  id _Nonnull responseObject) {
          NSString *serverResponse = responseObject[@"serverResponse"];
          if ([serverResponse isEqualToString:@"Failed"]) {
              hud.labelText = @"用户名被占用";
            [hud hide:YES];
            [MBProgressHUD showError:@"用户名被占用"];
            dispatch_after(
                dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)),
                dispatch_get_main_queue(), ^{
                  [MBProgressHUD hideHUD];
                });
          } else if (![HSVerify
                         verifyIDCardNumber:_idCardNo.text]) { //身份证号不正确
            [hud hide:YES];
            [MBProgressHUD showError:@"请输入正确的身份证号码"];
            dispatch_after(
                dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)),
                dispatch_get_main_queue(), ^{
                  [MBProgressHUD hideHUD];
                });
          } else if (![HSVerify verifyPhoneNumber:_servantMobil.text]) {
            [hud hide:YES];
            [MBProgressHUD showError:@"请输入正确的手机号码"];
            dispatch_after(
                dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)),
                dispatch_get_main_queue(), ^{
                  [MBProgressHUD hideHUD];
                });
          } else if (![HSVerify verifyPassword:_userPwd.text]) {
            [hud hide:YES];
            [MBProgressHUD showError:@"输入6-18位数字和字母组合密码"];
            dispatch_after(
                dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)),
                dispatch_get_main_queue(), ^{
                  [MBProgressHUD hideHUD];
                });
          } else if (![_userPwd.text isEqualToString:_confirmPwd.text]) {
            [hud hide:YES];
            [MBProgressHUD showError:@"请输入相同的密码"];
            dispatch_after(
                dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)),
                dispatch_get_main_queue(), ^{
                  [MBProgressHUD hideHUD];
                });
  
          } else {
            [hud hide:YES];
  HSFinalRegistViewController *finalRegistVc =
      [[HSFinalRegistViewController alloc] init];
    finalRegistVc.basicInfoArray = basicInfoArray;
  [self.navigationController pushViewController:finalRegistVc animated:YES];
          }
        }
        failure:^(AFHTTPRequestOperation *_Nonnull operation,
                  NSError *_Nonnull error) {
          [hud hide:YES];
          [MBProgressHUD showError:@"网络错误,请检查网络情况"];
          dispatch_after(
              dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)),
              dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUD];
              });
  
        }];
}
- (void)setupNavBtn {
  self.navigationItem.leftBarButtonItem =
      [[UIBarButtonItem alloc] initWithTitle:@"取消"
                                       style:UIBarButtonItemStyleDone
                                      target:self
                                      action:@selector(backBtnClicked)];
}
/**
 *  取消按钮点击
 */
- (void)backBtnClicked {
  [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIGestureRecognizerDelegate
/**
 *  重写UIGestureRecognizerDelegate解决tap手势与didSelectRowAtIndexPath的冲突
 */
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
       shouldReceiveTouch:(UITouch *)touch {
  NSString *tapPlace = NSStringFromClass([touch.view class]);
  // 若为UITableView（即点击了UITableView），则截获Touch事件
  if ([tapPlace isEqualToString:@"UITableView"]) {
    return YES;
  }
  return NO;
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
  UITableViewCell *cell = (UITableViewCell *)[textField superview];
  NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
  if (![textField.text isEqualToString:@""]) {
    switch (indexPath.row) {
    case 0:
      _servantID.text = textField.text;
      break;
    case 1:
      _idCardNo.text = textField.text;
      break;
    case 2:
      _servantName.text = textField.text;
      break;
    case 4:
      _servantMobil.text = textField.text;
      break;
    case 5:
      _qqNumber.text = textField.text;
      break;
    case 6:
      _userPwd.text = textField.text;
      break;
    case 7:
      _confirmPwd.text = textField.text;
      break;
    }
  } else {
    switch (indexPath.row) {
    case 0:
      _servantID.text = NULL;
      break;
    case 1:
      _idCardNo.text = NULL;
      break;
    case 2:
      _servantName.text = NULL;
      break;
    case 4:
      _servantMobil.text = NULL;
      break;
    case 5:
      _qqNumber.text = NULL;
      break;
    case 6:
      _userPwd.text = NULL;
      break;
    case 7:
      _confirmPwd.text = NULL;
      break;
    }
  }
  if (_servantID.text && _idCardNo.text && _servantName.text &&
      _servantMobil.text && ([_sex.text isEqualToString:@"女"] ||
                             [_sex.text isEqualToString:@"男"]) &&
      _qqNumber.text && _userPwd.text && _confirmPwd.text) {
    _nextBtn.enabled = YES;
    _nextBtn.alpha = 1;
  } else {
    _nextBtn.enabled = NO;
    _nextBtn.alpha = 0.66;
  }
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
  return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component {

  return 2;
}

#pragma mark - UIPickerViewDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component {
  if (row == 0) {
    return @"女";
  } else {
    return @"男";
  }
}

- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component {
  if (row == 0) {
    _sex.text = @"女";
  } else {
    _sex.text = @"男";
  }
  [self.tableView reloadData];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView
rowHeightForComponent:(NSInteger)component {
  return 50;
}

#pragma mark - HSPickerViewDelegate
- (void)pickerView:(HSPickerView *)pickerView
    cancelButtonDidClickedOnToolBar:(UIToolbar *)toolBar {
  _sex.attrText = _sexDefaultText;
  [self.sexPicker removeFromSuperview];
  self.tableView.frame = CGRectMake(0, 0, XBScreenWidth, XBScreenHeight);
  [self.tableView reloadData];
}

- (void)pickerView:(HSPickerView *)pickerView
    confirmButtonDidClickedOnToolBar:(UIToolbar *)toolBar {
  [self.sexPicker removeFromSuperview];
  self.tableView.frame = CGRectMake(0, 0, XBScreenWidth, XBScreenHeight);
}

@end
