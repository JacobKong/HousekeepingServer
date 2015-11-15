//
//  HSProfileInfoViewController.m
//  HousekeepingServer
//
//  Created by Jacob on 15/11/14.
//  Copyright © 2015年 com.jacob. All rights reserved.
//

#import "HSProfileInfoViewController.h"
#import "HSPickerView.h"
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
#import "AFHTTPSessionManager.h"
#import "MBProgressHUD+MJ.h"
#import "AFNetworking.h"
#import "HSHTTPRequestOperationManager.h"
#import "HSVerify.h"
#import <CoreLocation/CoreLocation.h>
#import "MJExtension.h"
#import "MBProgressHUD.h"

@interface HSProfileInfoViewController () <
HSHeadPictureViewDelegate, UIAlertViewDelegate, HSPickerViewDelegate,
UIPickerViewDelegate, UIPickerViewDataSource, UIGestureRecognizerDelegate,
UINavigationControllerDelegate, UIImagePickerControllerDelegate,
UIActionSheetDelegate, CLLocationManagerDelegate>{
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
}
@property(strong, nonatomic) RETableViewSection *personnalInfoSection;

@property(strong, nonatomic) RETableViewItem *location;
@property(strong, nonatomic) RETextItem *servantID;
@property(strong, nonatomic) RETextItem *servantName;
@property(strong, nonatomic) RETextItem *loginPassword;
@property(strong, nonatomic) RETextItem *confirmPassword;
@property(strong, nonatomic) RETextItem *phoneNo;
@property(strong, nonatomic) RETextItem *servantMobil;
@property(strong, nonatomic) RETextItem *contactAddress;
@property(strong, nonatomic) RETextItem *qqNumber;
@property(strong, nonatomic) RETextItem *emailAddress;
@property(strong, nonatomic) RETextItem *serviceItem;

@property(strong, nonatomic) NSArray *provinces;
@property(strong, nonatomic) HSPickerView *servantPicker;
@property(strong, nonatomic) UIPickerView *servantPickerView;
@property(strong, nonatomic) NSArray *servantArray;
@property(strong, nonatomic) HSHeadPictureView *headerPictureView;
@property(strong, nonatomic) HSServant *servant;
@property(weak, nonatomic) UIButton *saveBtn;
@property(weak, nonatomic) HSInfoFooterView *footerView;
@property(weak, nonatomic) UIBarButtonItem *rightBtn;
@property(weak, nonatomic) UIImage *oldheadPicture;
@property(assign, nonatomic) int isSuccess; // 上传图片是否成功
@end

@implementation HSProfileInfoViewController

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
        CGFloat servantPickerW = XBScreenWidth;
        CGFloat servantPickerH = XBScreenHeight * 0.4;
        CGFloat servantPickerY = XBScreenHeight - servantPickerH;
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
        _headerPictureView.backgroundColor = [UIColor whiteColor];
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
    [super viewDidLoad];
    // 设置标题
    self.title = @"个人资料";
    // 设置表尾
    [self setupfooterView];
    // 设置导航栏按钮
    [self setupNavBarBtn];
    // 通过地图获取经纬度
    [self setupLongAndLati];
    // 设置头部可互动
    self.headerPictureView.userInteractionEnabled = YES;
    // 设置通知，文本框文字变化则收到通知，调用textChange方法
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(textChange)
     name:UITextFieldTextDidChangeNotification
     object:nil];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 设置原始数据
    [self setupOriginData];
    self.tableView.backgroundColor = XBMakeColorWithRGB(234, 234, 234, 1);
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    // 添加第一组
    self.personnalInfoSection = [self addPersonnalInfoSection];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"正在加载";
    [hud hide:YES afterDelay:2.0];
    hud.completionBlock = ^{
        [self.tableView reloadData];
    };
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)textChange {
    self.saveBtn.enabled = YES;
}
#pragma mark - 自定义view加载
/**
 *  创建section
 */
