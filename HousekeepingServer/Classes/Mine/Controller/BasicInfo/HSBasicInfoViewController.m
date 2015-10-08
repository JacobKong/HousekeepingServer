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
#import "HSInfoLableItem.h"
#import "HSDatePickerView.h"
#import "HSOrangeButton.h"
#import "HSPickerView.h"


@interface HSBasicInfoViewController () <
    InfoFooterViewDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate,
    HSDatePickerViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource,
    HSPickerViewDelegate> {
  HSInfoTextFieldItem *_userNum;
  HSInfoTextFieldItem *_userName;
  HSInfoLableItem *_sex;
  HSInfoLableItem *_birthday;
  HSInfoTextFieldItem *_IDCard;
  HSInfoTextFieldItem *_phoneNumber;
  HSInfoTextFieldItem *_email;
  UIDatePicker *_datePicker;
  HSDatePickerView *_pickerView;
  UIPickerView *_picker;
  HSPickerView *_sexPicker;
}

@property(weak, nonatomic) UIButton *saveBtn;
@property(weak, nonatomic) HSInfoFooterView *footerView;
@property(weak, nonatomic) UIBarButtonItem *rightBtn;
@property(strong, nonatomic) HSInfoGroup *g0;

@end

@implementation HSBasicInfoViewController

- (void)viewDidLoad {

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
  tap.delegate = self;
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
  [self dateConfirmButtonDidClicked];
    [self pickerView:_sexPicker confirmButtonDidClickedOnToolBar:_sexPicker.toolBar];
  [self.view endEditing:YES];
}

