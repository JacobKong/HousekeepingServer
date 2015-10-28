//
//  HSMineInfoViewController.m
//  HousekeepingServer
//
//  Created by Jacob on 15/10/15.
//  Copyright © 2015年 com.jacob. All rights reserved.
//

#import "HSMineInfoViewController.h"
#import "HSPickerView.h"
#import "HSInfoTextFieldItem.h"
#import "HSInfoLableItem.h"
#import "HSDatePickerView.h"
#import "HSHeadPictureView.h"
#import "HSProvince.h"
#import "HSAccount.h"
#import "HSAccountTool.h"
#import "HSInfoFooterView.h"
#import "HSOrangeButton.h"
#import "HSServant.h"
#import "HSServantTool.h"
#import "HSRegion.h"
#import "HSCity.h"
#import "HSInfoGroup.h"
#import "AFHTTPSessionManager.h"
#import "UIImageView+AFNetworking.h"
#import "UIImage+CircleCilp.h"
#import "UIImage+SquareImage.h"
#import "MBProgressHUD+MJ.h"
#import "AFNetworking.h"
#import "HSHTTPRequestOperationManager.h"
#import "HSVerify.h"
#import <CoreLocation/CoreLocation.h>
#import "MJExtension.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface HSMineInfoViewController () <
    HSHeadPictureViewDelegate, UIAlertViewDelegate, HSPickerViewDelegate,
    UIPickerViewDelegate, UIPickerViewDataSource, UIGestureRecognizerDelegate,
    UINavigationControllerDelegate, UIImagePickerControllerDelegate,
    UIActionSheetDelegate, CLLocationManagerDelegate> {
  HSInfoTextFieldItem *_servantID;
  HSInfoTextFieldItem *_servantName;
  HSInfoTextFieldItem *_loginPassword;
  HSInfoTextFieldItem *_confirmPassword;
  HSInfoTextFieldItem *_phoneNo;
  HSInfoTextFieldItem *_servantMobil;
  HSInfoLableItem *_location;
  HSInfoTextFieldItem *_contactAddress;
  HSInfoTextFieldItem *_qqNumber;
  HSInfoTextFieldItem *_emailAddress;
  HSInfoLableItem *_serviceItem;

  CLLocationManager *_manager;
  NSString *_realLongtitude; // 经度
  NSString *_realLatitude;   // 纬度

  NSString *_servantProvince;
  NSString *_servantCity;
  NSString *_servantCounty;

  NSAttributedString *_locationDefaultText;
  NSAttributedString *_serviceItemDeaultText;

  NSString *_fullPath;
  NSString *_headPicture;

  NSURL *_iconImageFilePath;
}
@property(strong, nonatomic) NSArray *provinces;
@property(strong, nonatomic) HSPickerView *servantPicker;
@property(strong, nonatomic) UIPickerView *servantPickerView;
@property(strong, nonatomic) NSArray *servantArray;
@property(strong, nonatomic) HSHeadPictureView *headerPictureView;
@property(strong, nonatomic) HSServant *servant;
@property(weak, nonatomic) UIButton *saveBtn;
@property(weak, nonatomic) HSInfoFooterView *footerView;
@property(weak, nonatomic) UIBarButtonItem *rightBtn;
@property(strong, nonatomic) HSInfoGroup *g0;
@property(weak, nonatomic) UIImage *oldheadPicture;
@property (assign, nonatomic)  int isSuccess;
@end

@implementation HSMineInfoViewController
#pragma mark - getter
- (NSArray *)provinces {
  if (!_provinces) {
    NSArray *dictArray =
        [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle]
                                             pathForResource:@"citydata.plist"
                                                      ofType:nil]];
    NSMutableArray *provinceDictArray = [NSMutableArray array];
    for (NSDictionary *dict in dictArray) {
      HSProvince *province = [HSProvince provinceWithDict:dict];
      [provinceDictArray addObject:province];
    }

    _provinces = provinceDictArray;
  }
  return _provinces;
}

- (HSPickerView *)servantPicker {
  if (!_servantPicker) {
    CGFloat servantPickerY = XBScreenHeight * 0.6;
    CGFloat servantPickerW = XBScreenWidth;
    CGFloat servantPickerH = XBScreenHeight * 0.4;
    // 创建pickerView
    _servantPicker = [HSPickerView picker];
    self.servantPicker.frame =
        CGRectMake(0, servantPickerY, servantPickerW, servantPickerH);
  }
  return _servantPicker;
}

- (UIPickerView *)servantPickerView {
  if (!_servantPickerView) {
    _servantPickerView = self.servantPicker.picker;
  }
  return _servantPickerView;
}

