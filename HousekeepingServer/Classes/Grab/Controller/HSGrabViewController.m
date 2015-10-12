//
//  HSGrabViewController.m
//  HousekeepingService
//
//  Created by Jacob on 15/9/19.
//  Copyright (c) 2015年 com.jacob. All rights reserved.
//

#import "HSGrabViewController.h"
#import "HSNavBarBtn.h"
#import "HSDropListViewController.h"
#import "HSRegion.h"
#import "MJExtension.h"
#import "XBConst.h"
#import "HSHTTPRequestOperationManager.h"
#import "AFNetworking.h"
#import "HSService.h"
#import "HSCollectionView.h"
#import "HSCollectionViewCell.h"
#import "HSCoveredCountry.h"
#import "MBProgressHUD+MJ.h"
#import "HSSubService.h"
#import "HSRefreshButton.h"
#import "HSSubServiceViewController.h"
#import "HSNavigationViewController.h"
#import "HSServiceDeclare.h"
#import "HSDeclareCell.h"
#import "MJRefresh.h"
#import "HSRefreshLab.h"

#define RegionStrKey @"region"
#define ServiceStrKey @"service"
@interface HSGrabViewController () <
    UICollectionViewDataSource, UICollectionViewDelegate,
    UICollectionViewDelegateFlowLayout, HSCollectionViewCellDelegate,
    HSSubServiceViewDelegate, UIAlertViewDelegate, HSDeclareCellDelegate> {
  MBProgressHUD *hud;
}
@property(strong, nonatomic) NSArray *regions;
@property(strong, nonatomic) NSArray *service;
@property(strong, nonatomic) NSArray *subService;
@property(strong, nonatomic) NSArray *serviceDeclare;

@property(weak, nonatomic) UIButton *bgBtn; // 半透明背景

@property(weak, nonatomic) HSNavBarBtn *leftNavBtn;
@property(weak, nonatomic) HSNavBarBtn *rightNavBtn;

@property(weak, nonatomic) UIButton *selectedRegionBtn;
@property(strong, nonatomic) HSCollectionView *regionCollectionView;
@property(weak, nonatomic) UIButton *selectedServiceBtn;
@property(strong, nonatomic) HSCollectionView *serviceCollectionView;

@property(strong, nonatomic) HSRefreshButton *regionRefreshButton;
@property(strong, nonatomic) HSRefreshButton *serviceRefreshButton;

@property(copy, nonatomic) NSString *regionStr;
@property(copy, nonatomic) NSString *serviceStr;

@property(strong, nonatomic) UIWebView *webView; // 用来打电话

@property(strong, nonatomic) HSRefreshLab *refreshLab; // 刷新失败后现实的label

@end

@implementation HSGrabViewController
#pragma mark - getter
- (HSCollectionView *)regionCollectionView {
  if (!_regionCollectionView) {
    _regionCollectionView = [HSCollectionView collectionView];
  }
  return _regionCollectionView;
}

- (HSCollectionView *)serviceCollectionView {
  if (!_serviceCollectionView) {
    _serviceCollectionView = [HSCollectionView collectionView];
  }
  return _serviceCollectionView;
}

- (HSRefreshButton *)regionRefreshButton {
  if (!_regionRefreshButton) {
    _regionRefreshButton = [HSRefreshButton refreshButton];
    [_regionRefreshButton addTarget:self
                             action:@selector(loadRegions)
                   forControlEvents:UIControlEventTouchUpInside];
  }
  return _regionRefreshButton;
}

- (HSRefreshButton *)serviceRefreshButton {
  if (!_serviceRefreshButton) {
    _serviceRefreshButton = [HSRefreshButton refreshButton];
    [_serviceRefreshButton addTarget:self
                              action:@selector(loadService)
                    forControlEvents:UIControlEventTouchUpInside];
  }
  return _serviceRefreshButton;
}

#pragma mark - tableView样式
- (instancetype)init {
  self = [super init];
  if (self) {
    return [super initWithStyle:UITableViewStyleGrouped];
  }
  return self;
}

- (id)initWithStyle:(UITableViewStyle)style {
  return [super initWithStyle:UITableViewStyleGrouped];
}

