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
#import "UIImage+HSResizingImage.h"
#import "HSServiceMapViewController.h"
#import "HSTitleBtn.h"

#define RegionStrKey @"region"
#define ServiceStrKey @"service"
#define StatusStrKey @"status"
@interface HSGrabViewController () <
    UICollectionViewDataSource, UICollectionViewDelegate,
    UICollectionViewDelegateFlowLayout, HSCollectionViewCellDelegate,
    HSSubServiceViewDelegate, UIAlertViewDelegate> {
  MBProgressHUD *hud;
}
@property(strong, nonatomic) NSArray *regions;
@property(strong, nonatomic) NSArray *service;
@property(strong, nonatomic) NSArray *subService;


@property(weak, nonatomic) UIButton *bgBtn; // 半透明背景

@property(weak, nonatomic) HSNavBarBtn *leftNavBtn;
@property(weak, nonatomic) HSNavBarBtn *rightNavBtn;
@property (weak, nonatomic) HSTitleBtn *titleBtn;

@property(weak, nonatomic) UIButton *selectedRegionBtn;
@property(strong, nonatomic) HSCollectionView *regionCollectionView;
@property(weak, nonatomic) UIButton *selectedServiceBtn;
@property(strong, nonatomic) HSCollectionView *serviceCollectionView;

@property(strong, nonatomic) HSRefreshButton *regionRefreshButton;
@property(strong, nonatomic) HSRefreshButton *serviceRefreshButton;

@property(copy, nonatomic) NSString *regionStr;
@property(copy, nonatomic) NSString *serviceStr;

@property (strong, nonatomic) UIView *mapBtnView;
@property (strong, nonatomic) UIButton *mapBtn;

@property (strong, nonatomic) UIImageView *bgImgView;
@property (weak, nonatomic) UITableView *statusTableView;
@property (weak, nonatomic) UILabel *statusLab;
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