- (HSHeadPictureView *)headerPictureView {
  if (!_headerPictureView) {
    _headerPictureView = [HSHeadPictureView headPictureView];
    _headerPictureView.delegate = self;
  }
  return _headerPictureView;
}

- (HSServant *)servant {
  if (!_servant) {
    _servant = [HSServantTool servant];
  }
  return _servant;
}

#pragma mark - view加载
- (void)viewDidLoad {
  // 添加第一组
  [self setupGroup0];
  // 设置表尾
  [self setupfooterView];
  // 设置导航栏按钮
  [self setupNavBarBtn];
  // 加载头像
  [self setupHeadPictureWithServant:self.servant];
  // 通过地图获取经纬度
  [self setupLongAndLati];
  // 设置敲击手势，取消键盘
  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
      initWithTarget:self
              action:@selector(dismissKeyboard)];
  tap.delegate = self;
  [self.view addGestureRecognizer:tap];
  // 设置头部可互动
  self.headerPictureView.userInteractionEnabled = YES;
  // 设置通知，文本框文字变化则收到通知，调用textChange方法
  [[NSNotificationCenter defaultCenter]
      addObserver:self
         selector:@selector(textChange)
             name:UITextFieldTextDidChangeNotification
           object:nil];

  [super viewDidLoad];
  // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
  [self setupOriginData];
  // 加载头像
  [self setupHeadPictureWithServant:self.servant];
  [super viewWillAppear:animated];
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
  [self pickerView:self.servantPicker
      confirmButtonDidClickedOnToolBar:self.servantPicker.toolBar];
  [self.view endEditing:YES];
}