#pragma mark - view加载
- (void)viewDidLoad {
  // 添加导航栏按钮
  [self setupNavBarBtn];
  // 设置tableView样式
  self.tableView.rowHeight = 330;
  self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    // 刷新表格
    if (self.regionStr && self.serviceStr) {
        [self setupRefreshView];
    }
  [super viewDidLoad];

  // Do any additional setup after loading the view.
}
/**
 *  加载region
 */
- (void)loadRegions {
  // 将原来加载按钮取消
  [self.regionRefreshButton removeFromSuperview];
  // weak self,否则block中循环引用
  __weak HSGrabViewController *grabSelf = self;
  // 将_region置空
  _regions = nil;
  [self.regionCollectionView reloadData];
  // 隐藏所有HUD
  [MBProgressHUD hideAllHUDsForView:self.regionCollectionView animated:YES];
  // 创建hud
  hud = [MBProgressHUD showHUDAddedTo:self.regionCollectionView animated:YES];
  hud.labelText = @"正在加载";

  AFHTTPRequestOperationManager *manager =
      (AFHTTPRequestOperationManager *)[HSHTTPRequestOperationManager manager];
  NSMutableDictionary *regionAttrDict = [NSMutableDictionary dictionary];
  regionAttrDict[@"cityCode"] = @"C037";
  NSString *regionUrlStr =
      [NSString stringWithFormat:@"%@/MobileCountyInfoAction?operation=_query",
                                 kHSBaseURL];
  [manager POST:regionUrlStr
      parameters:regionAttrDict
      success:^(AFHTTPRequestOperation *_Nonnull operation,
                id _Nonnull responseObject) {
        [MBProgressHUD hideHUDForView:self.regionCollectionView animated:YES];
        if ([kServiceResponse isEqualToString:@"Success"]) {
          [hud hide:YES afterDelay:1.0];
          hud.completionBlock = ^{
            _regions =
                [HSCoveredCountry objectArrayWithKeyValuesArray:kDataResponse];
            [grabSelf.regionCollectionView reloadData];
          };

        } else {
          _regions = nil;
          hud.mode = MBProgressHUDModeCustomView;
          hud.labelText = @"加载失败";
          hud.customView = MBProgressHUDErrorView;
          [hud hide:YES afterDelay:1.0];
          hud.completionBlock = ^{
            grabSelf.regionRefreshButton.center =
                grabSelf.regionCollectionView.center;
            grabSelf.regionRefreshButton.bounds = CGRectMake(0, 0, 100, 50);
            [grabSelf.regionCollectionView
                addSubview:grabSelf.regionRefreshButton];
          };
        }
      }
      failure:^(AFHTTPRequestOperation *_Nonnull operation,
                NSError *_Nonnull error) {
        _regions = nil;
        hud.mode = MBProgressHUDModeCustomView;
        hud.labelText = @"网络错误";
        hud.customView = MBProgressHUDErrorView;
        [hud hide:YES afterDelay:1.0];
        hud.completionBlock = ^{
          grabSelf.regionRefreshButton.center =
              grabSelf.regionCollectionView.center;
          grabSelf.regionRefreshButton.bounds = CGRectMake(0, 0, 100, 50);
          [grabSelf.regionCollectionView
              addSubview:grabSelf.regionRefreshButton];
        };

        XBLog(@"failure:%@", error);
      }];
}
/**
 *   加载服务
 */
