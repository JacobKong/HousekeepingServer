//
//  HSFinalRegistViewController.m
//  HousekeepingServer
//
//  Created by Jacob on 15/10/4.
//  Copyright © 2015年 com.jacob. All rights reserved.
//

#import "HSFinalRegistViewController.h"
#import "HSRegistViewController.h"
#import "HSInfoGroup.h"
#import "HSInfoFooterView.h"
#import "HSOrangeButton.h"
#import "HSInfoTextFieldItem.h"
#import "HSInfoLableItem.h"
#import "XBConst.h"
#import "HSPickerView.h"
#import "HSRegion.h"
#import "MJExtension.h"
#import "AFNetworking.h"
#import <CoreLocation/CoreLocation.h>
#import "HSHTTPRequestOperationManager.h"
#import "MBProgressHUD+MJ.h"
#import "HSProvince.h"
#import "HSCity.h"
#import "HSInfoHeaderView.h"
#import "HSHeadPictureView.h"
#import "UIImage+CircleCilp.h"
#import "UIImage+SquareImage.h"
#import "HSServant.h"
#import "HSServantTool.h"

@interface HSFinalRegistViewController () <
    HSRegistViewContrllerDelegate, UIGestureRecognizerDelegate,
    HSPickerViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource,
    UITextFieldDelegate, CLLocationManagerDelegate, HSHeadPictureViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
  HSOrangeButton *_registBtn;
  // 第一组
  //  HSInfoTextFieldItem *_servantProvince;
  //  HSInfoTextFieldItem *_servantCity;
  //  HSInfoLableItem *_servantCounty;
  HSInfoLableItem *_location;
  HSInfoTextFieldItem *_contactAddress;
  // 第二组
  HSInfoTextFieldItem *_educationLevel;
  HSInfoTextFieldItem *_trainingIntro;
  HSInfoTextFieldItem *_workYears;
  HSInfoTextFieldItem *_servantIntro;
  HSInfoTextFieldItem *_serviceItems;
  HSInfoTextFieldItem *_careerType;
  HSInfoTextFieldItem *_servantHonors;
  // 第三组
  HSInfoTextFieldItem *_holidayInMonth;
  HSInfoTextFieldItem *_isStayHome;
  CLLocationManager *_manager;
  NSString *_registerLongitude; // 经度
  NSString *_registerLatitude;  // 纬度

  NSString *_servantProvince;
  NSString *_servantCity;
  NSString *_servantCounty;

  NSAttributedString *_locationDefaultText;
        
        NSString *_fullPath;
        NSString *_headPicture;
        
        NSURL *_iconImageFilePath;
}
/**
 *  区县
 */
@property(strong, nonatomic) NSArray *provinces;
@property(strong, nonatomic) HSPickerView *servantPicker;
@property(strong, nonatomic) UIPickerView *servantPickerView;
@property (strong, nonatomic) HSHeadPictureView *headerPictureView;
@end

@implementation HSFinalRegistViewController
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

- (NSArray *)basicInfoArray {
  if (!_basicInfoArray) {
    _basicInfoArray = [NSArray array];
  }
  return _basicInfoArray;
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

- (HSHeadPictureView *)headerPictureView{
    if (!_headerPictureView) {
        _headerPictureView = [HSHeadPictureView headPictureView];
        _headerPictureView.delegate = self;
    }
    return _headerPictureView;
}

#pragma mark - 设置界面
- (void)viewDidLoad {
  // 标题
  self.title = @"详细信息";
  // 设置导航栏按钮
  [self setupNavBtn];
  // 通过地图获取经纬度
  [self setupLongAndLati];
  // 设置第一组
  [self setupGroup0];

  // 取消键盘
  // 设置敲击手势，取消键盘
  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
      initWithTarget:self
              action:@selector(dismissKeyboard)];
  tap.delegate = self;
  [self.view addGestureRecognizer:tap];
  [super viewDidLoad];
}

/**
 *  取消键盘
 */
- (void)dismissKeyboard {
  [self.servantPicker removeFromSuperview];
  self.tableView.frame = CGRectMake(0, 0, XBScreenWidth, XBScreenHeight);
  [self.view endEditing:YES];
}

#pragma mark - 导航栏
/**
 *设置导航栏按钮
 */
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

#pragma mark - 第一组
/**
 *  设置第一组
 */