- (void)setupGroup0 {
  NSMutableDictionary *titleAttr = [NSMutableDictionary dictionary];
  titleAttr[NSFontAttributeName] = [UIFont systemFontOfSize:15];
  titleAttr[NSForegroundColorAttributeName] = [UIColor darkGrayColor];

  NSAttributedString *servantIDStr =
      [[NSAttributedString alloc] initWithString:@"您的ID"
                                      attributes:titleAttr];
  NSAttributedString *servantNameStr =
      [[NSAttributedString alloc] initWithString:@"您的姓名"
                                      attributes:titleAttr];
  NSAttributedString *phoneNoStr =
      [[NSAttributedString alloc] initWithString:@"联系电话"
                                      attributes:titleAttr];

  NSAttributedString *servantMobilStr =
      [[NSAttributedString alloc] initWithString:@"手机号码"
                                      attributes:titleAttr];

  NSAttributedString *locationStr =
      [[NSAttributedString alloc] initWithString:@"省市区"
                                      attributes:titleAttr];

  NSAttributedString *contactAddressStr =
      [[NSAttributedString alloc] initWithString:@"通讯地址"
                                      attributes:titleAttr];

  NSAttributedString *qqNumberStr =
      [[NSAttributedString alloc] initWithString:@"QQ 帐号"
                                      attributes:titleAttr];

  NSAttributedString *emailAddressStr =
      [[NSAttributedString alloc] initWithString:@"电子邮箱"
                                      attributes:titleAttr];

  NSAttributedString *serviceItemStr =
      [[NSAttributedString alloc] initWithString:@"服务项目"
                                      attributes:titleAttr];

  NSAttributedString *loginPasswordStr =
      [[NSAttributedString alloc] initWithString:@"登录密码"
                                      attributes:titleAttr];

  NSAttributedString *confirmPwdStr =
      [[NSAttributedString alloc] initWithString:@"确认密码"
                                      attributes:titleAttr];

  NSMutableDictionary *placeholderAttr = [NSMutableDictionary dictionary];
  placeholderAttr[NSFontAttributeName] = [UIFont systemFontOfSize:15];

  NSMutableDictionary *labelAttr = [NSMutableDictionary dictionary];
  labelAttr[NSFontAttributeName] = [UIFont systemFontOfSize:15];

  // placeholder

  NSAttributedString *servantIDPh = [[NSAttributedString alloc]
      initWithString:@"请输入20位以内的用户名"
          attributes:placeholderAttr];
  NSAttributedString *servantNamePh =
      [[NSAttributedString alloc] initWithString:@"请输入姓名"
                                      attributes:placeholderAttr];
  NSAttributedString *phoneNoPh =
      [[NSAttributedString alloc] initWithString:@"请输入联系电话"
                                      attributes:placeholderAttr];

  NSAttributedString *servantMobilPh =
      [[NSAttributedString alloc] initWithString:@"请输入手机号码"
                                      attributes:placeholderAttr];

  NSAttributedString *contactAddressPh =
      [[NSAttributedString alloc] initWithString:@"请输入详细通讯地址"
                                      attributes:placeholderAttr];

  NSAttributedString *qqNumberPh =
      [[NSAttributedString alloc] initWithString:@"请输入QQ 帐号"
                                      attributes:placeholderAttr];

  NSAttributedString *emailAddressPh =
      [[NSAttributedString alloc] initWithString:@"请输入电子邮箱"
                                      attributes:placeholderAttr];

  NSAttributedString *loginPasswordPh =
      [[NSAttributedString alloc] initWithString:@"请输入登录密码"
                                      attributes:placeholderAttr];

  NSAttributedString *confirmPwdPh =
      [[NSAttributedString alloc] initWithString:@"请输入相同密码"
                                      attributes:placeholderAttr];

  NSString *locationAddress = [NSString
      stringWithFormat:@"%@%@%@", self.servant.servantProvince,
                       self.servant.servantCity, self.servant.servantCounty];

  NSAttributedString *locationDefaultText =
      [[NSAttributedString alloc] initWithString:locationAddress
                                      attributes:labelAttr];
  _locationDefaultText = locationDefaultText;

  NSAttributedString *serviceItemDefaultText =
      [[NSAttributedString alloc] initWithString:self.servant.serviceItems
                                      attributes:labelAttr];
  _serviceItemDeaultText = serviceItemDefaultText;

  // item
  HSInfoTextFieldItem *servantID =
      [HSInfoTextFieldItem itemWithTitle:servantIDStr
                             placeholder:servantIDPh
                                    text:self.servant.servantID];
  servantID.mineInfoDelegateVc = self;
  _servantID = servantID;

  HSInfoTextFieldItem *servantName =
      [HSInfoTextFieldItem itemWithTitle:servantNameStr
                             placeholder:servantNamePh
                                    text:self.servant.servantName];
  servantName.mineInfoDelegateVc = self;
  _servantName = servantName;

  HSInfoLableItem *serviceItem = [HSInfoLableItem itemWithTitle:serviceItemStr];
  serviceItem.attrText = serviceItemDefaultText;
  _serviceItem = serviceItem;

  NSString *phoneNoString =
      [NSString stringWithFormat:@"%ld", self.servant.phoneNo];
  HSInfoTextFieldItem *phoneNo =
      [HSInfoTextFieldItem itemWithTitle:phoneNoStr
                             placeholder:phoneNoPh
                                    text:phoneNoString];
  phoneNo.mineInfoDelegateVc = self;
  phoneNo.keyboardtype = UIKeyboardTypePhonePad;
  _phoneNo = phoneNo;

  NSString *servantMobilString =
      [NSString stringWithFormat:@"%ld", self.servant.servantMobil];
  HSInfoTextFieldItem *servantMobil =
      [HSInfoTextFieldItem itemWithTitle:servantMobilStr
                             placeholder:servantMobilPh
                                    text:servantMobilString];
  servantMobil.mineInfoDelegateVc = self;
  servantMobil.keyboardtype = UIKeyboardTypePhonePad;
  _servantMobil = servantMobil;

  HSInfoLableItem *location = [HSInfoLableItem itemWithTitle:locationStr];
  location.attrText = locationDefaultText;
  location.option = ^{
    // 改变tableView的frame
    self.tableView.frame =
        CGRectMake(0, 0, XBScreenWidth, XBScreenHeight * 0.6);
    // 增加pickerView
    [self.tableView.superview addSubview:self.servantPicker];
    // 设置代理
    self.servantPicker.delegate = self;

    self.servantPickerView.delegate = self;
    self.servantPickerView.dataSource = self;

    // 选中第一个
    [self pickerView:self.servantPickerView didSelectRow:0 inComponent:0];
    [self pickerView:self.servantPickerView didSelectRow:0 inComponent:1];
    [self pickerView:self.servantPickerView didSelectRow:0 inComponent:2];
  };
  _location = location;

  HSInfoTextFieldItem *contactAddress =
      [HSInfoTextFieldItem itemWithTitle:contactAddressStr
                             placeholder:contactAddressPh
                                    text:self.servant.contactAddress];
  contactAddress.mineInfoDelegateVc = self;
  _contactAddress = contactAddress;

  NSString *qqNumberString =
      [NSString stringWithFormat:@"%ld", self.servant.qqNumber];
  HSInfoTextFieldItem *qqNumber =
      [HSInfoTextFieldItem itemWithTitle:qqNumberStr
                             placeholder:qqNumberPh
                                    text:qqNumberString];
  qqNumber.mineInfoDelegateVc = self;
  qqNumber.keyboardtype = UIKeyboardTypeNumberPad;
  _qqNumber = qqNumber;

  HSInfoTextFieldItem *emailAddress =
      [HSInfoTextFieldItem itemWithTitle:emailAddressStr
                             placeholder:emailAddressPh
                                    text:self.servant.emailAddress];
  emailAddress.mineInfoDelegateVc = self;
  _emailAddress = emailAddress;

  HSInfoTextFieldItem *loginPassword =
      [HSInfoTextFieldItem itemWithTitle:loginPasswordStr
                             placeholder:loginPasswordPh
                                    text:self.servant.loginPassword];
  loginPassword.secure = YES;
  loginPassword.mineInfoDelegateVc = self;
  _loginPassword = loginPassword;

  HSInfoTextFieldItem *confirmPassword =
      [HSInfoTextFieldItem itemWithTitle:confirmPwdStr
                             placeholder:confirmPwdPh
                                    text:self.servant.loginPassword];
  confirmPassword.secure = YES;
  confirmPassword.mineInfoDelegateVc = self;
  _confirmPassword = confirmPassword;

  HSInfoGroup *g0 = [[HSInfoGroup alloc] init];
  g0.items = @[
    location,
    servantID,
    servantName,
    phoneNo,
    servantMobil,
    contactAddress,
    qqNumber,
    loginPassword,
    confirmPassword
  ];
  self.g0 = g0;
  [self.data addObject:self.g0];

  // 表头
  self.tableView.tableHeaderView = self.headerPictureView;
}

