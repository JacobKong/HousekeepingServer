//
//  HSRegistViewController.m
//  HousekeepingServer
//
//  Created by Jacob on 15/9/30.
//  Copyright (c) 2015年 com.jacob. All rights reserved.
//

#import "HSRegistViewController.h"
#import "HSInfoFooterView.h"
#import "HSNavBarBtn.h"
#import "HSOrangeButton.h"
#import "HSVerify.h"
#import "HSFinalRegistViewController.h"
#import "MBProgressHUD.h"

@interface HSRegistViewController ()
@property(strong, readwrite, nonatomic)
    RETableViewSection *basicRegisterInfoSection;

@property(strong, readwrite, nonatomic) RETextItem *servantID;
@property(strong, readwrite, nonatomic) RETextItem *idCardNo;
@property(strong, readwrite, nonatomic) RETextItem *servantName;
@property(strong, readwrite, nonatomic) REPickerItem *sex;
@property(strong, readwrite, nonatomic) RETextItem *servantMobil;
@property(strong, readwrite, nonatomic) RETextItem *qqNumber;
@property(strong, readwrite, nonatomic) RETextItem *userPwd;
@property(strong, readwrite, nonatomic) RETextItem *confirmPwd;
@property(strong, readwrite, nonatomic) RETextItem *location;

@property(strong, nonatomic) HSOrangeButton *nextBtn;
@end

@implementation HSRegistViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // 设置标题
  self.title = @"快速注册";
    // 设置导航蓝按钮
    [self setupNavBtn];
  // 添加第一组
  self.basicRegisterInfoSection = [self addBasicRegisterInfoSection];
    // 下一步按钮状态
    [self nextBtnStateChange];
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

- (RETableViewSection *)addBasicRegisterInfoSection {
    __typeof (&*self) __weak weakSelf = self;
  RETableViewSection *section =
      [RETableViewSection sectionWithHeaderTitle:@"基本信息填写"
                                     footerTitle:nil];
  [self.manager addSection:section];

  self.servantID =
      [RETextItem itemWithTitle:@"用户名"
                          value:nil
                    placeholder:@"请输入20位以内的用户名"];
  self.servantID.clearButtonMode = UITextFieldViewModeWhileEditing;

  self.idCardNo = [RETextItem itemWithTitle:@"身份证号"
                                      value:nil
                                placeholder:@"请输入18位身份证号"];
  self.idCardNo.keyboardType = UIKeyboardTypeNumberPad;
  self.idCardNo.clearButtonMode = UITextFieldViewModeWhileEditing;

  self.servantName = [RETextItem itemWithTitle:@"用户姓名"
                                         value:nil
                                   placeholder:@"请输入姓名"];
  self.servantName.clearButtonMode = UITextFieldViewModeWhileEditing;

  self.sex = [REPickerItem itemWithTitle:@"性别"
                                   value:nil
                             placeholder:@"请选择您的性别"
                                 options:@[ @[ @"女", @"男" ] ]];
  self.sex.inlinePicker = YES;
    self.sex.selectionHandler = ^(REPickerItem *item){
        [weakSelf.view endEditing:YES];
    };

  self.servantMobil = [RETextItem itemWithTitle:@"手机号码"
                                          value:nil
                                    placeholder:@"请输入您的联系电话"];
  self.servantMobil.keyboardType = UIKeyboardTypePhonePad;
  self.servantMobil.clearButtonMode = UITextFieldViewModeWhileEditing;

  self.qqNumber = [RETextItem itemWithTitle:@"QQ帐号"
                                      value:nil
                                placeholder:@"请输入您的QQ帐号"];
  self.qqNumber.keyboardType = UIKeyboardTypeNumberPad;
  self.qqNumber.clearButtonMode = UITextFieldViewModeWhileEditing;

  self.userPwd =
      [RETextItem itemWithTitle:@"登录密码"
                          value:nil
                    placeholder:@"请输入6~18位字母数字组合密码"];
  self.userPwd.secureTextEntry = YES;
  self.userPwd.clearButtonMode = UITextFieldViewModeWhileEditing;

  self.confirmPwd = [RETextItem itemWithTitle:@"确认密码"
                                        value:nil
                                  placeholder:@"请再次输入密码"];
  self.confirmPwd.secureTextEntry = YES;
  self.confirmPwd.clearButtonMode = UITextFieldViewModeWhileEditing;


  [section addItem:self.servantID];
  [section addItem:self.idCardNo];
  [section addItem:self.servantName];
  [section addItem:self.sex];
  [section addItem:self.servantMobil];
  [section addItem:self.qqNumber];
  [section addItem:self.userPwd];
  [section addItem:self.confirmPwd];

  // 表尾
  HSInfoFooterView *footerView = [HSInfoFooterView footerView];
  UIView *blankView =
      [[UIView alloc] initWithFrame:CGRectMake(0, 0, XBScreenWidth, 90)];
  HSOrangeButton *nextBtn = [HSOrangeButton orangeButtonWithTitle:@"下一步"];
  CGFloat buttonX = 10;
  CGFloat buttonW = blankView.frame.size.width - 2 * buttonX;
  CGFloat buttonH = 50;
  CGFloat buttonY = blankView.frame.size.height * 0.5 - buttonH * 0.5;
  nextBtn.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
  nextBtn.enabled = YES;
  nextBtn.alpha = 1;
  [nextBtn addTarget:self
                action:@selector(nextBtnClicked)
      forControlEvents:UIControlEventTouchUpInside];
  [blankView addSubview:nextBtn];
  [footerView addSubview:blankView];
  self.tableView.tableFooterView = footerView;
  _nextBtn = nextBtn;

  return section;
}