- (void)loadService {
  // 将原来加载按钮取消
  [self.serviceRefreshButton removeFromSuperview];
  // weak self,否则block中循环引用
  __weak HSGrabViewController *grabSelf = self;
  // 将_region置空
  _service = nil;
  [self.serviceCollectionView reloadData];
  // 隐藏所有HUD
  [MBProgressHUD hideAllHUDsForView:self.serviceCollectionView animated:YES];
  // 创建hud
  hud = [MBProgressHUD showHUDAddedTo:self.serviceCollectionView animated:YES];
  hud.labelText = @"正在加载";
  //    hud.dimBackground = YES;

  AFHTTPRequestOperationManager *manager =
      (AFHTTPRequestOperationManager *)[HSHTTPRequestOperationManager manager];
  NSMutableDictionary *serviceAttrDict = [NSMutableDictionary dictionary];
  serviceAttrDict[@"typeName"] = @"";
  NSString *serviceUrlStr =
      [NSString stringWithFormat:@"%@/MobileServiceTypeAction?operation=_query",
                                 kHSBaseURL];
  [manager POST:serviceUrlStr
      parameters:serviceAttrDict
      success:^(AFHTTPRequestOperation *_Nonnull operation,
                id _Nonnull responseObject) {
        if ([kServiceResponse isEqualToString:@"Success"]) {
          [hud hide:YES afterDelay:1.0];
          hud.completionBlock = ^{
            _service = [HSService objectArrayWithKeyValuesArray:kDataResponse];
            [grabSelf.serviceCollectionView reloadData];
          };

        } else {
          _service = nil;
          hud.mode = MBProgressHUDModeCustomView;
          hud.labelText = @"加载失败";
          hud.customView = MBProgressHUDErrorView;
          [hud hide:YES afterDelay:1.0];
          hud.completionBlock = ^{
            grabSelf.serviceRefreshButton.center =
                grabSelf.serviceCollectionView.center;
            grabSelf.serviceRefreshButton.bounds = CGRectMake(0, 0, 100, 50);
            [grabSelf.serviceCollectionView
                addSubview:grabSelf.serviceRefreshButton];
          };
        }
      }
      failure:^(AFHTTPRequestOperation *_Nonnull operation,
                NSError *_Nonnull error) {
        _service = nil;
        hud.mode = MBProgressHUDModeCustomView;
        hud.labelText = @"网络错误";
        hud.customView = MBProgressHUDErrorView;
        [hud hide:YES afterDelay:1.0];
        hud.completionBlock = ^{
          grabSelf.serviceRefreshButton.center =
              grabSelf.serviceCollectionView.center;
          grabSelf.serviceRefreshButton.bounds = CGRectMake(0, 0, 100, 50);
          [grabSelf.serviceCollectionView
              addSubview:grabSelf.serviceRefreshButton];
        };
      }];
}
/**
 *  view消失时调用
 */
- (void)viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];
  self.leftNavBtn.selected = NO;
  self.rightNavBtn.selected = NO;
  [self bgBtnClicked];
}

/**
 *  view即将显示时调用
 */
- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  self.tableView.backgroundColor = XBMakeColorWithRGB(234, 234, 234, 1);
}

#pragma mark - 导航栏
/**
 *  设置navBar的左右按钮
 */
- (void)setupNavBarBtn {
  // 左边选区的按钮
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *leftStr = [defaults objectForKey:RegionStrKey];
    self.regionStr = leftStr;
    if (!leftStr) {
        leftStr = @"选择地区";
    }
  HSNavBarBtn *leftNavBtn =
      [HSNavBarBtn navBarBtnWithTitle:leftStr
                                image:@"navigation_city_fold"
                     highlightedImage:@"navigation_city_fold_highlighted"
                        selectedImage:@"navigation_city_unfold"];
  leftNavBtn.frame = CGRectMake(0, 0, 70, 20);
  self.leftNavBtn = leftNavBtn;
  self.navigationItem.leftBarButtonItem =
      [[UIBarButtonItem alloc] initWithCustomView:self.leftNavBtn];
  [leftNavBtn addTarget:self
                 action:@selector(navBtnClicked:)
       forControlEvents:UIControlEventTouchUpInside];

  // 右边选区的按钮
    NSString *rightStr = [defaults objectForKey:ServiceStrKey];
    self.serviceStr = rightStr;
    if (!rightStr) {
        rightStr = @"选择服务";
    }

  HSNavBarBtn *rightNavBtn =
      [HSNavBarBtn navBarBtnWithTitle:rightStr
                                image:@"navigation_city_fold"
                     highlightedImage:@"navigation_city_fold_highlighted"
                        selectedImage:@"navigation_city_unfold"];
  rightNavBtn.frame = CGRectMake(0, 0, 70, 20);
  self.rightNavBtn = rightNavBtn;
  self.navigationItem.rightBarButtonItem =
      [[UIBarButtonItem alloc] initWithCustomView:self.rightNavBtn];
  [rightNavBtn addTarget:self
                  action:@selector(navBtnClicked:)
        forControlEvents:UIControlEventTouchUpInside];
}