- (void)setupHeadPictureWithServant:(HSServant *)servant {
  __weak __typeof(self) weakSelf = self;
  NSString *headPicture = servant.headPicture;
  NSString *pictureURLStr =
      [NSString stringWithFormat:@"%@/%@", kHSBaseURL, headPicture];
  NSURL *pictureURL = [NSURL URLWithString:pictureURLStr];
  //  NSURLRequest *request = [NSURLRequest requestWithURL:pictureURL
  //                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
  //                                       timeoutInterval:5.0];

  [self.headerPictureView.iconImg
      sd_setImageWithURL:pictureURL
        placeholderImage:[UIImage imageNamed:@"icon"]
                 options:SDWebImageRetryFailed
               completed:^(UIImage *image, NSError *error,
                           SDImageCacheType cacheType, NSURL *imageURL) {
                 NSString *picName = @"headPicture.png";
                 [weakSelf saveImage:image
                            withName:picName
                          completion:^{
                              [weakSelf.tableView reloadData];
                          }];
                 _headPicture = picName;
               }];

  //  [self.headerPictureView.iconImg setImageWithURLRequest:request
  //      placeholderImage:[UIImage imageNamed:@"icon"]
  //      success:^(NSURLRequest *_Nonnull request,
  //                NSHTTPURLResponse *_Nonnull response, UIImage *_Nonnull
  //                image) {
  //        NSString *picName = @"headPicture.png";
  //        [weakSelf saveImage:image withName:picName];
  //        _headPicture = picName;
  //      }
  //      failure:^(NSURLRequest *_Nonnull request,
  //                NSHTTPURLResponse *_Nonnull response, NSError *_Nonnull
  //                error){
  //      }];
}

/**
 *  创建footerView
 */
- (void)setupfooterView {
  HSInfoFooterView *footerView = [HSInfoFooterView footerView];
  HSOrangeButton *saveBtn =
      [HSOrangeButton orangeButtonWithTitle:@"保存并上传头像"];
  CGFloat buttonX = 10;
  CGFloat buttonW = footerView.frame.size.width - 2 * buttonX;
  CGFloat buttonH = 50;
  CGFloat buttonY = footerView.center.y - buttonH * 0.5;
  saveBtn.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
  [saveBtn setTitle:@"保存并上传头像" forState:UIControlStateNormal];
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
  MBProgressHUD *hud =
      [MBProgressHUD showHUDAddedTo:self.navigationController.view
                           animated:YES];
  hud.labelText = @"正在保存并上传";
  if (![HSVerify verifyPhoneNumber:_servantMobil.text]) {
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = @"请输入正确的手机号码";
    hud.customView = MBProgressHUDErrorView;
    [hud hide:YES afterDelay:1.0];
  } else if (![HSVerify verifyPassword:_loginPassword.text]) {
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = @"输入6-18位数字和字母组合密码";
    hud.customView = MBProgressHUDErrorView;
    [hud hide:YES afterDelay:1.0];
  } else if (![_loginPassword.text isEqualToString:_confirmPassword.text]) {
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = @"请输入相同的密码";
    hud.customView = MBProgressHUDErrorView;
    [hud hide:YES afterDelay:1.0];
  } else {
    hud.hidden = YES;
    [self updateInfo];
    // 禁止按钮点击
    [self setCellDisable];
    // 重载tableView
    [self.tableView reloadData];

    self.rightBtn.title = @"编辑";
    self.saveBtn.enabled = NO;
    self.saveBtn.hidden = YES;
  }
}