- (UIButton *)mapBtn{
    if (!_mapBtn) {
        _mapBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _mapBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_mapBtn setTitle:@"地图抢单" forState:UIControlStateNormal];
        [_mapBtn setTitle:@"地图抢单" forState:UIControlStateHighlighted];
        [_mapBtn setTitleColor:XBMakeColorWithRGB(234, 103, 7, 1) forState:UIControlStateNormal];
        [_mapBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [_mapBtn setBackgroundImage:[UIImage resizeableImage:@"show_map_btn"] forState:UIControlStateNormal];
        [_mapBtn setBackgroundImage:[UIImage resizeableImage:@"show_map_btn_highlighted"] forState:UIControlStateHighlighted];
        [_mapBtn addTarget:self action:@selector(showMapView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _mapBtn;
}

- (UIView *)mapBtnView{
    if (!_mapBtnView) {
        _mapBtnView = [[UIView alloc]init];
        UIView *blackLineView = [[UIView alloc]init];
        blackLineView.frame = CGRectMake(0, 0, XBScreenWidth, 0.5);
        blackLineView.backgroundColor = [UIColor lightGrayColor];
        [_mapBtnView addSubview:blackLineView];
        CGFloat viewX = 0;
        CGFloat viewH = 49;
        CGFloat viewY = XBScreenHeight - 49 - viewH;
        CGFloat viewW = XBScreenWidth;
        _mapBtnView.frame = CGRectMake(viewX, viewY, viewW, viewH);
        
    }
    return  _mapBtnView;
}

- (UIImageView *)bgImgView{
    if (!_bgImgView) {
        CGFloat viewW = 217;
        CGFloat viewH = 110;
        CGFloat viewY = 55;
        CGFloat viewX = XBScreenWidth * 0.5 - 0.5 * viewW;
        CGRect satusFrame = CGRectMake(viewX, viewY, viewW, viewH);
        
        _bgImgView = [[UIImageView alloc]initWithImage:[UIImage resizeableImage:@"navigation_popover_background"]];
        _bgImgView.frame = satusFrame;
        _bgImgView.userInteractionEnabled = YES;
        
        CGFloat tableY = 15;
        CGFloat tableX = 10;
        CGFloat tableW = viewW - 2 * tableX;
        CGFloat tableH = 90;
        UITableView *statusTableView = [[UITableView alloc]initWithFrame:CGRectMake(tableX, tableY, tableW, tableH)];
        statusTableView.backgroundColor = [UIColor clearColor];
        statusTableView.rowHeight = 40;
        statusTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.statusTableView = statusTableView;
        self.statusTableView.dataSource = self;
        self.statusTableView.delegate = self;
        [_bgImgView addSubview:statusTableView];
    }
    return _bgImgView;
}
#pragma mark - view加载
- (void)viewDidLoad {
  // 添加导航栏按钮
  [self setupNavBarBtn];
    // 更改tableView的frame
    CGFloat tableViewH = XBScreenHeight - 49 - self.mapBtnView.frame.size.height;
    self.tableView.frame = CGRectMake(0, 0, XBScreenWidth, tableViewH);
    
  // 设置tableView样式
  self.tableView.rowHeight = 330;
  
    // 隐藏按钮
    self.leftBtnHiddn = YES;

    // 刷新表格
    if (self.regionStr && self.serviceStr) {
        [self setupRefreshView];
    }
    
    // 导航栏状态按钮标题
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *titleStr = [userDefault objectForKey:StatusStrKey];
    if (titleStr) {
        [self.titleBtn setTitle:titleStr forState:UIControlStateNormal];
    }else{
        [self.titleBtn setTitle:@"当前空闲" forState:UIControlStateNormal];
    }

  [super viewDidLoad];

  // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    // 设置地图按钮
    [self setupMapBtn];
    // 提示label
    if (!self.regionStr && !self.serviceStr) {
       UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请先选择所在地区和服务项目" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }else{
        [self.refreshLab removeFromSuperview];
    }
}

- (void)setupMapBtn{
    CGFloat buttonW = 100;
    CGFloat buttonH = 30;
    CGFloat buttonX = XBScreenWidth * 0.5 - buttonW * 0.5;
    CGFloat buttonY = self.mapBtnView.center.y - buttonH * 0.55;
    self.mapBtn.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);

    [self.view addSubview:self.mapBtnView];
    [self.view addSubview:self.mapBtn];
}

- (void)showMapView{
    HSServiceMapViewController *mapViewVc = [[HSServiceMapViewController alloc]init];
    mapViewVc.serviceDeclare = self.serviceDeclare;
    HSNavigationViewController *nav = [[HSNavigationViewController alloc]initWithRootViewController:mapViewVc];
    
    [self presentViewController:nav animated:YES completion:^{
        
    }];
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
              [grabSelf.refreshLab removeFromSuperview];
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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.regionStr && self.serviceStr) {
        [self.tableView.header beginRefreshing];
    }
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
    
    // 中间点击按钮
    HSTitleBtn *titleBtn = [HSTitleBtn titleBtn];
    [titleBtn setTitle:@"当前空闲" forState:UIControlStateNormal];
    [titleBtn setImage:[UIImage imageNamed:@"navigation_city_fold"]
              forState:UIControlStateNormal];
    [titleBtn setImage:[UIImage imageNamed:@"navigation_city_unfold"]
              forState:UIControlStateSelected];
    NSString *titleStr = titleBtn.titleLabel.text;
    CGSize titleSize = [titleStr sizeWithAttributes:@{NSFontAttributeName: [UIFont fontWithName:titleBtn.titleLabel.font.fontName size:titleBtn.titleLabel.font.pointSize]}];
    titleSize.height = 20;
    titleSize.width += 20;
    titleBtn.frame = CGRectMake(0, 0, titleSize.width, titleSize.height);
    [titleBtn addTarget:self
                 action:@selector(titleBtnClicked)
       forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = titleBtn;
    self.titleBtn = titleBtn;

}

/**
 *  导航栏中部按钮被点击
 */
- (void)titleBtnClicked{
    self.titleBtn.selected = !self.titleBtn.selected;
//    if (self.rightNavBtn.selected) {
//        [self navBtnClicked:self.rightNavBtn];
//        [self.regionCollectionView removeFromSuperview];
//    }
//    if (self.leftNavBtn.selected) {
//        [self navBtnClicked:self.leftNavBtn];
//        [self.serviceCollectionView removeFromSuperview];
//    }
//    [self.bgBtn removeFromSuperview];
    if (!self.titleBtn.selected) {
        [self.bgImgView removeFromSuperview];
    }else{
        [self.navigationController.view addSubview:self.bgImgView];
    }
    
}
/**
 *  导航栏按钮被点击
 *
 *  @param button 左边按钮／右边按钮
 */
- (void)navBtnClicked:(HSNavBarBtn *)button {
    [self.refreshLab removeFromSuperview];
    [self.bgImgView removeFromSuperview];
    
    // 如果titleBtn选中
    if (self.titleBtn.selected) {
        [self titleBtnClicked];
    }
  button.selected = !button.selected;
  // 左边的被点击，选择地区
  if (button.selected && button == self.leftNavBtn) {
          [self.refreshLab removeFromSuperview];
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
          [self.refreshLab removeFromSuperview];
    // 关闭左边按钮
      [self.refreshLab removeFromSuperview];
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
  [bgBtn setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3]];
  [self.tableView addSubview:bgBtn];
  self.bgBtn = bgBtn;
  [bgBtn addTarget:self
                action:@selector(bgBtnClicked)
      forControlEvents:UIControlEventTouchUpInside];
}

- (void)bgBtnClicked {
  [self.bgBtn removeFromSuperview];
  [self.regionCollectionView removeFromSuperview];
  [self.serviceCollectionView removeFromSuperview];
    [self.bgImgView removeFromSuperview];
  self.tableView.scrollEnabled = YES;
  self.leftNavBtn.selected = NO;
  self.rightNavBtn.selected = NO;
}

#pragma mark - 创建collectionView
- (void)setupRegionCollectionView {
  CGFloat regionCollectionViewW = self.view.frame.size.width;
  CGFloat regionCollectionViewH = self.view.frame.size.height * 0.5;
  CGFloat regionCollectionViewY = self.tableView.contentOffset.y;
  CGRect collectionViewF = CGRectMake(
      0, regionCollectionViewY, regionCollectionViewW, regionCollectionViewH);
  self.regionCollectionView.frame = collectionViewF;
  [self.regionCollectionView registerClass:[HSCollectionViewCell class]
                forCellWithReuseIdentifier:@"Grab"];
  [self.tableView addSubview:self.regionCollectionView];

  // 4.设置代理
  self.regionCollectionView.delegate = self;
  self.regionCollectionView.dataSource = self;
}

- (void)setupServiceCollectionView {
  CGFloat serviceCollectionViewW = self.view.frame.size.width;
  CGFloat serviceCollectionViewH = self.view.frame.size.height * 0.5;
  CGFloat serviceCollectionViewY = self.tableView.contentOffset.y;
  CGRect collectionViewF =
      CGRectMake(0, serviceCollectionViewY, serviceCollectionViewW,
                 serviceCollectionViewH);
  self.serviceCollectionView.frame = collectionViewF;
  [self.serviceCollectionView registerClass:[HSCollectionViewCell class]
                 forCellWithReuseIdentifier:@"Grab"];
  [self.tableView addSubview:self.serviceCollectionView];

  // 4.设置代理
  self.serviceCollectionView.delegate = self;
  self.serviceCollectionView.dataSource = self;
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
                             self.serviceStr = subService.typeName;
                             [weakSelf setupRefreshView];
                             //        [self loadNewData];
                           }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == self.statusTableView) {
        return 1;
    }else{
        return [super numberOfSectionsInTableView:tableView];
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.statusTableView) {
        return 2;
    }else{
        return [super tableView:tableView numberOfRowsInSection:section];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.statusTableView) {
        NSString *ID = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        // 如果缓存池中没有该ID的cell，则创建一个新的cell
        if (cell == nil) {
            // 创建一个新的cell
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                          reuseIdentifier:ID];
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.backgroundColor = [UIColor clearColor];
            cell.textLabel.textColor = [UIColor whiteColor];
            UIView *selectedView = [[UIView alloc]initWithFrame:cell.frame];
            selectedView.backgroundColor = [UIColor grayColor];
            cell.selectedBackgroundView = selectedView;
            
            cell.layer.cornerRadius = 5;
            cell.layer.masksToBounds = YES;

            // 添加lable
            UILabel *statusLab = [[UILabel alloc]init];
            CGFloat labW = 50;
            CGFloat labH = 20;
            CGFloat labY = cell.contentView.frame.size.height * 0.5 - 0.5 * labH;
            CGFloat labX = self.statusTableView.frame.size.width * 0.5 - 0.5 * labW;
            statusLab.frame = CGRectMake(labX, labY, labW, labH);
            statusLab.textColor = [UIColor whiteColor];
            statusLab.textAlignment = NSTextAlignmentCenter;
            [cell.contentView addSubview:statusLab];
            
            self.statusLab = statusLab;
            if (indexPath.row == 0) {
                self.statusLab.text = @"空闲";
            }else{
                self.statusLab.text = @"忙碌";
            }
        }
        return cell;
    }else{
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.statusTableView) {
        __weak __typeof(self) weakSelf = self;
        // 访问服务器
        AFHTTPRequestOperationManager *manager =
        (AFHTTPRequestOperationManager *)[HSHTTPRequestOperationManager manager];
        NSMutableDictionary *attrDict = [NSMutableDictionary dictionary];
        attrDict[@"servantID"] = self.servant.servantID;
        attrDict[@"servantStatus"] = [NSString string];
        if (indexPath.row == 0) {
            attrDict[@"servantStatus"] = @"空闲";
        }else{
            attrDict[@"servantStatus"] = @"忙碌";
        }
        NSString *urlStr = [NSString
                            stringWithFormat:
                            @"%@/MobileServantInfoAction?operation=_modifyStatus",
                            kHSBaseURL];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

        [manager POST:urlStr
           parameters:attrDict
              success:^(AFHTTPRequestOperation *_Nonnull operation,
                        id _Nonnull responseObject) {
                  if ([kServiceResponse isEqualToString:@"Success"]) {
                      NSString *titleStr = [NSString stringWithFormat:@"当前%@", attrDict[@"servantStatus"]];
                      // 存储状态
                      [defaults setObject:titleStr forKey:StatusStrKey];
                      [defaults synchronize];
                      // 设置状态标题
                      [self.titleBtn setTitle:titleStr forState:UIControlStateNormal];
                  } else {
                      // 创建hud
                      hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                      hud.mode = MBProgressHUDModeCustomView;
                      hud.labelText = @"状态更改失败";
                      hud.customView = MBProgressHUDErrorView;
                      [hud hide:YES afterDelay:1.0];
                      NSString *titleStr = [defaults objectForKey:StatusStrKey];
                      [self.titleBtn setTitle:titleStr forState:UIControlStateNormal];


                }
              }
              failure:^(AFHTTPRequestOperation *_Nonnull operation,
                        NSError *_Nonnull error) {
                  XBLog(@"failure:%@", error);
                  // 创建hud
                  hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                  hud.mode = MBProgressHUDModeCustomView;
                  hud.labelText = @"网络错误";
                  hud.customView = MBProgressHUDErrorView;
                  [hud hide:YES afterDelay:2.0];
                  NSString *titleStr = [defaults objectForKey:StatusStrKey];
                  [self.titleBtn setTitle:titleStr forState:UIControlStateNormal];
              }];

        [self titleBtnClicked];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == self.statusTableView) {
        return 0;
    }else{
        return [super tableView:tableView heightForHeaderInSection:section];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (tableView == self.statusTableView) {
        return 0;
    }else{
        return [super tableView:tableView heightForFooterInSection:section];
    }
}
#pragma mark - 表格刷新