- (void)setupGroup0 {
  // title
  NSMutableDictionary *titleAttr = [NSMutableDictionary dictionary];
  titleAttr[NSFontAttributeName] = [UIFont systemFontOfSize:15];
  titleAttr[NSForegroundColorAttributeName] = [UIColor darkGrayColor];

  NSAttributedString *locationStr =
      [[NSAttributedString alloc] initWithString:@"省、市、区"
                                      attributes:titleAttr];

  NSAttributedString *contactAddressStr =
      [[NSAttributedString alloc] initWithString:@"通讯地址"
                                      attributes:titleAttr];
  NSAttributedString *educationLevelStr =
      [[NSAttributedString alloc] initWithString:@"教育程度"
                                      attributes:titleAttr];

  NSAttributedString *trainingIntroStr =
      [[NSAttributedString alloc] initWithString:@"培训经历"
                                      attributes:titleAttr];

  NSAttributedString *workYearsStr =
      [[NSAttributedString alloc] initWithString:@"从业年限"
                                      attributes:titleAttr];

  NSAttributedString *servantIntroStr =
      [[NSAttributedString alloc] initWithString:@"工作介绍"
                                      attributes:titleAttr];

  NSAttributedString *serviceItemsStr =
      [[NSAttributedString alloc] initWithString:@"服务项目"
                                      attributes:titleAttr];

  NSAttributedString *careerTypeStr =
      [[NSAttributedString alloc] initWithString:@"职业头衔"
                                      attributes:titleAttr];

  NSAttributedString *servantHonorsStr =
      [[NSAttributedString alloc] initWithString:@"所获奖项"
                                      attributes:titleAttr];

  NSAttributedString *isStayHomeStr =
      [[NSAttributedString alloc] initWithString:@"是否住家"
                                      attributes:titleAttr];

  NSAttributedString *holidayInMonthStr =
      [[NSAttributedString alloc] initWithString:@"休息天数"
                                      attributes:titleAttr];

  // placeholder
  NSMutableDictionary *placeholderAttr = [NSMutableDictionary dictionary];
  placeholderAttr[NSFontAttributeName] = [UIFont systemFontOfSize:15];

  NSAttributedString *contactAddressPh =
      [[NSAttributedString alloc] initWithString:@"请填写详细通讯地址"
                                      attributes:placeholderAttr];

  NSAttributedString *educationLevelPh = [[NSAttributedString alloc]
      initWithString:@"请填写您的受教育程度"
          attributes:placeholderAttr];

  NSAttributedString *trainingIntroPh =
      [[NSAttributedString alloc] initWithString:@"请简要填写培训经历"
                                      attributes:placeholderAttr];

  NSAttributedString *workYearsPh =
      [[NSAttributedString alloc] initWithString:@"请填写从业年限"
                                      attributes:placeholderAttr];

  NSAttributedString *servantIntroPh =
      [[NSAttributedString alloc] initWithString:@"请简述自己的工作"
                                      attributes:placeholderAttr];

  NSAttributedString *serviceItemsPh =
      [[NSAttributedString alloc] initWithString:@"可多项，用“|”分割"
                                      attributes:placeholderAttr];

  NSAttributedString *careerTypePh = [[NSAttributedString alloc]
      initWithString:@"如果没有，请填“无”"
          attributes:placeholderAttr];

  NSAttributedString *servantHonorsPh = [[NSAttributedString alloc]
      initWithString:@"如果没有，请填“无”"
          attributes:placeholderAttr];

  NSAttributedString *isStayHomePh =
      [[NSAttributedString alloc] initWithString:@"请填写是/否"
                                      attributes:placeholderAttr];

  NSAttributedString *holidayInMonthPh = [[NSAttributedString alloc]
      initWithString:@"请填写每月休息天数(数字即可)"
          attributes:placeholderAttr];

  NSMutableDictionary *labelAttr = [NSMutableDictionary dictionary];
  labelAttr[NSFontAttributeName] = [UIFont systemFontOfSize:15];
  labelAttr[NSForegroundColorAttributeName] =
      XBMakeColorWithRGB(197, 197, 204, 1);

  NSAttributedString *locationDefaultText =
      [[NSAttributedString alloc] initWithString:@"请选择省、市、区"
                                      attributes:labelAttr];
  _locationDefaultText = locationDefaultText;

  HSInfoLableItem *location = [HSInfoLableItem itemWithTitle:locationStr];
  location.attrText = locationDefaultText;
  location.enable = YES;
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
                             placeholder:contactAddressPh];
  contactAddress.finalRegistDelegateVc = self;
  contactAddress.enable = YES;
  _contactAddress = contactAddress;

  HSInfoTextFieldItem *educationLevel =
      [HSInfoTextFieldItem itemWithTitle:educationLevelStr
                             placeholder:educationLevelPh];
  educationLevel.finalRegistDelegateVc = self;
  educationLevel.enable = YES;
  _educationLevel = educationLevel;

  HSInfoTextFieldItem *trainingIntro =
      [HSInfoTextFieldItem itemWithTitle:trainingIntroStr
                             placeholder:trainingIntroPh];
  trainingIntro.finalRegistDelegateVc = self;
  trainingIntro.enable = YES;
  _trainingIntro = trainingIntro;

  HSInfoTextFieldItem *workYears =
      [HSInfoTextFieldItem itemWithTitle:workYearsStr placeholder:workYearsPh];
  workYears.finalRegistDelegateVc = self;
  workYears.enable = YES;
  workYears.keyboardtype = UIKeyboardTypeNumberPad;
  _workYears = workYears;

  HSInfoTextFieldItem *servantIntro =
      [HSInfoTextFieldItem itemWithTitle:servantIntroStr
                             placeholder:servantIntroPh];
  servantIntro.finalRegistDelegateVc = self;
  servantIntro.enable = YES;
  _servantIntro = servantIntro;

  HSInfoTextFieldItem *serviceItems =
      [HSInfoTextFieldItem itemWithTitle:serviceItemsStr
                             placeholder:serviceItemsPh];
  serviceItems.finalRegistDelegateVc = self;
  serviceItems.enable = YES;
  _serviceItems = serviceItems;

  HSInfoTextFieldItem *careerType =
      [HSInfoTextFieldItem itemWithTitle:careerTypeStr
                             placeholder:careerTypePh];
  careerType.finalRegistDelegateVc = self;
  careerType.enable = YES;
  _careerType = careerType;

  HSInfoTextFieldItem *servantHonors =
      [HSInfoTextFieldItem itemWithTitle:servantHonorsStr
                             placeholder:servantHonorsPh];
  servantHonors.finalRegistDelegateVc = self;
  servantHonors.enable = YES;
  _servantHonors = servantHonors;

  HSInfoTextFieldItem *isStayHome =
      [HSInfoTextFieldItem itemWithTitle:isStayHomeStr
                             placeholder:isStayHomePh];
  isStayHome.finalRegistDelegateVc = self;
  isStayHome.enable = YES;
  _isStayHome = isStayHome;

  HSInfoTextFieldItem *holidayInMonth =
      [HSInfoTextFieldItem itemWithTitle:holidayInMonthStr
                             placeholder:holidayInMonthPh];
  holidayInMonth.finalRegistDelegateVc = self;
  holidayInMonth.enable = YES;
  holidayInMonth.keyboardtype = UIKeyboardTypeNumberPad;
  _holidayInMonth = holidayInMonth;

  HSInfoGroup *g0 = [[HSInfoGroup alloc] init];
  g0.items = @[
    location,
    contactAddress,
    educationLevel,
    workYears,
    servantIntro,
    serviceItems,
    servantHonors,
    isStayHome,
    holidayInMonth
  ];
  [self.data addObject:g0];
    
    // 表头
    self.tableView.tableHeaderView = self.headerPictureView;

  // 表尾
  HSInfoFooterView *footerView = [HSInfoFooterView footerView];
  HSOrangeButton *registBtn = [HSOrangeButton orangeButtonWithTitle:@"注册"];
  CGFloat buttonX = 10;
  CGFloat buttonW = footerView.frame.size.width - 2 * buttonX;
  CGFloat buttonH = 50;
  CGFloat buttonY = footerView.frame.size.height * 0.5 - buttonH * 0.5;
  registBtn.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
  registBtn.enabled = NO;
  registBtn.alpha = 0.66;
  [registBtn addTarget:self
                action:@selector(registBtnClicked)
      forControlEvents:UIControlEventTouchUpInside];
  [footerView addSubview:registBtn];
  self.tableView.tableFooterView = footerView;
  _registBtn = registBtn;
}
- (void)registBtnClicked {
  MBProgressHUD *hud = [MBProgressHUD showMessage:@"正在注册"];

  // 访问服务器
  AFHTTPRequestOperationManager *manager =
      (AFHTTPRequestOperationManager *)[HSHTTPRequestOperationManager manager];
  // 数据体
  NSMutableDictionary *attrDict = [NSMutableDictionary dictionary];
  attrDict[@"servantID"] = self.basicInfoArray[0];
  attrDict[@"idCardNo"] = self.basicInfoArray[1];
  attrDict[@"servantName"] = self.basicInfoArray[2];
  attrDict[@"loginPassword"] = self.basicInfoArray[6];
  attrDict[@"phoneNo"] = self.basicInfoArray[4];
  attrDict[@"servantMobil"] = self.basicInfoArray[4];
  attrDict[@"servantNationality"] = @"汉";
  attrDict[@"isMarried"] = @"1";
  attrDict[@"educationLevel"] = _educationLevel.text;
  attrDict[@"trainingIntro"] = @"无";
  attrDict[@"servantProvince"] = _servantProvince;
  attrDict[@"servantCity"] = _servantCity;
  attrDict[@"servantCounty"] = _servantCounty;
  attrDict[@"contactAddress"] = _contactAddress.text;
  attrDict[@"registerLongitude"] = _registerLongitude;
  attrDict[@"registerLatitude"] = _registerLatitude;
  attrDict[@"qqNumber"] = self.basicInfoArray[5];
  attrDict[@"emailAddress"] = @"无";
  attrDict[@"servantGender"] = self.basicInfoArray[3];
  attrDict[@"workYears"] = _workYears.text;
  attrDict[@"servantHonors"] = _servantHonors.text;
  attrDict[@"servantIntro"] = _servantIntro.text;
  if ([_isStayHome.text isEqualToString:@"是"]) {
    attrDict[@"isStayHome"] = @"1";
  } else {
    attrDict[@"isStayHome"] = @"0";
  }
  attrDict[@"holidayInMonth"] = _holidayInMonth.text;
  attrDict[@"serviceItems"] = _serviceItems.text;
  attrDict[@"careerType"] = @"无";

    // 创建模型
    HSServant *servant = [HSServant objectWithKeyValues:attrDict];
    NSLog(@"hs%@", servant.servantID);
    // 存档
    [HSServantTool saveServant:servant];
    
  NSString *urlStr = [NSString
      stringWithFormat:@"%@/MoblieServantRegisteAction?operation=_register",
                       kHSBaseURL];
    
    [manager POST:urlStr parameters:attrDict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSLog(@"%@", _iconImageFilePath);
        [formData appendPartWithFileURL:_iconImageFilePath name:@"headPicture" error:nil];
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSString *serverResponse = responseObject[@"serverResponse"];
        if ([serverResponse isEqualToString:@"Success"]) {
            [hud hide:YES];
            [MBProgressHUD showSuccess:@"注册成功，请登录"];
            dispatch_after(
                           dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)),
                           dispatch_get_main_queue(), ^{
                               [MBProgressHUD hideHUD];
                               [self dismissViewControllerAnimated:YES completion:nil];
                           });
        } else {
            [hud hide:YES];
            [MBProgressHUD showError:@"注册失败，请重新注册"];
            dispatch_after(
                           dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)),
                           dispatch_get_main_queue(), ^{
                               [MBProgressHUD hideHUD];
                               [self dismissViewControllerAnimated:YES completion:nil];
                           });
        }
        NSLog(@"success%@", responseObject);

    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        [hud hide:YES];
        [MBProgressHUD showError:@"网络错误，请重新注册"];
        dispatch_after(
                       dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)),
                       dispatch_get_main_queue(), ^{
                           [MBProgressHUD hideHUD];
                           [self dismissViewControllerAnimated:YES completion:nil];
                       });
        
        NSLog(@"error%@", error);
    }];
}