/**
 *  导航栏按钮被点击
 *
 *  @param button 左边按钮／右边按钮
 */
- (void)navBtnClicked:(HSNavBarBtn *)button {
  button.selected = !button.selected;
  // 左边的被点击，选择地区
  if (button.selected && button == self.leftNavBtn) {
    // 关闭右边按钮
    self.rightNavBtn.selected = NO;
    [self.bgBtn removeFromSuperview];
    [self.serviceCollectionView removeFromSuperview];

    self.tableView.scrollEnabled = NO;
    // 创建背景半透明按钮
    [self setupBgButton];
    [self setupRegionCollectionView];
    [self loadRegions];

  } else if (button.selected &&
             button == self.rightNavBtn) { // 右边的被点击选择服务
    // 关闭左边按钮
    [self.bgBtn removeFromSuperview];
    [self.regionCollectionView removeFromSuperview];
    self.tableView.scrollEnabled = NO;
    self.leftNavBtn.selected = NO;
    // 创建背景半透明按钮
    [self setupBgButton];
    // 创建setupServiceCollectionView
    [self setupServiceCollectionView];
    [self loadService];
  } else { // 取消点击
    [self.bgBtn removeFromSuperview];
    [self.serviceCollectionView removeFromSuperview];
    [self.regionCollectionView removeFromSuperview];
    self.tableView.scrollEnabled = YES;
  }
}
/**
 *  设置背景按钮
 */