- (void)setupGroup0 {
  NSMutableDictionary *titleAttr = [NSMutableDictionary dictionary];
  titleAttr[NSFontAttributeName] = [UIFont systemFontOfSize:15];
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
  placeholderAttr[NSFontAttributeName] = [UIFont systemFontOfSize:15];

  NSAttributedString *userNumPh =
      [[NSAttributedString alloc] initWithString:@"账号"
                                      attributes:placeholderAttr];
  NSAttributedString *userNamePh =
      [[NSAttributedString alloc] initWithString:@"姓名"
                                      attributes:placeholderAttr];
  NSAttributedString *sexPh =
      [[NSAttributedString alloc] initWithString:@"性别"
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
  userNum.basicDelegateVc = self;

  HSInfoTextFieldItem *userName =
      [HSInfoTextFieldItem itemWithTitle:userNameStr
                             placeholder:userNamePh
                                    text:@"孔伟杰"];
  _userName = userName;
  userName.basicDelegateVc = self;

    // 性别
  HSInfoLableItem *sex = [HSInfoLableItem itemWithTitle:sexStr];
  _sex = sex;
  if (sex.text.length == 0) {
    sex.text = @"请选择您的性别";
  }
  sex.enable = NO;
  sex.option = ^{
      // 删除datePicker
      [_pickerView removeFromSuperview];
    // 改变tableView的frame
    self.tableView.frame =
        CGRectMake(0, 0, XBScreenWidth, XBScreenHeight * 0.6);
    // 创建pickerView
    CGFloat sexPickerY = XBScreenHeight * 0.6;
    CGFloat sexPickerW = XBScreenWidth;
    CGFloat sexPickerH = XBScreenHeight * 0.4;
    HSPickerView *sexPicker = [HSPickerView picker];
    sexPicker.frame = CGRectMake(0, sexPickerY, sexPickerW, sexPickerH);
    [self.tableView.superview addSubview:sexPicker];
    // 设置代理
    sexPicker.delegate = self;

    _sexPicker = sexPicker;
    _picker = sexPicker.picker;

    _picker.delegate = self;
    _picker.dataSource = self;
      
      // 使保存按钮激活
      self.saveBtn.enabled = YES;
      // 选中第一个
      [self pickerView:_picker didSelectRow:0 inComponent:1];

  };

    // 生日
  HSInfoLableItem *birthday = [HSInfoLableItem itemWithTitle:birthdayStr];
  if (birthday.text.length == 0) {
    birthday.text = @"1900-01-01";
  }
  birthday.enable = NO;

  birthday.option = ^{
      // 删除sexPicker
      [_sexPicker removeFromSuperview];
    // 改变tableView的frame
    self.tableView.frame =
        CGRectMake(0, 0, XBScreenWidth, XBScreenHeight * 0.6);
    // 创建pickerView
    CGFloat pickerViewY = XBScreenHeight * 0.6;
    CGFloat pickerViewW = XBScreenWidth;
    CGFloat pickerViewH = XBScreenHeight * 0.4;
    HSDatePickerView *pickerView = [HSDatePickerView datePicker];
    pickerView.frame = CGRectMake(0, pickerViewY, pickerViewW, pickerViewH);
    [self.tableView.superview addSubview:pickerView];
    // 设置代理
    pickerView.delegate = self;

    _pickerView = pickerView;
    _datePicker = pickerView.datePicker;
    // 监听datePicker
    [_datePicker addTarget:self
                    action:@selector(dateChange)
          forControlEvents:UIControlEventValueChanged];
    // 是保存按钮激活
    self.saveBtn.enabled = YES;
      // 选中今天
      [self dateChange];
  };
  _birthday = birthday;

  HSInfoTextFieldItem *IDCard = [HSInfoTextFieldItem itemWithTitle:IDCardStr
                                                       placeholder:IDCardPh
                                                              text:@"140"];
  _IDCard = IDCard;
  IDCard.basicDelegateVc = self;

  HSInfoTextFieldItem *phoneNumber =
      [HSInfoTextFieldItem itemWithTitle:phoneNumberStr
                             placeholder:phoneNumberPh
                                    text:@"185"];
    IDCard.keyboardtype = UIKeyboardTypeNumberPad;
    
  _phoneNumber = phoneNumber;
  phoneNumber.basicDelegateVc = self;
    phoneNumber.keyboardtype = UIKeyboardTypePhonePad;
    
  HSInfoTextFieldItem *email = [HSInfoTextFieldItem itemWithTitle:emailStr
                                                      placeholder:emailPh
                                                             text:@"947"];
  _email = email;
  email.basicDelegateVc = self;

  HSInfoGroup *g0 = [[HSInfoGroup alloc] init];
  g0.items = @[ userNum, userName, sex, birthday, IDCard, phoneNumber, email ];

  self.g0 = g0;
  [self.data addObject:self.g0];
}

/**
 *  日期变化调用
 */
- (void)dateChange {
  NSString *string = [HSMineTool stringFromDate:_datePicker.date];
  _birthday.text = string;
  [self.tableView reloadData];
}

/**
 *  创建footerView
 */
- (void)setupfooterView {
  HSInfoFooterView *footerView = [HSInfoFooterView footerView];
    HSOrangeButton *saveBtn = [HSOrangeButton orangeButtonWithTitle:@"保存"];
  CGFloat buttonX = 10;
  CGFloat buttonW = footerView.frame.size.width - 2 * buttonX;
  CGFloat buttonH = 50;
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

#pragma mark - 导航栏按钮点击
/**
 *  保存按钮点击
 */
- (void)saveBtnClicked {
  // 禁止按钮点击
  [self setCellDisable];
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
    [self setCellDisable];
      [self dateCancelButtonDidClicked];
      [_sexPicker removeFromSuperview];
      [_pickerView removeFromSuperview];
      [self pickerView:_sexPicker cancelButtonDidClickedOnToolBar:_sexPicker.toolBar];
    [self.tableView reloadData];

  } else {
    self.rightBtn.title = @"取消";
    [self setCellEnable];
    [self.tableView reloadData];
  }
}

#pragma mark - cell状态变化
- (void)setCellEnable {
  _userNum.enable = YES;
  _userName.enable = YES;
  _sex.enable = YES;
  _birthday.enable = YES;
  _IDCard.enable = YES;
  _phoneNumber.enable = YES;
  _email.enable = YES;
}

- (void)setCellDisable {
  _userNum.enable = NO;
  _userName.enable = NO;
  _sex.enable = NO;
  _birthday.enable = NO;
  _IDCard.enable = NO;
  _phoneNumber.enable = NO;
  _email.enable = NO;
}
#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
  HSInfoTableViewCell *cell = [textField superview];
  if ([cell.textLabel.text isEqualToString:@"账号"]) {
    _userNum.text = textField.text;
  } else if ([cell.textLabel.text isEqualToString:@"姓名"]) {
    _userName.text = textField.text;
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

#pragma mark - UIGestureRecognizerDelegate
/**
 *  重写UIGestureRecognizerDelegate解决tap手势与didSelectRowAtIndexPath的冲突
 */
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
       shouldReceiveTouch:(UITouch *)touch {
  // 若为UITableView（即点击了UITableView），则截获Touch事件
  if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableView"]) {
    return YES;
  }
  return NO;
}

#pragma mark - HSDatePickerViewDelegate
/**
 *  修改时间取消按钮
 */
- (void)dateCancelButtonDidClicked {
  _birthday.text = @"1900-01-01";
  [_pickerView removeFromSuperview];

  self.tableView.frame = CGRectMake(0, 0, XBScreenWidth, XBScreenHeight);
  [self.tableView reloadData];
}
/**
 *  修改时间确认按钮
 */
- (void)dateConfirmButtonDidClicked {
  [_pickerView removeFromSuperview];
  self.tableView.frame = CGRectMake(0, 0, XBScreenWidth, XBScreenHeight);
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 2;
}

#pragma mark - UIPickerViewDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (row == 0) {
        return @"女";
    }else{
        return @"男";
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (row == 0) {
        _sex.text = @"女";
    }else{
        _sex.text = @"男";
    }
    [self.tableView reloadData];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 50;
}

#pragma mark - HSPickerViewDelegate
- (void)pickerView:(HSPickerView *)pickerView cancelButtonDidClickedOnToolBar:(UIToolbar *)toolBar{
    _sex.text = @"请选择您的性别";
    [_sexPicker removeFromSuperview];
    
    self.tableView.frame = CGRectMake(0, 0, XBScreenWidth, XBScreenHeight);
    [self.tableView reloadData];
}

- (void)pickerView:(HSPickerView *)pickerView confirmButtonDidClickedOnToolBar:(UIToolbar *)toolBar{
    [_sexPicker removeFromSuperview];
    self.tableView.frame = CGRectMake(0, 0, XBScreenWidth, XBScreenHeight);
}
@end