- (RETableViewSection *)addPersonnalInfoSection {
    __typeof(&*self) __weak weakSelf = self;
    RETableViewSection *section =
    [RETableViewSection section];
    [self.manager addSection:section];
    
    NSString *locationAddress = [NSString
                                 stringWithFormat:@"%@%@%@", self.servant.servantProvince,
                                 self.servant.servantCity, self.servant.servantCounty];
    self.location = [RETableViewItem itemWithTitle:locationAddress];
    self.location.enabled = NO;
    self.location.selectionHandler = ^(RETableViewItem *item) {
        [item deselectRowAnimated:YES];
        if (weakSelf.location.enabled) {
            [weakSelf.view endEditing:YES];
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
        }
        
    };
    
    self.servantID =
    [RETextItem itemWithTitle:@"用户名" value:self.servant.servantID];
    self.servantID.enabled = NO;
    
    self.servantName = [RETextItem itemWithTitle:@"用户姓名"
                                           value:self.servant.servantName
                                     placeholder:@"请输入姓名"];
    self.servantName.enabled = NO;
    
    self.serviceItem = [RETextItem itemWithTitle:@"服务项目"
                                           value:self.servant.serviceItems];
    self.serviceItem.enabled = NO;
    
    self.phoneNo = [RETextItem
                    itemWithTitle:@"联系电话"
                    value:[NSString stringWithFormat:@"%ld", self.servant.phoneNo]
                    placeholder:@"请输入您的联系电话"];
    self.phoneNo.keyboardType = UIKeyboardTypePhonePad;
    self.phoneNo.enabled = NO;
    
    self.servantMobil = [RETextItem
                         itemWithTitle:@"手机号码"
                         value:[NSString
                                stringWithFormat:@"%ld", self.servant.servantMobil]
                         placeholder:@"请输入您的手机号码"];
    self.servantMobil.keyboardType = UIKeyboardTypePhonePad;
    self.servantMobil.enabled = NO;
    
    self.contactAddress =
    [RETextItem itemWithTitle:@"通讯地址"
                        value:self.servant.contactAddress
                  placeholder:@"请填写详细通讯地址"];
    self.contactAddress.enabled = NO;
    
    self.qqNumber = [RETextItem
                     itemWithTitle:@"QQ帐号"
                     value:[NSString stringWithFormat:@"%ld", self.servant.qqNumber]
                     placeholder:@"请输入您的QQ帐号"];
    self.qqNumber.keyboardType = UIKeyboardTypeNumberPad;
    self.qqNumber.enabled = NO;
    
    self.emailAddress =
    [RETextItem itemWithTitle:@"电子邮件"
                        value:self.servant.emailAddress
                  placeholder:@"请输入正确的电子邮件地址"];
    self.emailAddress.enabled = NO;
    
    self.loginPassword =
    [RETextItem itemWithTitle:@"登录密码"
                        value:self.servant.loginPassword
                  placeholder:@"请输入6~18位字母数字组合密码"];
    self.loginPassword.secureTextEntry = YES;
    self.loginPassword.enabled = NO;
    
    self.confirmPassword = [RETextItem itemWithTitle:@"确认密码"
                                               value:self.servant.loginPassword
                                         placeholder:@"请再次输入密码"];
    self.confirmPassword.secureTextEntry = YES;
    self.confirmPassword.enabled = NO;
    
    [section addItem:self.location];
    [section addItem:self.servantID];
    [section addItem:self.servantName];
    [section addItem:self.serviceItem];
    [section addItem:self.phoneNo];
    [section addItem:self.servantMobil];
    [section addItem:self.contactAddress];
    [section addItem:self.qqNumber];
    [section addItem:self.emailAddress];
    [section addItem:self.loginPassword];
    [section addItem:self.confirmPassword];
    
    return section;
}


/**
 *  创建footerView
 */
- (void)setupfooterView {
    HSInfoFooterView *footerView = [HSInfoFooterView footerView];
    HSOrangeButton *saveBtn =
    [HSOrangeButton orangeButtonWithTitle:@"保存资料"];
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
    [self.tableView reloadData];
}

/**
 *  导航栏按钮
 */
- (void)setupNavBarBtn {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"navigation_common_icon_close_white"] style:UIBarButtonItemStylePlain target:self action:@selector(cancelBtnClicked)];
    
    self.navigationItem.rightBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"编辑"
                                     style:UIBarButtonItemStyleDone
                                    target:self
                                    action:@selector(editBtnClicked)];
    self.rightBtn = self.navigationItem.rightBarButtonItem;
}

#pragma mark - 按钮点击
/**
 *  保存按钮点击
 */