- (void)setupBgButton {
  UIButton *bgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
  bgBtn.frame = self.view.bounds;
  [bgBtn setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
  [self.view addSubview:bgBtn];
  self.bgBtn = bgBtn;
  [bgBtn addTarget:self
                action:@selector(bgBtnClicked)
      forControlEvents:UIControlEventTouchUpInside];
}

- (void)bgBtnClicked {
  [self.bgBtn removeFromSuperview];
  [self.regionCollectionView removeFromSuperview];
  [self.serviceCollectionView removeFromSuperview];
  self.tableView.scrollEnabled = YES;
  self.leftNavBtn.selected = NO;
  self.rightNavBtn.selected = NO;
}

#pragma mark - 创建collectionView
- (void)setupRegionCollectionView {
  CGFloat regionCollectionViewW = self.view.frame.size.width;
  CGFloat regionCollectionViewH = self.view.frame.size.height * 0.5;
  CGFloat regionCollectionViewY = self.tableView.contentOffset.y + 64;
  CGRect collectionViewF = CGRectMake(
      0, regionCollectionViewY, regionCollectionViewW, regionCollectionViewH);
  self.regionCollectionView.frame = collectionViewF;
  [self.regionCollectionView registerClass:[HSCollectionViewCell class]
                forCellWithReuseIdentifier:@"Grab"];
  [self.view addSubview:self.regionCollectionView];

  // 4.设置代理
  self.regionCollectionView.delegate = self;
  self.regionCollectionView.dataSource = self;
}

- (void)setupServiceCollectionView {
  CGFloat serviceCollectionViewW = self.view.frame.size.width;
  CGFloat serviceCollectionViewH = self.view.frame.size.height * 0.5;
  CGFloat serviceCollectionViewY = self.tableView.contentOffset.y + 64;
  CGRect collectionViewF =
      CGRectMake(0, serviceCollectionViewY, serviceCollectionViewW,
                 serviceCollectionViewH);
  self.serviceCollectionView.frame = collectionViewF;
  [self.serviceCollectionView registerClass:[HSCollectionViewCell class]
                 forCellWithReuseIdentifier:@"Grab"];
  [self.view addSubview:self.serviceCollectionView];

  // 4.设置代理
  self.serviceCollectionView.delegate = self;
  self.serviceCollectionView.dataSource = self;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return self.serviceDeclare.count;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
  return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  HSDeclareCell *cell = [HSDeclareCell cellWithTableView:tableView];
  cell.serviceDeclare = self.serviceDeclare[indexPath.section];
  cell.delegate = self;
    cell.indexPath = indexPath;
  return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  UIViewController *vc = [[UIViewController alloc] init];
  vc.view.backgroundColor = [UIColor blueColor];
  [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - CollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:
    (UICollectionView *)collectionView {
  return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
  if (collectionView == self.regionCollectionView) {
    return self.regions.count;
  } else {
    return self.service.count;
  }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  HSCollectionViewCell *cell = (HSCollectionViewCell *)
      [collectionView dequeueReusableCellWithReuseIdentifier:@"Grab"
                                                forIndexPath:indexPath];
  cell.delegate = self;
  if (collectionView == self.regionCollectionView) {
    HSCoveredCountry *region = self.regions[indexPath.item];
    NSString *regionTitle =
        [NSString stringWithFormat:@"%@", region.countyName];
    [cell.cellBtn setTitle:regionTitle forState:UIControlStateNormal];
    [cell.cellBtn addTarget:self
                     action:@selector(regionBtnClicked:)
           forControlEvents:UIControlEventTouchUpInside];
  } else {
    HSService *service = self.service[indexPath.item];
    NSString *serviceTitle =
        [NSString stringWithFormat:@"%@", service.typeName];
    [cell.cellBtn setTitle:serviceTitle forState:UIControlStateNormal];
    [cell.cellBtn addTarget:self
                     action:@selector(serviceBtnClicked:)
           forControlEvents:UIControlEventTouchUpInside];
  }

  return cell;
}

/**
 *  cell按钮点击
*/
- (void)regionBtnClicked:(UIButton *)regionBtn {
  self.selectedRegionBtn.selected = NO;
  regionBtn.selected = YES;
  self.selectedRegionBtn = regionBtn;
  // 设置导航栏按钮标题
  [self.leftNavBtn setTitle:regionBtn.titleLabel.text
                   forState:UIControlStateNormal];
  self.regionStr = regionBtn.titleLabel.text;

  // 存储所点击的区域名称
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  [defaults setObject:regionBtn.titleLabel.text forKey:RegionStrKey];
  [defaults synchronize];

  // 收回collectionView
  [self.regionCollectionView removeFromSuperview];
  [self.bgBtn removeFromSuperview];
  self.leftNavBtn.selected = NO;
  self.tableView.scrollEnabled = YES;
    
    if (self.serviceStr) {
        [self setupRefreshView];
    }
}

- (void)serviceBtnClicked:(UIButton *)serviceBtn {
  self.selectedServiceBtn.selected = NO;
  serviceBtn.selected = YES;
  self.selectedServiceBtn = serviceBtn;

  // 向服务器发送请求
  // 取回serviceType
  AFHTTPRequestOperationManager *manager =
      (AFHTTPRequestOperationManager *)[HSHTTPRequestOperationManager manager];
  NSMutableDictionary *attrDict = [NSMutableDictionary dictionary];

  if (!self.regionStr) {
    UIAlertView *alert = [[UIAlertView alloc]
            initWithTitle:@"请先选择所在地区"
                  message:
                      @"没有选择所在地区，请先选择您所在地区"
                 delegate:self
        cancelButtonTitle:@"确定"
        otherButtonTitles:nil, nil];
    [alert show];
    return;
  }
  attrDict[@"typeName"] = self.selectedServiceBtn.titleLabel.text;
  NSString *urlStr =
      [NSString stringWithFormat:@"%@/MobileServiceTypeAction?operation=_query",
                                 kHSBaseURL];
  [manager POST:urlStr
      parameters:attrDict
      success:^(AFHTTPRequestOperation *_Nonnull operation,
                id _Nonnull responseObject) {
        if ([kServiceResponse isEqualToString:@"Success"]) {
          _subService =
              [HSSubService objectArrayWithKeyValuesArray:kDataResponse];
          if (_subService.count) {
            HSSubServiceViewController *subServiceVc =
                [[HSSubServiceViewController alloc] init];
            subServiceVc.delegate = self;
            subServiceVc.titleStr =
                [NSString stringWithFormat:@"您当前所选－%@",
                                           serviceBtn.titleLabel.text];
            subServiceVc.subservice = _subService;
            HSNavigationViewController *navVc =
                [[HSNavigationViewController alloc]
                    initWithRootViewController:subServiceVc];
            [self presentViewController:navVc
                               animated:YES
                             completion:^{
                             }];
          } else {
            [self.rightNavBtn setTitle:serviceBtn.titleLabel.text
                              forState:UIControlStateNormal];
            [self.serviceCollectionView removeFromSuperview];
            [self.bgBtn removeFromSuperview];
            self.rightNavBtn.selected = NO;
            self.tableView.scrollEnabled = YES;
          }
        }
      }
      failure:^(AFHTTPRequestOperation *_Nonnull operation,
                NSError *_Nonnull error) {
        _regions = nil;
        XBLog(@"error:%@", error);
      }];
}
// 设置每个item的垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView
                                 layout:(UICollectionViewLayout *)
                                            collectionViewLayout
    minimumLineSpacingForSectionAtIndex:(NSInteger)section {
  return 20;
}

// 设置每个item的水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView
                                      layout:(UICollectionViewLayout *)
                                                 collectionViewLayout
    minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
  return 0;
}

#pragma mark - HSSubServiceViewDelegate
- (void)tableView:(UITableView *)tableView
    didClickedRowAtIndexPath:(NSIndexPath *)indexPath {
  __weak __typeof(self) weakSelf = self;
  HSSubService *subService = self.subService[indexPath.row];
  [self dismissViewControllerAnimated:YES
                           completion:^{
                             // 设置右上角按钮标题
                             self.rightNavBtn.titleLabel.text =
                                 subService.typeName;
                               
                               // 存储所选服务项目名称
                               NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                               [defaults setObject:subService.typeName forKey:ServiceStrKey];
                               [defaults synchronize];
                               
                               
                             NSLog(@"%@", subService.typeName);
                             self.serviceStr = subService.typeName;
                             [weakSelf setupRefreshView];
                             //        [self loadNewData];
                           }];
}

#pragma mark - 表格刷新
/**
 *  设置refreshView
 */
- (void)setupRefreshView {
  __weak __typeof(self) weakSelf = self;

  // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
  MJRefreshNormalHeader *header =
      [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadNewData];
      }];
  // 设置自动切换透明度(在导航栏下面自动隐藏)
  header.automaticallyChangeAlpha = YES;
  if (!self.tableView.header) {
    self.tableView.header = header;
  }
  // 马上进入刷新状态
  [self.tableView.header beginRefreshing];
}

