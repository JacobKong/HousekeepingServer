//
//  HSBasicInfoViewController.m
//  HousekeepingServer
//
//  Created by Jacob on 15/9/26.
//  Copyright (c) 2015年 com.jacob. All rights reserved.
//

#import "HSBasicInfoViewController.h"
#import "HSInfoFooterView.h"
#import "HSInfoTextFieldItem.h"
#import "HSInfoGroup.h"
#import "HSNavBarBtn.h"
#import "UIImage+HSResizingImage.h"
#import "HSNoBorderTextField.h"
#import "HSInfoTableViewCell.h"
#import "MBProgressHUD.h"
#import "XBConst.h"

@interface HSBasicInfoViewController () <InfoFooterViewDelegate,
                                         UITextFieldDelegate> {
  HSInfoTextFieldItem *_userNum;
  HSInfoTextFieldItem *_userName;
  HSInfoTextFieldItem *_sex;
  HSInfoTextFieldItem *_birthday;
  HSInfoTextFieldItem *_IDCard;
  HSInfoTextFieldItem *_phoneNumber;
  HSInfoTextFieldItem *_email;
}

@property(weak, nonatomic) UIButton *saveBtn;
@property(weak, nonatomic) HSInfoFooterView *footerView;
@property(weak, nonatomic) UIBarButtonItem *rightBtn;
@property(strong, nonatomic) HSInfoGroup *g0;

@end

@implementation HSBasicInfoViewController

- (void)viewDidLoad {
  NSLog(@"%@", self.cell.subviews);

  // 添加第一组
  [self setupGroup0];

  // 设置footerView
  [self setupfooterView];

  // 设置导航栏按钮
  [self setupEditingBtn];

  // 设置敲击手势，取消键盘
  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
      initWithTarget:self
              action:@selector(dismissKeyboard)];
  [self.view addGestureRecognizer:tap];

  // 设置通知，文本框文字变化则收到通知，调用textChange方法
  [[NSNotificationCenter defaultCenter]
      addObserver:self
         selector:@selector(textChange)
             name:UITextFieldTextDidChangeNotification
           object:nil];

  // 背景颜色
  self.view.backgroundColor = [UIColor whiteColor];
  [super viewDidLoad];
}