- (void)saveBtnClicked {
    MBProgressHUD *hud =
    [MBProgressHUD showHUDAddedTo:self.navigationController.view
                         animated:YES];
    hud.labelText = @"正在保存并上传";
    if (![HSVerify verifyPhoneNumber:_servantMobil.value]) {
        hud.mode = MBProgressHUDModeCustomView;
        hud.labelText = @"请输入正确的手机号码";
        hud.customView = MBProgressHUDErrorView;
        [hud hide:YES afterDelay:1.0];
    } else if (![HSVerify verifyPassword:_loginPassword.value]) {
        hud.mode = MBProgressHUDModeCustomView;
        hud.labelText = @"输入6-18位数字和字母组合密码";
        hud.customView = MBProgressHUDErrorView;
        [hud hide:YES afterDelay:1.0];
    } else if (![_loginPassword.value isEqualToString:_confirmPassword.value]) {
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
/**
 *  上传更新信息
 *
 *  @return <#return value description#>
 */
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
    attrDict[@"servantID"] = self.servantID.value;
    attrDict[@"servantName"] = self.servantName.value;
    attrDict[@"loginPassword"] = self.loginPassword.value;
    attrDict[@"phoneNo"] = self.phoneNo.value;
    attrDict[@"servantMobil"] = self.servantMobil.value;
    attrDict[@"servantProvince"] = _servantProvince;
    attrDict[@"servantCity"] = _servantCity;
    attrDict[@"servantCounty"] = _servantCounty;
    attrDict[@"contactAddress"] = self.contactAddress.value;
    attrDict[@"qqNumber"] = self.qqNumber.value;
    attrDict[@"emailAddress"] = self.emailAddress.value;
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
/**
 *  编辑按钮点击
 */
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
 *  返回按钮点击
 */
- (void)cancelBtnClicked{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 数据相关
/**
 *  定位，经纬度
 */
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

/**
 *  设置为原始数据
 */
- (void)setupOriginData {
    [self.rightBtn setTitle:@"编辑"];
    self.saveBtn.enabled = NO;
    self.saveBtn.hidden = YES;
    
    _servantProvince = self.servant.servantProvince;
    _servantCity = self.servant.servantCity;
    _servantCounty = self.servant.servantCounty;
    NSString *locationAddress =
    [NSString stringWithFormat:@"%@%@%@", _servantProvince, _servantCity,
     _servantCounty];
    
    self.location.title = locationAddress;
    self.servantID.value = self.servant.servantID;
    self.servantName.value = self.servant.servantName;
    
    NSString *phoneNoString =
    [NSString stringWithFormat:@"%ld", self.servant.phoneNo];
    self.phoneNo.value = phoneNoString;
    
    NSString *servantMobilString =
    [NSString stringWithFormat:@"%ld", self.servant.servantMobil];
    self.servantMobil.value = servantMobilString;
    self.contactAddress.value = self.servant.contactAddress;
    self.qqNumber.value =
    [NSString stringWithFormat:@"%ld", self.servant.qqNumber];
    self.emailAddress.value = self.servant.emailAddress;
    self.loginPassword.value = self.servant.loginPassword;
    self.confirmPassword.value = self.servant.loginPassword;
    
    [self.tableView reloadData];
}

- (void)setCellEnable {
    _servantName.enabled = YES;
    _phoneNo.enabled = YES;
    _servantMobil.enabled = YES;
    _location.enabled = YES;
    _contactAddress.enabled = YES;
    _qqNumber.enabled = YES;
    _emailAddress.enabled = YES;
    _loginPassword.enabled = YES;
    _confirmPassword.enabled = YES;
}

- (void)setCellDisable {
    _servantName.enabled = NO;
    _phoneNo.enabled = NO;
    _servantMobil.enabled = NO;
    _location.enabled = NO;
    _contactAddress.enabled = NO;
    _qqNumber.enabled = NO;
    _emailAddress.enabled = NO;
    _loginPassword.enabled = NO;
    _confirmPassword.enabled = NO;
}

#pragma mark - datasouce
#pragma mark  UIPickerViewDataSource
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

#pragma mark - delegate
#pragma mark  CLLocationManagerDelegate
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

#pragma mark  RETableViewManagerDelegate
- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath {
    for (UIView *view in cell.contentView.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel *)view;
            label.textColor = [UIColor darkGrayColor];
            label.font = [UIFont systemFontOfSize:14];
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
}


#pragma mark  UIPickerViewDelegate
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
        _location.title = locationString;
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
}

- (void)pickerView:(HSPickerView *)pickerView
confirmButtonDidClickedOnToolBar:(UIToolbar *)toolBar {
    [self.servantPicker removeFromSuperview];
}
@end