/**
 *  加载新数据
 */
- (void)loadNewData {
  __weak __typeof(self) weakSelf = self;
  // 先移除label
  [self.refreshLab removeFromSuperview];
  // 访问服务器
  AFHTTPRequestOperationManager *manager =
      (AFHTTPRequestOperationManager *)[HSHTTPRequestOperationManager manager];
  NSMutableDictionary *attrDict = [NSMutableDictionary dictionary];
  attrDict[@"serviceCounty"] = self.regionStr;
  attrDict[@"serviceType"] = self.serviceStr;
  NSString *urlStr = [NSString
      stringWithFormat:
          @"%@/MobileServiceDeclareAction?operation=_queryserviceDeclare",
          kHSBaseURL];
  [manager POST:urlStr
      parameters:attrDict
      success:^(AFHTTPRequestOperation *_Nonnull operation,
                id _Nonnull responseObject) {
        [MBProgressHUD hideHUDForView:self.regionCollectionView animated:YES];
        if ([kServiceResponse isEqualToString:@"Success"]) {
            NSArray *declareArray = [HSServiceDeclare objectArrayWithKeyValuesArray:kDataResponse];
          _serviceDeclare =
              [[declareArray reverseObjectEnumerator]allObjects];
          [self.tableView reloadData];
          [self.tableView.header endRefreshing];
        } else {
          // 取消刷新
          [self.tableView.header endRefreshing];
          // 将serviceDeclare置空
          self.serviceDeclare = nil;
            HSRefreshLab *refreshLab = [HSRefreshLab
                refreshLabelWithText:
                    @"需求为0，请下拉刷新重试，或选择其他服务类别"];

            CGFloat labelW = XBScreenWidth;
            CGFloat labelX = 0;
            CGFloat labelY = XBScreenHeight * 0.3;
            CGFloat labelH = 20;
            refreshLab.frame = CGRectMake(labelX, labelY, labelW, labelH);
            self.refreshLab = refreshLab;
            [self.view addSubview:refreshLab];
            
          [self.tableView reloadData];
        }
      }
      failure:^(AFHTTPRequestOperation *_Nonnull operation,
                NSError *_Nonnull error) {
        XBLog(@"failure:%@", error);
        // 创建hud
        hud = [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
        hud.mode = MBProgressHUDModeCustomView;
        hud.labelText = @"网络错误";
        hud.customView = MBProgressHUDErrorView;
        [hud hide:YES afterDelay:2.0];
        hud.completionBlock = ^{
          HSRefreshLab *refreshLab = [HSRefreshLab
              refreshLabelWithText:@"无法连接服务器，请检查网络连接是否正确"];
          CGFloat labelW = XBScreenWidth;
          CGFloat labelX = 0;
          CGFloat labelY = XBScreenHeight * 0.3;
          CGFloat labelH = 20;
          refreshLab.frame = CGRectMake(labelX, labelY, labelW, labelH);
          weakSelf.refreshLab = refreshLab;
          [weakSelf.view addSubview:refreshLab];
        };
        [self.tableView reloadData];

        [self.tableView.header endRefreshing];
      }];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *_Nonnull)alertView
    clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (buttonIndex == 0) {
    [self navBtnClicked:self.leftNavBtn];
  }
}