- (void)dealloc {

  [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)textChange {
    self.saveBtn.enabled = YES;
}

/**
 *  取消键盘
 */
- (void)dismissKeyboard {
  [self.view endEditing:YES];
}

- (void)setupGroup0 {
  __weak HSBasicInfoViewController *basic = self;
  NSMutableDictionary *titleAttr = [NSMutableDictionary dictionary];
  titleAttr[NSFontAttributeName] = [UIFont systemFontOfSize:14];
  titleAttr[NSForegroundColorAttributeName] = [UIColor darkGrayColor];

  NSAttributedString *userNumStr =
      [[NSAttributedString alloc] initWithString:@"账号"
                                      attributes:titleAttr];
  NSAttributedString *userNameStr =
      [[NSAttributedString alloc] initWithString:@"姓名"
                                      attributes:titleAttr];
  NSAttributedString *sexStr =
      [[NSAttributedString alloc] initWithString:@"性别"
                                      attributes:titleAttr];
  NSAttributedString *birthdayStr =
      [[NSAttributedString alloc] initWithString:@"生日"
                                      attributes:titleAttr];
  NSAttributedString *IDCardStr =
      [[NSAttributedString alloc] initWithString:@"身份证号"
                                      attributes:titleAttr];
  NSAttributedString *phoneNumberStr =
      [[NSAttributedString alloc] initWithString:@"联系电话"
                                      attributes:titleAttr];
  NSAttributedString *emailStr =
      [[NSAttributedString alloc] initWithString:@"电子邮件"
                                      attributes:titleAttr];

  NSMutableDictionary *placeholderAttr = [NSMutableDictionary dictionary];
  placeholderAttr[NSFontAttributeName] = [UIFont systemFontOfSize:14];

  NSAttributedString *userNumPh =
      [[NSAttributedString alloc] initWithString:@"账号"
                                      attributes:placeholderAttr];
  NSAttributedString *userNamePh =
      [[NSAttributedString alloc] initWithString:@"姓名"
                                      attributes:placeholderAttr];
  NSAttributedString *sexPh =
      [[NSAttributedString alloc] initWithString:@"性别"
                                      attributes:placeholderAttr];
  NSAttributedString *birthdayPh =
      [[NSAttributedString alloc] initWithString:@"生日"
                                      attributes:placeholderAttr];
  NSAttributedString *IDCardPh =
      [[NSAttributedString alloc] initWithString:@"身份证号"
                                      attributes:placeholderAttr];
  NSAttributedString *phoneNumberPh =
      [[NSAttributedString alloc] initWithString:@"联系电话"
                                      attributes:placeholderAttr];
  NSAttributedString *emailPh =
      [[NSAttributedString alloc] initWithString:@"电子邮件"
                                      attributes:placeholderAttr];

  HSInfoTextFieldItem *userNum =
      [HSInfoTextFieldItem itemWithTitle:userNumStr
                             placeholder:userNumPh
                                    text:@"20132037"];
  _userNum = userNum;
  userNum.delegateVc = self;

  HSInfoTextFieldItem *userName =
      [HSInfoTextFieldItem itemWithTitle:userNameStr
                             placeholder:userNamePh
                                    text:@"孔伟杰"];
  _userName = userName;
  userName.delegateVc = self;

  HSInfoTextFieldItem *sex =
      [HSInfoTextFieldItem itemWithTitle:sexStr placeholder:sexPh text:@"男"];
  _sex = sex;
  sex.delegateVc = self;

  HSInfoTextFieldItem *birthday =
      [HSInfoTextFieldItem itemWithTitle:birthdayStr
                             placeholder:birthdayPh
                                    text:@"2013-10-10"];
  _birthday = birthday;
  birthday.delegateVc = self;

  birthday.option = ^{
    //              CGFloat pickerY = XBScreenHeight * 0.6;
    //              CGFloat pickerW = XBScreenWidth;
    //              CGFloat pickerH = XBScreenHeight * 0.4;
    //              CGRect pickerViewF = CGRectMake(0, pickerY, pickerW,
    //              pickerH);
    //              UIDatePicker *datePicker = [[UIDatePicker
    //              alloc]initWithFrame:pickerViewF];
    //              datePicker.datePickerMode = UIDatePickerModeDate;
    //              [self.tableView addSubview:datePicker];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 100, 100)];
    view.backgroundColor = [UIColor redColor];

    // 2.2.文本框
    UITextField *temp = [[UITextField alloc] init];
    temp.inputView = view;
    _birthday.inputView = view;
    [basic.view addSubview:view];
  };

  HSInfoTextFieldItem *IDCard = [HSInfoTextFieldItem itemWithTitle:IDCardStr
                                                       placeholder:IDCardPh
                                                              text:@"140"];
  _IDCard = IDCard;
  IDCard.delegateVc = self;

  HSInfoTextFieldItem *phoneNumber =
      [HSInfoTextFieldItem itemWithTitle:phoneNumberStr
                             placeholder:phoneNumberPh
                                    text:@"185"];
  _phoneNumber = phoneNumber;
  phoneNumber.delegateVc = self;

  HSInfoTextFieldItem *email = [HSInfoTextFieldItem itemWithTitle:emailStr
                                                      placeholder:emailPh
                                                             text:@"947"];
  _email = email;
  email.delegateVc = self;

  HSInfoGroup *g0 = [[HSInfoGroup alloc] init];
  g0.items = @[ userNum, userName, sex, birthday, IDCard, phoneNumber, email ];

  self.g0 = g0;
  [self.data addObject:self.g0];
}

/**
 *  创建footerView
 */
- (void)setupfooterView {
  HSInfoFooterView *footerView = [HSInfoFooterView footerView];

  UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
  saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
  [saveBtn setBackgroundImage:[UIImage resizeableImage:@"common_button_orange"]
                     forState:UIControlStateNormal];
  [saveBtn
      setBackgroundImage:[UIImage
                             resizeableImage:@"common_button_pressed_orange"]
                forState:UIControlStateHighlighted];

  CGFloat buttonX = 10;
  CGFloat buttonW = footerView.frame.size.width - 2 * buttonX;
  CGFloat buttonH = 40;
  CGFloat buttonY = footerView.center.y - buttonH * 0.5;
  saveBtn.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
  [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
  [footerView addSubview:saveBtn];

  self.footerView = footerView;
  self.saveBtn = saveBtn;
  saveBtn.hidden = YES;
  [saveBtn addTarget:self
                action:@selector(saveBtnClicked)
      forControlEvents:UIControlEventTouchUpInside];
  self.tableView.tableFooterView = footerView;
}

/**
 *  保存按钮点击
 */
- (void)saveBtnClicked {
  // 禁止按钮点击
  [self setTextFieldDisable];
  // 重载tableView
  [self.tableView reloadData];

  // 显示HUD
  MBProgressHUD *hud =
      [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
  hud.labelText = @"保存成功";

  dispatch_after(
      dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)),
      dispatch_get_main_queue(), ^{
        [hud hide:YES];
        self.rightBtn.title = @"编辑";
      });

  self.saveBtn.enabled = NO;
  self.saveBtn.hidden = YES;
}

- (void)setupEditingBtn {
  self.navigationItem.rightBarButtonItem =
      [[UIBarButtonItem alloc] initWithTitle:@"编辑"
                                       style:UIBarButtonItemStyleDone
                                      target:self
                                      action:@selector(editBtnClicked)];
  self.rightBtn = self.navigationItem.rightBarButtonItem;
}

/**
 *  编辑按钮点击
 */
- (void)editBtnClicked {
  //  [self.data removeLastObject];
  self.saveBtn.hidden = !self.saveBtn.hidden;
  self.saveBtn.enabled = !self.saveBtn.enabled;

  if ([self.rightBtn.title isEqualToString:@"取消"]) {
    self.rightBtn.title = @"编辑";
    [self setTextFieldDisable];
    [self.tableView reloadData];

  } else {
    self.rightBtn.title = @"取消";
    [self setTextFieldEnable];
    [self.tableView reloadData];
  }
}

- (void)setTextFieldEnable {
  _userNum.enable = YES;
  _userName.enable = YES;
  _sex.enable = YES;
  _birthday.enable = YES;
  _IDCard.enable = YES;
  _phoneNumber.enable = YES;
  _email.enable = YES;
}

- (void)setTextFieldDisable {
  _userNum.enable = NO;
  _userName.enable = NO;
  _sex.enable = NO;
  _birthday.enable = NO;
  _IDCard.enable = NO;
  _phoneNumber.enable = NO;
  _email.enable = NO;
}
#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
  HSInfoTableViewCell *cell = [textField superview];
  if ([cell.textLabel.text isEqualToString:@"账号"]) {
    _userNum.text = textField.text;
  } else if ([cell.textLabel.text isEqualToString:@"姓名"]) {
    _userName.text = textField.text;
  } else if ([cell.textLabel.text isEqualToString:@"性别"]) {
    _sex.text = textField.text;
  } else if ([cell.textLabel.text isEqualToString:@"生日"]) {
    _birthday.text = textField.text;
  } else if ([cell.textLabel.text isEqualToString:@"身份证号"]) {
    _IDCard.text = textField.text;
  } else if ([cell.textLabel.text isEqualToString:@"联系电话"]) {
    _phoneNumber.text = textField.text;
  } else {
    _email.text = textField.text;
  }

  [self.tableView reloadData];
  self.saveBtn.enabled = YES;
}

@end