- (int)updateInfo {
  _isSuccess = 0;
  MBProgressHUD *hud =
      [MBProgressHUD showHUDAddedTo:self.navigationController.view
                           animated:YES];
  // 访问服务器
  AFHTTPRequestOperationManager *manager =
      (AFHTTPRequestOperationManager *)[HSHTTPRequestOperationManager manager];
  // 数据体
  NSMutableDictionary *attrDict = [NSMutableDictionary dictionary];
  attrDict[@"id"] = [NSString stringWithFormat:@"%d", self.servant.ID];
  attrDict[@"servantID"] = _servantID.text;
  attrDict[@"servantName"] = _servantName.text;
  attrDict[@"loginPassword"] = _loginPassword.text;
  attrDict[@"phoneNo"] = _phoneNo.text;
  attrDict[@"servantMobil"] = _servantMobil.text;
  attrDict[@"servantProvince"] = _servantProvince;
  attrDict[@"servantCity"] = _servantCity;
  attrDict[@"servantCounty"] = _servantCounty;
  attrDict[@"contactAddress"] = _contactAddress.text;
  attrDict[@"qqNumber"] = _qqNumber.text;
  attrDict[@"emailAddress"] = @"无";
  attrDict[@"realLongitude"] = _realLongtitude;
  attrDict[@"realLatitude"] = _realLatitude;

  NSString *urlStr = [NSString
      stringWithFormat:@"%@/MoblieServantRegisteAction?operation=_update",
                       kHSBaseURL];

  [manager POST:urlStr
      parameters:attrDict
      constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
        XBLog(@"%@", _iconImageFilePath);
        [formData appendPartWithFileURL:_iconImageFilePath
                                   name:@"headPicture"
                                  error:nil];
      }
      success:^(AFHTTPRequestOperation *_Nonnull operation,
                id _Nonnull responseObject) {
        NSString *serverResponse = responseObject[@"serverResponse"];
        if ([serverResponse isEqualToString:@"Success"]) {
          hud.mode = MBProgressHUDModeCustomView;
          hud.labelText = @"保存并上传成功";
          hud.customView = MBProgressHUDSuccessView;
          [hud hide:YES afterDelay:1.0];
          // 存档
          hud.completionBlock = ^{
            _servantArray =
                [HSServant objectArrayWithKeyValuesArray:kDataResponse];

            // 创建模型
            HSServant *servant = _servantArray.lastObject;
            // 存档
            [HSServantTool saveServant:servant];
          };
          _isSuccess = 1;
        } else {
          hud.mode = MBProgressHUDModeCustomView;
          hud.labelText = @"保存上传失败";
          hud.customView = MBProgressHUDErrorView;
          [hud hide:YES afterDelay:1.0];
          _isSuccess = 0;
        }
      }
      failure:^(AFHTTPRequestOperation *_Nonnull operation,
                NSError *_Nonnull error) {
        hud.mode = MBProgressHUDModeCustomView;
        hud.labelText = @"网络错误，请重新操作";
        hud.customView = MBProgressHUDErrorView;
        [hud hide:YES afterDelay:1.0];
        XBLog(@"error%@", error);
        _isSuccess = -1;
      }];
  return _isSuccess;
}
#pragma mark - 获取经纬度
- (void)setupLongAndLati {
  // 初始化定位器管理器
  CLLocationManager *manager = [[CLLocationManager alloc] init];
  _manager = manager;
  // 设置代理
  _manager.delegate = self;
  // 设置定位精确度到米
  _manager.desiredAccuracy = kCLLocationAccuracyBest;
  // 设置过滤器为无
  _manager.distanceFilter = kCLLocationAccuracyBest;
  // 开始定位
  if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {

    [_manager requestWhenInUseAuthorization];
    [_manager startUpdatingLocation];
  } else {
    [_manager startUpdatingLocation];
  }
}

