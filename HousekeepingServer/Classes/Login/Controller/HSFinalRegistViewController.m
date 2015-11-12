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
#import "HSService.h"
#import "MBProgressHUD.h"
#import "HSServiceTableViewController.h"

@interface HSFinalRegistViewController () <
    HSRegistViewContrllerDelegate, UIGestureRecognizerDelegate,
    HSPickerViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource,
    UITextFieldDelegate, CLLocationManagerDelegate, HSHeadPictureViewDelegate,
    UIActionSheetDelegate, UIImagePickerControllerDelegate,
    UINavigationControllerDelegate> {
  HSOrangeButton *_registBtn;

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

@property(strong, readwrite, nonatomic) RETableViewSection *workInfoSection;

@property(strong, nonatomic) RETableViewItem *location;
@property(strong, nonatomic) RETextItem *contactAddress;
@property(strong, nonatomic) REPickerItem *educationLevel;
@property(strong, nonatomic) RETextItem *workYears;
@property(strong, nonatomic) RETextItem *servantIntro;
@property(strong, nonatomic) REMultipleChoiceItem *serviceItems;
@property(strong, nonatomic) RETextItem *servantHonors;
@property(strong, nonatomic) REPickerItem *isStayHome;
@property(strong, nonatomic) REPickerItem *holidayInMonth;

@property(strong, nonatomic) HSPickerView *servantPicker;
@property(strong, nonatomic) UIPickerView *servantPickerView;
@property(strong, nonatomic) HSHeadPictureView *headerPictureView;

@property(strong, nonatomic) NSArray *service;
@property(strong, nonatomic) NSArray *subService;

@property(strong, nonatomic) MBProgressHUD *hud;

@property(strong, nonatomic) HSServiceTableViewController *serviceOptionVc;
@property (assign, nonatomic, getter=isUploadHeadPicture)  BOOL uploadHeadPicture;
//@property(strong, nonatomic) NSNumber *uploadHeadPicture;

@end

@implementation HSFinalRegistViewController
#pragma mark - getter
//- (NSNumber *)uploadHeadPicture{
//    if (!_uploadHeadPicture) {
//        _uploadHeadPicture = [[NSNumber alloc]initWithBool:NO];
//    }
//    return _uploadHeadPicture;
//}

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

- (HSHeadPictureView *)headerPictureView {
  if (!_headerPictureView) {
    _headerPictureView = [HSHeadPictureView headPictureView];
    _headerPictureView.delegate = self;
  }
  return _headerPictureView;
}

- (HSServiceTableViewController *)serviceOptionVc {
  if (!_serviceOptionVc) {
    _serviceOptionVc = [[HSServiceTableViewController alloc] init];
  }
  return _serviceOptionVc;
}
#pragma mark - 设置界面
- (void)viewDidLoad {
  [super viewDidLoad];
  // 标题
  self.title = @"详细信息";
  // 设置导航栏按钮
  [self setupNavBtn];
  // 通过地图获取经纬度
  [self setupLongAndLati];
  // 设置第一组
  self.workInfoSection = [self addWorkInfoSection];
  // 注册按钮状态
  [self registerBtnStateChange];
  //  [self setupGroup0];
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
- (RETableViewSection *)addWorkInfoSection {
  __typeof(&*self) __weak weakSelf = self;
  // 表头
  self.tableView.tableHeaderView = self.headerPictureView;
  RETableViewSection *section =
      [RETableViewSection sectionWithHeaderTitle:@"工作信息填写"];
  [self.manager addSection:section];

  self.location = [RETableViewItem itemWithTitle:@"省市区"];
  self.location.selectionHandler = ^(RETableViewItem *item) {
    [weakSelf.view endEditing:YES];
    //         改变tableView的frame
    //            weakSelf.tableView.frame =
    //                CGRectMake(0, 64, XBScreenWidth, XBScreenHeight * 0.6);
    // 增加pickerView
    [weakSelf.tableView.superview addSubview:weakSelf.servantPicker];
    // 设置代理
    weakSelf.servantPicker.delegate = weakSelf;

    weakSelf.servantPickerView.delegate = weakSelf;
    weakSelf.servantPickerView.dataSource = weakSelf;

    // 选中第一个
    [weakSelf pickerView:weakSelf.servantPickerView
            didSelectRow:0
             inComponent:0];
    [weakSelf pickerView:weakSelf.servantPickerView
            didSelectRow:0
             inComponent:1];
    [weakSelf pickerView:weakSelf.servantPickerView
            didSelectRow:0
             inComponent:2];

  };

  self.contactAddress =
      [RETextItem itemWithTitle:@"通讯地址"
                          value:nil
                    placeholder:@"请填写详细通讯地址"];

  self.educationLevel = [REPickerItem
      itemWithTitle:@"教育程度"
              value:nil
        placeholder:@"请选择您的受教育程度"
            options:@[
              @[ @"小学", @"初中", @"高中", @"本科", @"硕士" ]
            ]];
  self.educationLevel.inlinePicker = YES;
  self.educationLevel.selectionHandler = ^(REPickerItem *item) {
    [weakSelf.view endEditing:YES];
  };

  self.workYears = [RETextItem itemWithTitle:@"从业年限"
                                       value:nil
                                 placeholder:@"请填写从业年限"];
  self.workYears.keyboardType = UIKeyboardTypeNumberPad;

  self.servantIntro = [RETextItem itemWithTitle:@"工作介绍"
                                          value:nil
                                    placeholder:@"请简述自己的工作"];

  self.serviceItems = [REMultipleChoiceItem
         itemWithTitle:@"服务项目"
                 value:@[ @"请选择服务项目" ]
      selectionHandler:^(REMultipleChoiceItem *item) {
        [item deselectRowAnimated:YES];
        self.serviceOptionVc.item = item;
        self.serviceOptionVc.parentVc = self;
        [weakSelf.navigationController pushViewController:self.serviceOptionVc
                                                 animated:YES];
      }];

  self.servantHonors =
      [RETextItem itemWithTitle:@"所获奖项"
                          value:nil
                    placeholder:@"如果没有，请填“无"];

  self.isStayHome = [REPickerItem itemWithTitle:@"是否住家"
                                          value:nil
                                    placeholder:@"请选择是/否"
                                        options:@[ @[ @"是", @"否" ] ]];
  self.isStayHome.inlinePicker = YES;
  self.isStayHome.selectionHandler = ^(REPickerItem *item) {
    [weakSelf.view endEditing:YES];
  };

  self.holidayInMonth =
      [REPickerItem itemWithTitle:@"休息天数"
                            value:nil
                      placeholder:@"请选择每月休息天数"
                          options:@[
                            @[
                              @"0",
                              @"1",
                              @"2",
                              @"3",
                              @"4",
                              @"5",
                              @"6",
                              @"7",
                              @"8",
                              @"9",
                              @"10",
                              @"11",
                              @"12",
                              @"13",
                              @"14",
                              @"15",
                              @"16",
                              @"17",
                              @"18",
                              @"19",
                              @"20"
                            ]
                          ]];
  self.holidayInMonth.inlinePicker = YES;
  self.holidayInMonth.selectionHandler = ^(REPickerItem *item) {
    [weakSelf.view endEditing:YES];
  };

  [section addItem:self.location];
  [section addItem:self.contactAddress];
  [section addItem:self.educationLevel];
  [section addItem:self.workYears];
  [section addItem:self.servantIntro];
  [section addItem:self.serviceItems];
  [section addItem:self.servantHonors];
  [section addItem:self.isStayHome];
  [section addItem:self.holidayInMonth];

  // 表尾
  HSInfoFooterView *footerView = [HSInfoFooterView footerView];
  UIView *blankView =
      [[UIView alloc] initWithFrame:CGRectMake(0, 0, XBScreenWidth, 90)];
  HSOrangeButton *registBtn = [HSOrangeButton orangeButtonWithTitle:@"注册"];
  CGFloat buttonX = 10;
  CGFloat buttonW = blankView.frame.size.width - 2 * buttonX;
  CGFloat buttonH = 50;
  CGFloat buttonY = blankView.frame.size.height * 0.5 - buttonH * 0.5;
  registBtn.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
  registBtn.enabled = NO;
  registBtn.alpha = 0.66;
  [registBtn addTarget:self
                action:@selector(registBtnClicked)
      forControlEvents:UIControlEventTouchUpInside];
  [blankView addSubview:registBtn];
  [footerView addSubview:blankView];
  self.tableView.tableFooterView = footerView;
  _registBtn = registBtn;

  return section;
}

- (void)registerBtnStateChange {
  // 创建信号
  RACSignal *isupload =
      [RACObserve(self, uploadHeadPicture) map:^id(id value) {
        return value;
      }];

  RACSignal *validLocation =
      [RACObserve(self.location, title) map:^id(id value) {
        return @([self isValidLocation:value]);
      }];

  RACSignal *validContactAddress =
      [RACObserve(self.contactAddress, value) map:^id(id value) {
        return @([self isValidTextlength:value]);
      }];

  RACSignal *validEducationLevel =
      [RACObserve(self.educationLevel, value) map:^id(id value) {
        return @([self isVaildPickerValue:value]);
      }];

  RACSignal *validWorkYears =
      [RACObserve(self.workYears, value) map:^id(id value) {
        return @([self isValidTextlength:value]);
      }];

  RACSignal *validServantIntro =
      [RACObserve(self.servantIntro, value) map:^id(id value) {
        return @([self isValidTextlength:value]);
      }];

  RACSignal *validServiceItem =
      [RACObserve(self.serviceItems, detailLabelText) map:^id(id value) {
        return @([self isValidServiceItem:value]);
      }];

  RACSignal *validServantHonors =
      [RACObserve(self.servantHonors, value) map:^id(id value) {
        return @([self isValidTextlength:value]);
      }];

  RACSignal *validIsStayHome =
      [RACObserve(self.isStayHome, value) map:^id(id value) {
        return @([self isVaildPickerValue:value]);
      }];

  RACSignal *validHolidayInMonth =
      [RACObserve(self.holidayInMonth, value) map:^id(id value) {
        return @([self isVaildPickerValue:value]);
      }];

  RACSignal *registerBtnActiveSignal = [RACSignal combineLatest:@[
    isupload,
    validLocation,
    validContactAddress,
    validEducationLevel,
    validWorkYears,
    validServantIntro,
    validServiceItem,
    validServantHonors,
    validIsStayHome,
    validHolidayInMonth
  ] reduce:^id(NSNumber *uploadValid, NSNumber *locationValid,
               NSNumber *contactAddressValid, NSNumber *educationLevelValid,
               NSNumber *workYearsValid, NSNumber *servantIntroValid,
               NSNumber *serviceItemsValid, NSNumber *servantHonorsValid,
               NSNumber *isStayHomeValid, NSNumber *holidayInMonthValid) {
    return
        @([uploadValid boolValue] && [locationValid boolValue] &&
          [contactAddressValid boolValue] && [educationLevelValid boolValue] &&
          [workYearsValid boolValue] && [servantIntroValid boolValue] &&
          [serviceItemsValid boolValue] && [servantHonorsValid boolValue] &&
          [isStayHomeValid boolValue] && [holidayInMonthValid boolValue]);
  }];

  [registerBtnActiveSignal subscribeNext:^(NSNumber *loginActive) {
    _registBtn.enabled = [loginActive boolValue];
    _registBtn.alpha = 1;
  }];
}
// 省市区是否正确
- (BOOL)isValidLocation:(NSString *)value {
  return ![value isEqualToString:@"省市区"];
}

// 服务项目是否正确
- (BOOL)isValidServiceItem:(NSString *)value {
  return ![value isEqualToString:@"请选择服务项目"];
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath {
  for (UIView *view in cell.contentView.subviews) {
    if ([view isKindOfClass:[UILabel class]]) {
      UILabel *label = (UILabel *)view;
      if ([label.text isEqualToString:@"省市区"]) {
        label.textColor = [UIColor darkGrayColor];
        label.font = [UIFont systemFontOfSize:14];
      }
    }
  }
}

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
    pickerCell.placeholderLabel.textColor =
        XBMakeColorWithRGB(194, 194, 200, 1);

    for (UIView *view in cell.contentView.subviews) {
      UILabel *lable = (UILabel *)view;
      if (lable.frame.origin.x > 90.0) {
        CGRect temp = lable.frame;
        temp.origin.x = 86;
        lable.frame = temp;
      }
    }
  }
  if ([cell isKindOfClass:[RETableViewOptionCell class]]) {
    for (UIView *view in cell.contentView.subviews) {
      UILabel *lable = (UILabel *)view;
      if (lable.frame.origin.x > 90.0) {
        CGRect temp = lable.frame;
        temp.origin.x = 86;
        lable.frame = temp;
      }

      if ([lable.text isEqualToString:@"请选择服务项目"]) {
        lable.textColor = XBMakeColorWithRGB(194, 194, 200, 1);
      }
    }
  }
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
  attrDict[@"educationLevel"] = [self.educationLevel.value lastObject];
  attrDict[@"trainingIntro"] = @"无";
  attrDict[@"servantProvince"] = _servantProvince;
  attrDict[@"servantCity"] = _servantCity;
  attrDict[@"servantCounty"] = _servantCounty;
  attrDict[@"contactAddress"] = self.contactAddress.value;
  attrDict[@"registerLongitude"] = _registerLongitude;
  attrDict[@"registerLatitude"] = _registerLatitude;
  attrDict[@"qqNumber"] = self.basicInfoArray[5];
  attrDict[@"emailAddress"] = @"无";
  attrDict[@"servantGender"] = self.basicInfoArray[3];
  attrDict[@"workYears"] = self.workYears.value;
  attrDict[@"servantHonors"] = self.servantHonors.value;
  attrDict[@"servantIntro"] = self.servantIntro.value;
  attrDict[@"isStayHome"] = [self.isStayHome.value lastObject];
  attrDict[@"holidayInMonth"] = [self.holidayInMonth.value lastObject];
  attrDict[@"serviceItems"] = self.serviceItems.detailLabelText;
  attrDict[@"careerType"] = @"无";

  NSString *urlStr = [NSString
      stringWithFormat:@"%@/MoblieServantRegisteAction?operation=_register",
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
          [hud hide:YES];
          [MBProgressHUD showSuccess:@"注册成功，请登录"];
          dispatch_after(
              dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)),
              dispatch_get_main_queue(), ^{
                // 创建模型
                HSServant *servant = [HSServant objectWithKeyValues:attrDict];
                // 存档
                [HSServantTool saveServant:servant];

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
        XBLog(@"success%@", responseObject);

      }
      failure:^(AFHTTPRequestOperation *_Nonnull operation,
                NSError *_Nonnull error) {
        [hud hide:YES];
        [MBProgressHUD showError:@"网络错误，请重新注册"];
        dispatch_after(
            dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)),
            dispatch_get_main_queue(), ^{
              [MBProgressHUD hideHUD];
              [self dismissViewControllerAnimated:YES completion:nil];
            });

        XBLog(@"error%@", error);
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
  if ([tapPlace isEqualToString:@"UITableView"] ||
      [tapPlace isEqualToString:@"UIImageView"] ||
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
    self.location.title = locationString;
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
  //  self.tableView.frame = CGRectMake(0, 64, XBScreenWidth, XBScreenHeight);
}

- (void)pickerView:(HSPickerView *)pickerView
    confirmButtonDidClickedOnToolBar:(UIToolbar *)toolBar {
  [self.servantPicker removeFromSuperview];
  //  self.tableView.frame = CGRectMake(0, 64, XBScreenWidth, XBScreenHeight);
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
- (void)uploadButtonDidClicked {
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

  UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
  NSString *picName = @"headPicture.png";
  _headPicture = picName;
  [self saveImage:image withName:_headPicture];

  [picker dismissViewControllerAnimated:YES
                             completion:^{
                                 self.uploadHeadPicture = YES;
                             }];
}

#pragma mark - 保存图片至沙盒
- (void)saveImage:(UIImage *)currentImage withName:(NSString *)imageName {
  //读取图片数据，设置压缩系数为0.5.
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

  _headerPictureView.iconImg.image =
      [UIImage clipImageWithData:imageData
                     borderWidth:5
                     borderColor:XBMakeColorWithRGB(234, 103, 7, 1)];

  _iconImageFilePath = iconImageFilePath;
}

@end