- (void)nextBtnStateChange{
    // 创建信号
    RACSignal *validservantID =
    [RACObserve(self.servantID, value) map:^id(id value) {
        return @([self isValidTextlength:value]);
    }];
    
    RACSignal *validIdCardNo =
    [RACObserve(self.idCardNo, value) map:^id(id value) {
        return @([self isValidTextlength:value]);
    }];
    
    RACSignal *validServantName =
    [RACObserve(self.servantName, value) map:^id(id value) {
        return @([self isValidTextlength:value]);
    }];
    
    RACSignal *validSex = [RACObserve(self.sex, value) map:^id(id value) {
        return @([self isVaildPickerValue:value]);
    }];
    
    RACSignal *validServantMobil =
    [RACObserve(self.servantMobil, value) map:^id(id value) {
        return @([self isValidTextlength:value]);
    }];
    
    RACSignal *validQQNumber =
    [RACObserve(self.qqNumber, value) map:^id(id value) {
        return @([self isValidTextlength:value]);
    }];
    
    RACSignal *validUserPwd = [RACObserve(self.userPwd, value) map:^id(id value) {
        return @([self isValidTextlength:value]);
    }];
    
    RACSignal *validConfirmPwd =
    [RACObserve(self.confirmPwd, value) map:^id(id value) {
        return @([self isValidTextlength:value]);
    }];
    
  RACSignal *nextBtnActiveSignal = [RACSignal combineLatest:@[
    validservantID,
    validIdCardNo,
    validServantName,
    validSex,
    validServantMobil,
    validQQNumber,
    validUserPwd,
    validConfirmPwd
  ] reduce:^id(NSNumber *servantIDValid, NSNumber *idCardNoValid,
               NSNumber *servantNameValid, NSNumber *sexValid,
               NSNumber *servantMobilValid, NSNumber *qqNumberValid,
               NSNumber *userPwdValid, NSNumber *confirmPwdValid) {
    return @([servantIDValid boolValue] && [idCardNoValid boolValue] &&
             [servantNameValid boolValue] && [sexValid boolValue] &&
             [servantMobilValid boolValue] && [qqNumberValid boolValue] &&
             [userPwdValid boolValue] && [confirmPwdValid boolValue]);
  }];

  [nextBtnActiveSignal subscribeNext:^(NSNumber *loginActive) {
    _nextBtn.enabled = [loginActive boolValue];
    _nextBtn.alpha = 1;
  }];


}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView
    willLayoutCellSubviews:(UITableViewCell *)cell
         forRowAtIndexPath:(NSIndexPath *)indexPath {
  for (UIView *view in cell.contentView.subviews) {
    if ([view isKindOfClass:[UILabel class]] ||
        [view isKindOfClass:[UITextField class]]) {
      ((UILabel *)view).font = [UIFont systemFontOfSize:14];
      ((UILabel *)view).textColor = [UIColor darkGrayColor];
      ((UILabel *)view).textAlignment = NSTextAlignmentLeft;
      if ([view isKindOfClass:[UITextField class]]) {
        CGRect temp = ((UILabel *)view).frame;
        temp.origin.x = 86;
        ((UILabel *)view).frame = temp;
      }
    }
  }
  if ([cell isKindOfClass:[RETableViewPickerCell class]]) {
      RETableViewPickerCell *pickerCell = (RETableViewPickerCell *)cell;
      pickerCell.placeholderLabel.textColor = XBMakeColorWithRGB(194, 194, 200, 1);
    for (UIView *view in cell.contentView.subviews) {
      UILabel *lable = (UILabel *)view;
      if (lable.frame.origin.x > 90.0) {
        CGRect temp = lable.frame;
        temp.origin.x = 86;
        lable.frame = temp;
      }
    }
  }
}

/**
 *  下一步按钮点击
 */
- (void)nextBtnClicked {
      MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view
      animated:YES];
      hud.labelText = @"请稍等";
    // 数据体
    NSMutableDictionary *attrParams = [NSMutableDictionary dictionary];
    attrParams[@"servantID"] = self.servantID.value;
    
        [[HS_NetAPIManager sharedManager]request_Register_CheckServantIDWithParams:attrParams andBlock:^(id data, NSError *error) {
            [hud hide:YES];
            if (data) {
                if ([(NSString *)data isEqualToString:@"Failed"]) {
                    [NSObject showHudTipStr:@"用户名被占用"];
                }else{
                    [self verifyValidInfo];
                }
            }else{
                [NSObject showHudTipStr:@"似乎断开与服务器的连接"];
            }
        }];
}

- (void)verifyValidInfo{
    NSArray *basicInfoArray = @[
                                self.servantID.value,
                                self.idCardNo.value,
                                self.servantName.value,
                                [self.sex.value lastObject],
                                self.servantMobil.value,
                                self.qqNumber.value,
                                self.userPwd.value,
                                self.confirmPwd.value
                                ];

    if (![HSVerify verifyIDCardNumber:self.idCardNo
          .value]) { //身份证号不正确
        [NSObject showHudTipStr:@"请输入正确的身份证号码"];
    } else if (![HSVerify verifyPhoneNumber:self.servantMobil.value]) {
        [NSObject showHudTipStr:@"请输入正确的手机号码"];
    } else if (![HSVerify verifyPassword:self.userPwd.value]) {
        [NSObject showHudTipStr:@"输入6-18位数字和字母组合密码"];
    } else if (![self.userPwd.value
                 isEqualToString:self.confirmPwd.value]) {
        [NSObject showHudTipStr:@"请输入相同的密码"];
    } else {
        HSFinalRegistViewController *finalRegistVc =
        [[HSFinalRegistViewController alloc] init];
        finalRegistVc.basicInfoArray = basicInfoArray;
        [self.navigationController pushViewController:finalRegistVc
                                             animated:YES];
    }
}

@end