#pragma mark - 导航栏按钮创建及点击
- (void)setupNavBarBtn {
  self.navigationItem.leftBarButtonItem =
      [[UIBarButtonItem alloc] initWithTitle:@"注销登录"
                                       style:UIBarButtonItemStyleDone
                                      target:self
                                      action:@selector(logoutBtnClicked)];

  self.navigationItem.rightBarButtonItem =
      [[UIBarButtonItem alloc] initWithTitle:@"编辑"
                                       style:UIBarButtonItemStyleDone
                                      target:self
                                      action:@selector(editBtnClicked)];
  self.rightBtn = self.navigationItem.rightBarButtonItem;
}

- (void)logoutBtnClicked {
  // 删除本地账户
  [HSAccountTool removeAccount];
  UIAlertView *alert = [[UIAlertView alloc]
          initWithTitle:@"您确定退出吗？"
                message:@"退" @"出"
                @"后您可能无法收到订单消息，您确定退出吗？"
               delegate:self
      cancelButtonTitle:@"取消"
      otherButtonTitles:@"确定退出", nil];
  alert.delegate = self;
  [alert show];
}

- (void)editBtnClicked {
  self.saveBtn.hidden = !self.saveBtn.hidden;
  self.saveBtn.enabled = !self.saveBtn.enabled;

  if ([self.rightBtn.title isEqualToString:@"取消"]) {
    self.rightBtn.title = @"编辑";

    [self setupOriginData];
    [self setCellDisable];
    [self pickerView:self.servantPicker
        cancelButtonDidClickedOnToolBar:self.servantPicker.toolBar];
    [self.tableView reloadData];
  } else {

    self.rightBtn.title = @"取消";
    [self setCellEnable];
    [self.tableView reloadData];
  }
}
/**
 *  设置为原始数据
 */
- (void)setupOriginData {
  _servantProvince = self.servant.servantProvince;
  _servantCity = self.servant.servantCity;
  _servantCounty = self.servant.servantCounty;
  NSString *locationAddress =
      [NSString stringWithFormat:@"%@%@%@", _servantProvince, _servantCity,
                                 _servantCounty];

  _location.text = locationAddress;
  _servantID.text = self.servant.servantID;
  _servantName.text = self.servant.servantName;

  NSString *phoneNoString =
      [NSString stringWithFormat:@"%ld", self.servant.phoneNo];
  _phoneNo.text = phoneNoString;

  NSString *servantMobilString =
      [NSString stringWithFormat:@"%ld", self.servant.servantMobil];
  _servantMobil.text = servantMobilString;
  _contactAddress.text = self.servant.contactAddress;
  _qqNumber.text = [NSString stringWithFormat:@"%ld", self.servant.qqNumber];
  _loginPassword.text = self.servant.loginPassword;
  _confirmPassword.text = self.servant.loginPassword;

  [self.tableView reloadData];
}

- (void)setCellEnable {
  _servantName.enable = YES;
  //  _servantID.enable = YES;
  _phoneNo.enable = YES;
  _servantMobil.enable = YES;
  _location.enable = YES;
  _contactAddress.enable = YES;
  _qqNumber.enable = YES;
  _emailAddress.enable = YES;
  _loginPassword.enable = YES;
  _confirmPassword.enable = YES;
}