#pragma mark - HSDeclareCellDelegate
- (void)declareCell:(HSDeclareCell *)declareCell grabButtonDidClickedAtIndexPath:(NSIndexPath *)indexPath{
    // 创建hud
    hud = [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
    hud.labelText = @"正在抢单...";
    HSServiceDeclare *serviceDeclare = self.serviceDeclare[indexPath.section];
    NSLog(@"%@", serviceDeclare);
    
    // 访问服务器
    AFHTTPRequestOperationManager *manager =
    (AFHTTPRequestOperationManager *)[HSHTTPRequestOperationManager manager];
    
    NSMutableDictionary *attrDict = [NSMutableDictionary dictionary];
    attrDict[@"id"] = [NSString stringWithFormat:@"%d", serviceDeclare.ID];
    attrDict[@"customerID"] = serviceDeclare.customerID;
    attrDict[@"customerName"] = serviceDeclare.customerName;
    attrDict[@"servantID"] = serviceDeclare.servantID;
    attrDict[@"servantName"] = serviceDeclare.servantName;
    attrDict[@"contactAddress"] = serviceDeclare.serviceAddress;
    attrDict[@"contactPhone"] = serviceDeclare.phoneNo;
    attrDict[@"servicePrice"] = serviceDeclare.salary;
    attrDict[@"serviceType"] = serviceDeclare.serviceType;
    attrDict[@"serviceContent"] = @"";
    attrDict[@"remarks"] = serviceDeclare.remarks;
    
    NSString *urlStr =
    [NSString stringWithFormat:@"%@/MobileServiceOrderAction?operation=_add",
     kHSBaseURL];
    [manager POST:urlStr
       parameters:attrDict
          success:^(AFHTTPRequestOperation *_Nonnull operation,
                    id _Nonnull responseObject) {
              if ([kServiceResponse isEqualToString:@"Success"]) {
                  // hud
                  hud.mode = MBProgressHUDModeCustomView;
                  hud.labelText = @"抢单成功";
                  hud.customView = MBProgressHUDSuccessView;
                  [hud hide:YES afterDelay:1.0];
                  // 重载数据
                  [self loadNewData];

              } else {
                  // hud
                  hud.mode = MBProgressHUDModeCustomView;
                  hud.labelText = @"抢单失败";
                  hud.customView = MBProgressHUDErrorView;
                  [hud hide:YES afterDelay:1.0];
                  NSLog(@"failed");
              }
          }
          failure:^(AFHTTPRequestOperation *_Nonnull operation,
                    NSError *_Nonnull error) {
                            // hud
              hud.mode = MBProgressHUDModeCustomView;
              hud.labelText = @"网络错误";
              hud.customView = MBProgressHUDErrorView;
              [hud hide:YES afterDelay:1.0];

            XBLog(@"error:%@", error);
          }];

    
}
@end