/**
 *  加载新数据
 */
- (void)loadNewData {
    [super loadNewData];
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
            [self.refreshLab removeFromSuperview];
            NSArray *declareArray = [HSServiceDeclare objectArrayWithKeyValuesArray:kDataResponse];
          self.serviceDeclare =
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
        hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
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
- (void)declareCell:(HSDeclareCell *)declareCell rightButtonDidClickedAtIndexPath:(NSIndexPath *)indexPath{
    [super declareCell:declareCell rightButtonDidClickedAtIndexPath:indexPath];
    // 创建hud
    hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"正在抢单...";
    HSServiceDeclare *serviceDeclare = self.serviceDeclare[indexPath.section];
    
    // 访问服务器
    AFHTTPRequestOperationManager *manager =
    (AFHTTPRequestOperationManager *)[HSHTTPRequestOperationManager manager];
    
    NSMutableDictionary *attrDict = [NSMutableDictionary dictionary];
    attrDict[@"id"] = [NSString stringWithFormat:@"%d", serviceDeclare.ID];
    attrDict[@"customerID"] = serviceDeclare.customerID;
    attrDict[@"customerName"] = serviceDeclare.customerName;
    attrDict[@"servantID"] = self.servant.servantID;
    attrDict[@"servantName"] = self.servant.servantName;
    attrDict[@"contactAddress"] = serviceDeclare.serviceAddress;
    attrDict[@"contactPhone"] = serviceDeclare.phoneNo;
    attrDict[@"servicePrice"] = serviceDeclare.salary;
    attrDict[@"serviceType"] = serviceDeclare.serviceType;
    attrDict[@"serviceContent"] = serviceDeclare.serviceType;
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
                  XBLog(@"failed");
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