- (void)setCellDisable {
  _servantName.enable = NO;
  _servantID.enable = NO;
  _phoneNo.enable = NO;
  _servantMobil.enable = NO;
  _location.enable = NO;
  _contactAddress.enable = NO;
  _qqNumber.enable = NO;
  _emailAddress.enable = NO;
  _loginPassword.enable = NO;
  _confirmPassword.enable = NO;
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(nonnull NSArray<CLLocation *> *)locations {
  CLLocation *newLocaltion = locations.lastObject;
  // 记录经度
  _realLongtitude =
      [NSString stringWithFormat:@"%lf", newLocaltion.coordinate.longitude];
  // 记录纬度
  _realLatitude =
      [NSString stringWithFormat:@"%lf", newLocaltion.coordinate.latitude];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView
    clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (buttonIndex == 1) {
    // 跳到登录界面
    HSLoginViewController *loginVc = [[HSLoginViewController alloc] init];
    [self presentViewController:loginVc animated:YES completion:nil];
  }
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
  return 3;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component {
  if (component == 0) {
    return self.provinces.count;
  } else if (component == 1) {
    NSInteger selectedIndex = [self.servantPickerView selectedRowInComponent:0];
    HSProvince *province = self.provinces[selectedIndex];
    return province.citylist.count;
  } else {
    NSInteger proSelectedIndex =
        [self.servantPickerView selectedRowInComponent:0];
    HSProvince *province = self.provinces[proSelectedIndex];
    NSInteger citySelectedIndex =
        [self.servantPickerView selectedRowInComponent:1];
    HSCity *city = province.citylist[citySelectedIndex];
    return city.arealist.count;
  }
}

#pragma mark - UIPickerViewDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component {
  if (component == 0) {
    HSProvince *province = self.provinces[row];
    return province.provinceName;
  } else if (component == 1) {
    NSInteger selectedIndex = [self.servantPickerView selectedRowInComponent:0];
    HSProvince *province = self.provinces[selectedIndex];
    HSCity *city = province.citylist[row];
    return city.cityName;
  } else {
    NSInteger proSelectedIndex =
        [self.servantPickerView selectedRowInComponent:0];
    HSProvince *province = self.provinces[proSelectedIndex];
    NSInteger citySelectedIndex =
        [self.servantPickerView selectedRowInComponent:1];
    HSCity *city = province.citylist[citySelectedIndex];
    HSRegion *region = city.arealist[row];
    return region.areaName;
  }
}

- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component {
  if (component == 0) {
    [pickerView reloadComponent:1];
    [pickerView reloadComponent:2];

    HSProvince *province = self.provinces[row];
    _servantProvince = province.provinceName;

    // 让第1列滚动到第0行
    [pickerView selectRow:0 inComponent:1 animated:YES];
    [self pickerView:pickerView didSelectRow:0 inComponent:1];
  } else if (component == 1) {
    [pickerView reloadComponent:2];
    NSInteger selectedIndex = [self.servantPickerView selectedRowInComponent:0];
    HSProvince *province = self.provinces[selectedIndex];
    HSCity *city = province.citylist[row];
    _servantCity = city.cityName;
    // 让第2列滚动到第0行
    [pickerView selectRow:0 inComponent:2 animated:YES];
    [self pickerView:pickerView didSelectRow:0 inComponent:2];
  } else {
    NSInteger proSelectedIndex =
        [self.servantPickerView selectedRowInComponent:0];
    HSProvince *province = self.provinces[proSelectedIndex];
    NSInteger citySelectedIndex =
        [self.servantPickerView selectedRowInComponent:1];
    HSCity *city = province.citylist[citySelectedIndex];
    HSRegion *region = city.arealist[row];
    _servantCounty = region.areaName;
    NSString *locationString =
        [NSString stringWithFormat:@"%@%@%@", _servantProvince, _servantCity,
                                   _servantCounty];
    _location.text = locationString;
    [self.tableView reloadData];
  }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView
rowHeightForComponent:(NSInteger)component {
  return 30;
}

#pragma mark - HSPickerViewDelegate
- (void)pickerView:(HSPickerView *)pickerView
    cancelButtonDidClickedOnToolBar:(UIToolbar *)toolBar {
  [self.servantPicker removeFromSuperview];
  self.tableView.frame = CGRectMake(0, 0, XBScreenWidth, XBScreenHeight);
}

- (void)pickerView:(HSPickerView *)pickerView
    confirmButtonDidClickedOnToolBar:(UIToolbar *)toolBar {
  [self.servantPicker removeFromSuperview];
  self.tableView.frame = CGRectMake(0, 0, XBScreenWidth, XBScreenHeight);
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
      [tapPlace isEqualToString:@"UIImageView"] ||
      [tapPlace isEqualToString:@"HSHeadPictureView"]) {
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
    case 1:
      _servantID.text = textField.text;
      break;
    case 2:
      _servantName.text = textField.text;
      break;
    case 3:
      _phoneNo.text = textField.text;
      break;
    case 4:
      _servantMobil.text = textField.text;
      break;
    case 5:
      _contactAddress.text = textField.text;
      break;
    case 6:
      _qqNumber.text = textField.text;
      break;
    case 7:
      _loginPassword.text = textField.text;
      break;
    case 8:
      _confirmPassword.text = textField.text;
      break;
    }
  } else {
    switch (indexPath.row) {
    case 1:
      _servantID.text = NULL;
      break;
    case 2:
      _servantName.text = NULL;
      break;
    case 3:
      _phoneNo.text = NULL;
      break;
    case 4:
      _servantMobil.text = NULL;
      break;
    case 5:
      _contactAddress.text = NULL;
      break;
    case 6:
      _qqNumber.text = NULL;
      break;
    case 7:
      _emailAddress.text = NULL;
      break;
    case 8:
      _loginPassword.text = NULL;
      break;
    case 9:
      _confirmPassword.text = NULL;
      break;
    }
  }
  if (_servantID.text && _servantName.text && _phoneNo.text &&
      _servantMobil.text && _contactAddress.text && _qqNumber.text &&
      _emailAddress.text && _loginPassword.text && _confirmPassword) {
    _saveBtn.enabled = YES;
    _saveBtn.alpha = 1;
  } else {
    _saveBtn.enabled = NO;
    _saveBtn.alpha = 0.66;
  }
}