#pragma mark - UIGestureRecognizerDelegate
/**
 *  重写UIGestureRecognizerDelegate解决tap手势与didSelectRowAtIndexPath的冲突
 */
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
       shouldReceiveTouch:(UITouch *)touch {
  NSString *tapPlace = NSStringFromClass([touch.view class]);
  // 若为UITableView（即点击了UITableView），则截获Touch事件
    if ([tapPlace isEqualToString:@"UITableView"]||
        [tapPlace isEqualToString:@"UIImageView"]||
        [tapPlace isEqualToString:@"HSHeadPictureView"]) {
    return YES;
  }
  return NO;
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

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
  UITableViewCell *cell = (UITableViewCell *)[textField superview];
  NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
  if (![textField.text isEqualToString:@""]) {
    switch (indexPath.row) {
    case 1:
      _contactAddress.text = textField.text;
      break;
    case 2:
      _educationLevel.text = textField.text;
      break;
    case 3:
      _workYears.text = textField.text;
      break;
    case 4:
      _servantIntro.text = textField.text;
      break;
    case 5:
      _serviceItems.text = textField.text;
      break;
    case 6:
      _servantHonors.text = textField.text;
      break;
    case 7:
      _isStayHome.text = textField.text;
      break;
    case 8:
      _holidayInMonth.text = textField.text;
      break;
    }
  } else {
    switch (indexPath.row) {
    case 1:
      _contactAddress.text = NULL;
      break;
    case 2:
      _educationLevel.text = NULL;
      break;
    case 3:
      _workYears.text = NULL;
      break;
    case 4:
      _servantIntro.text = NULL;
      break;
    case 5:
      _serviceItems.text = NULL;
      break;
    case 6:
      _servantHonors.text = NULL;
      break;
    case 7:
      _isStayHome.text = NULL;
      break;
    case 8:
      _holidayInMonth.text = NULL;
      break;
    }
  }
  if (_location.text && _contactAddress.text && _educationLevel.text &&
      _workYears.text && _servantIntro.text && _serviceItems.text &&
      _servantHonors.text && _isStayHome.text && _holidayInMonth.text) {
    _registBtn.enabled = YES;
    _registBtn.alpha = 1;
  } else {
    _registBtn.enabled = NO;
    _registBtn.alpha = 0.66;
  }
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(nonnull NSArray<CLLocation *> *)locations {
  CLLocation *newLocaltion = locations.lastObject;
  // 记录经度
  _registerLongitude =
      [NSString stringWithFormat:@"%lf", newLocaltion.coordinate.longitude];
  // 记录纬度
  _registerLatitude =
      [NSString stringWithFormat:@"%lf", newLocaltion.coordinate.latitude];
}

#pragma mark - HSHeadPictureViewDelegate
- (void)uploadButtonDidClicked{
    [self whenClickHeadImage];
}

-(void)whenClickHeadImage{
    
    UIActionSheet *sheet;
    sheet = [[UIActionSheet alloc] initWithTitle:@"选择头像上传" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"从相册选择" otherButtonTitles:@"从相机中选择", nil];
    sheet.tag = 255;
    sheet.actionSheetStyle = UIBarStyleBlackOpaque;
    [sheet showInView:self.view];
}

#pragma mark - actionsheet delegate
-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 255) {
        NSUInteger sourceType = 0;
        switch (buttonIndex) {
            case 0:
                // 相册  或者 UIImagePickerControllerSourceTypePhotoLibrary
                sourceType =  UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                NSLog(@"选择相册图片");
                break;
                //相机
            case 1:
            {
                sourceType = UIImagePickerControllerSourceTypeCamera;
                if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:@"Test on real device, camera is not available in simulator" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                    [alert show];
                    return;
                }
            }
                break;
            case 2:
                return;
        }
        // 跳转到相机或相册页面
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate =self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = sourceType;
        [self presentViewController:imagePickerController animated:YES completion:^{}];
        
    }
}

#pragma mark - PickerController delegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark - image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    NSString *picName = @"headPicture.png";
    _headPicture = picName;
    [self saveImage:image withName:_headPicture];
    
    [picker dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark - 保存图片至沙盒
- (void)saveImage:(UIImage *)currentImage withName:(NSString *)imageName
{
    //读取图片数据，设置压缩系数为0.5.
    UIImage *squareImage = [UIImage scaleFromImage:currentImage toSize:CGSizeMake(100, 100)];
    NSData *imageData = UIImagePNGRepresentation(squareImage);
    // 获取沙盒目录
    _fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    // 将图片写入文件
    NSLog(@"图片保存path:%@",_fullPath);
    [imageData writeToFile:_fullPath atomically:NO];
    NSURL *iconImageFilePath = [NSURL fileURLWithPath:_fullPath];
    
    _headerPictureView.iconImg.image = [UIImage clipImageWithData:imageData borderWidth:5 borderColor:XBMakeColorWithRGB(234, 103, 7, 1)];
    
    _iconImageFilePath = iconImageFilePath;
}

@end