#pragma mark - HSHeadPictureViewDelegate
- (void)uploadButtonDidClicked {
  _saveBtn.enabled = YES;
  _saveBtn.alpha = 1;
  [self whenClickHeadImage];
}

- (void)whenClickHeadImage {

  UIActionSheet *sheet;
  sheet = [[UIActionSheet alloc] initWithTitle:@"选择头像上传"
                                      delegate:self
                             cancelButtonTitle:@"取消"
                        destructiveButtonTitle:@"从相册选择"
                             otherButtonTitles:@"从相机中选择", nil];
  sheet.tag = 255;
  sheet.actionSheetStyle = UIBarStyleBlackOpaque;
  [sheet showInView:self.view];
}

#pragma mark - actionsheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet
    clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (actionSheet.tag == 255) {
    NSUInteger sourceType = 0;
    switch (buttonIndex) {
    case 0:
      // 相册  或者 UIImagePickerControllerSourceTypePhotoLibrary
      sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
      XBLog(@"选择相册图片");
      break;
    //相机
    case 1: {
      sourceType = UIImagePickerControllerSourceTypeCamera;
      if (![UIImagePickerController
              isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIAlertView *alert =
            [[UIAlertView alloc] initWithTitle:nil
                                       message:@"Test on real device, camera "
                                       @"is not available in simulator"
                                      delegate:nil
                             cancelButtonTitle:nil
                             otherButtonTitles:@"OK", nil];
        [alert show];
        return;
      }
    } break;
    case 2:
      return;
    }
    // 跳转到相机或相册页面
    UIImagePickerController *imagePickerController =
        [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = sourceType;
    [self presentViewController:imagePickerController
                       animated:YES
                     completion:^{
                     }];
  }
}

#pragma mark - PickerController delegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
  [self dismissViewControllerAnimated:YES
                           completion:^{
                           }];
}

#pragma mark - image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info {

    MBProgressHUD *hud =
    [MBProgressHUD showHUDAddedTo:picker.view
                         animated:YES];
    hud.labelText = @"正在上传";
  UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
  NSString *picName = @"headPicture.png";
  _headPicture = picName;
  [self saveImage:image
         withName:_headPicture
       completion:^{
           [self updateInfo];
           [hud hide:YES afterDelay:2];
           hud.completionBlock = ^{
               [picker dismissViewControllerAnimated:YES
                                          completion:^{
                                              MBProgressHUD *hud =
                                              [MBProgressHUD showHUDAddedTo:self.navigationController.view
                                                                   animated:YES];
//                                              [hud hide:YES];
                                              if (_isSuccess == 1) {
                                                  
                                                  hud.mode = MBProgressHUDModeCustomView;
                                                  hud.labelText = @"上传成功";
                                                  hud.customView = MBProgressHUDSuccessView;
                                                  [hud hide:YES afterDelay:1.0];
                                              }else if (_isSuccess == 0){
                                                  hud.mode = MBProgressHUDModeCustomView;
                                                  hud.labelText = @"上传失败";
                                                  hud.customView = MBProgressHUDErrorView;
                                                  [hud hide:YES afterDelay:1.0];
                                              }else{
                                                  hud.mode = MBProgressHUDModeCustomView;
                                                  hud.labelText = @"网络错误，请重新操作";
                                                  hud.customView = MBProgressHUDErrorView;
                                                  [hud hide:YES afterDelay:1.0];
                                              }
                                          }];

           };
       }];
}

#pragma mark - 保存图片至沙盒
- (void)saveImage:(UIImage *)currentImage
         withName:(NSString *)imageName
       completion:(void (^)(void))completion {
  UIImage *squareImage =
      [UIImage scaleFromImage:currentImage toSize:CGSizeMake(100, 100)];
  NSData *imageData = UIImagePNGRepresentation(squareImage);
  // 获取沙盒目录
  _fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]
      stringByAppendingPathComponent:imageName];
  // 将图片写入文件
  XBLog(@"图片保存path:%@", _fullPath);
  [imageData writeToFile:_fullPath atomically:NO];
  NSURL *iconImageFilePath = [NSURL fileURLWithPath:_fullPath];

  UIImage *clipedImg =
      [UIImage clipImageWithData:imageData
                     borderWidth:5
                     borderColor:XBMakeColorWithRGB(234, 103, 7, 1)];

  _headerPictureView.iconImg.image = clipedImg;
  _iconImageFilePath = iconImageFilePath;
  completion();
}

@end
