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
#import "HSService.h"
#import "HSCollectionView.h"
#import "HSCollectionViewCell.h"
#import "HSCoveredCountry.h"
#import "MBProgressHUD+MJ.h"
#import "HSRefreshButton.h"
#import "HSNavigationViewController.h"
#import "HSServiceDeclare.h"
#import "HSDeclareCell.h"
#import "UIImage+HSResizingImage.h"
#import "HSServiceMapViewController.h"
#import "HSTitleBtn.h"
#import "LxDBAnything.h"
#import "HSPopoverView.h"

@interface HSGrabViewController () <
    UICollectionViewDataSource, UICollectionViewDelegate,
    UICollectionViewDelegateFlowLayout, HSCollectionViewCellDelegate, UIAlertViewDelegate> {
  MBProgressHUD *hud;
}
@property(strong, nonatomic) NSArray *regions;
@property(strong, nonatomic) NSArray *service;
@property(strong, nonatomic) NSArray *subService;

@property(weak, nonatomic) UIButton *bgBtn; // 半透明背景

@property(weak, nonatomic) HSNavBarBtn *leftNavBtn;
@property(weak, nonatomic) HSNavBarBtn *rightNavBtn;
@property(weak, nonatomic) HSTitleBtn *titleBtn;

@property(weak, nonatomic) UIButton *selectedRegionBtn;
@property(strong, nonatomic) HSCollectionView *regionCollectionView;

@property(strong, nonatomic) HSRefreshButton *regionRefreshButton;

@property(copy, nonatomic) NSString *regionStr;
@property(copy, nonatomic) NSString *serviceStr;
@property(strong, nonatomic) NSArray *serviceArray;

@property(strong, nonatomic) UIView *mapBtnView;
@property(strong, nonatomic) UIButton *mapBtn;

@property(strong, nonatomic) HSPopoverView *statusView;
@property(strong, nonatomic) HSPopoverView *serviceItemView;
@property(strong, nonatomic) UITableView *statusTableView;
@property(strong, nonatomic) UITableView *serviceItemTableView;

@property(weak, nonatomic) UILabel *statusLab;
@property(assign, nonatomic, getter=bgBtnDidAdded) BOOL bgBtnDidAdded;

@end

@implementation HSGrabViewController
#pragma mark - getter
- (HSCollectionView *)regionCollectionView {
  if (!_regionCollectionView) {
    _regionCollectionView = [HSCollectionView collectionView];
  }
  return _regionCollectionView;
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

- (UIButton *)mapBtn {
  if (!_mapBtn) {
    _mapBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _mapBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_mapBtn setTitle:@"地图抢单" forState:UIControlStateNormal];
    [_mapBtn setTitle:@"地图抢单" forState:UIControlStateHighlighted];
    [_mapBtn setTitleColor:XBMakeColorWithRGB(234, 103, 7, 1)
                  forState:UIControlStateNormal];
    [_mapBtn setTitleColor:[UIColor whiteColor]
                  forState:UIControlStateHighlighted];
    [_mapBtn setBackgroundImage:[UIImage resizeableImage:@"show_map_btn"]
                       forState:UIControlStateNormal];
    [_mapBtn
        setBackgroundImage:[UIImage resizeableImage:@"show_map_btn_highlighted"]
                  forState:UIControlStateHighlighted];
    [_mapBtn addTarget:self
                  action:@selector(showMapView)
        forControlEvents:UIControlEventTouchUpInside];
  }
  return _mapBtn;
}

- (UIView *)mapBtnView {
  if (!_mapBtnView) {
    _mapBtnView = [[UIView alloc] init];
    UIView *blackLineView = [[UIView alloc] init];
    blackLineView.frame = CGRectMake(0, 0, XBScreenWidth, 0.5);
    blackLineView.backgroundColor = [UIColor lightGrayColor];
    [_mapBtnView addSubview:blackLineView];
    CGFloat viewX = 0;
    CGFloat viewH = 49;
    CGFloat viewY = XBScreenHeight - 2 * 49 - 64;
    CGFloat viewW = XBScreenWidth;
    _mapBtnView.frame = CGRectMake(viewX, viewY, viewW, viewH);
    _mapBtnView.backgroundColor = [UIColor whiteColor];
  }
  return _mapBtnView;
}
/**
 *  导航栏状态按钮下拉条
 */
- (HSPopoverView *)statusView {
  if (!_statusView) {
    _statusView = [HSPopoverView popoverView];
    _statusView.image =
        [UIImage resizeableImage:@"navigation_popover_background"];
    CGFloat viewW = 217;
    CGFloat viewH = 110;
    CGFloat viewY = 64;
    CGFloat viewX = 0.5 * (XBScreenWidth - viewW);
    _statusView.frame = CGRectMake(viewX, viewY, viewW, viewH);

    CGFloat tableY = 15;
    CGFloat tableX = 10;
    CGFloat tableW = _statusView.frame.size.width - 2 * tableX;
    CGFloat tableH = 90;
    _statusTableView = [[UITableView alloc]
        initWithFrame:CGRectMake(tableX, tableY, tableW, tableH)];
    _statusTableView.backgroundColor = [UIColor clearColor];
    _statusTableView.rowHeight = 40;
    _statusTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_statusView addSubview:_statusTableView];
    _statusTableView.delegate = self;
    _statusTableView.dataSource = self;
  }
  return _statusView;
}

- (HSPopoverView *)serviceItemView {
  if (!_serviceItemView) {
    _serviceItemView = [HSPopoverView popoverView];
    _serviceItemView.image =
        [UIImage resizeableImage:@"navigation_more_service_name"];
    CGFloat viewW = 110;
    CGFloat viewH = 150;
    CGFloat viewY = 64;
    CGFloat viewX = XBScreenWidth - viewW - 10;
    _serviceItemView.frame = CGRectMake(viewX, viewY, viewW, viewH);

    CGFloat tableY = 15;
    CGFloat tableX = 10;
    CGFloat tableW = _serviceItemView.frame.size.width - 2 * tableX;
    CGFloat tableH = 90;
    _serviceItemTableView = [[UITableView alloc]
        initWithFrame:CGRectMake(tableX, tableY, tableW, tableH)];
    _serviceItemTableView.backgroundColor = [UIColor clearColor];
    _serviceItemTableView.rowHeight = 40;
    _serviceItemTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_serviceItemView addSubview:_serviceItemTableView];
    _serviceItemTableView.delegate = self;
    _serviceItemTableView.dataSource = self;
  }
  return _serviceItemView;
}

- (NSArray *)serviceArray {
  if (!_serviceArray) {
    NSString *serviceItem = self.servant.serviceItems;
    _serviceArray =
        [serviceItem componentsSeparatedByString:@"|"]; // 根据"|"分割字符串
  }
  return _serviceArray;
}
#pragma mark - 系统view加载于显示
- (void)viewDidLoad {
  // 更改tableView的frame
  CGFloat tableViewH =
      XBScreenHeight - 49 - self.mapBtnView.frame.size.height - 20;
  self.tableView.frame = CGRectMake(0, 0, XBScreenWidth, tableViewH);

  // 设置tableView样式
  self.tableView.rowHeight = 310;

  // 隐藏按钮
  self.leftBtnHiddn = YES;

  // 添加导航栏按钮
  [self setupNavBarBtn];

  // 导航栏状态按钮标题
  [self setupNavBarTitle];

  // 刷新表格
  if (self.serviceStr == nil) {
    self.serviceStr = self.serviceArray[0];
    // 存储所选服务项目名称
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.serviceStr forKey:ServiceStrKey];
    [defaults synchronize];
  }
  if (self.regionStr && self.serviceStr) {
    [self setupRefreshView];
  }
  // 设置badgeValue
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  NSString *grabBadgeValueKey = [userDefaults objectForKey:GrabBadgeValueKey];
  if (grabBadgeValueKey) {
    self.tabBarItem.badgeValue = grabBadgeValueKey;
  }
  [super viewDidLoad];

  // Do any additional setup after loading the view.
}

/**
 *  view即将显示
 */
- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  if (self.regionStr && self.serviceStr) {
    [self.tableView.header beginRefreshing];
  }
}

/**
 *  view已经显示
 */
- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  // 设置地图按钮
  [self setupMapBtn];
  // 提示label
  if (!self.regionStr) {
    UIAlertView *alertView =
        [[UIAlertView alloc] initWithTitle:@"提示"
                                   message:@"请先选择所在地区"
                                  delegate:self
                         cancelButtonTitle:@"确定"
                         otherButtonTitles:nil, nil];
    [alertView show];
  } else {
    [self.refreshLab removeFromSuperview];
  }
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

#pragma mark - 自定义view创建
/**
 *导航栏状态按钮标题
 */
- (void)setupNavBarTitle {
  NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
  NSString *titleStr = [userDefault objectForKey:StatusStrKey];
  if (titleStr) {
    [self.titleBtn setTitle:titleStr forState:UIControlStateNormal];
  } else {
    [self.titleBtn setTitle:@"当前空闲" forState:UIControlStateNormal];
  }
}
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
    rightStr = self.serviceArray[0];
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
  CGSize titleSize = [titleStr sizeWithAttributes:@{
    NSFontAttributeName :
        [UIFont fontWithName:titleBtn.titleLabel.font.fontName
                        size:titleBtn.titleLabel.font.pointSize]
  }];
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
 *  设置背景按钮
 */
- (void)setupBgButton {
  if (!self.bgBtnDidAdded) {
    self.tableView.scrollEnabled = NO;

    UIButton *bgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bgBtn.frame = self.view.bounds;
    [bgBtn
        setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3]];
    [self.tableView addSubview:bgBtn];
    self.bgBtn = bgBtn;
    [bgBtn addTarget:self
                  action:@selector(bgBtnClicked)
        forControlEvents:UIControlEventTouchUpInside];
    self.bgBtnDidAdded = YES;
  }
}

/**
 *  创建地区collectionView
 */
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

/**
 *  加载点击地图按钮
 */
- (void)setupMapBtn {
  CGFloat buttonW = 100;
  CGFloat buttonH = 30;
  CGFloat buttonX = XBScreenWidth * 0.5 - buttonW * 0.5;
  CGFloat buttonY = self.mapBtnView.center.y - buttonH * 0.55;
  self.mapBtn.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);

  [self.view addSubview:self.mapBtnView];
  [self.view addSubview:self.mapBtn];
}

/**
 *  显示地图
 */
- (void)showMapView {
  HSServiceMapViewController *mapViewVc =
      [[HSServiceMapViewController alloc] init];
  mapViewVc.serviceDeclare = self.serviceDeclare;
  HSNavigationViewController *nav =
      [[HSNavigationViewController alloc] initWithRootViewController:mapViewVc];

  [self presentViewController:nav
                     animated:YES
                   completion:^{

                   }];
}

#pragma mark - 按钮点击
/**
 *  导航栏中部按钮被点击
 */
- (void)titleBtnClicked {
  if (self.leftNavBtn.selected || self.rightNavBtn.selected) {
    [self bgBtnClicked];
  }
  self.titleBtn.selected = !self.titleBtn.selected;
  if (!self.titleBtn.selected) {
    [self bgBtnClicked];
    [self.statusView removeFromSuperview];
  } else {
    [self setupBgButton];
    [self.navigationController.view addSubview:self.statusView];
  }
}
/**
 *  导航栏按钮被点击
 *
 *  @param button 左边按钮／右边按钮
 */
- (void)navBtnClicked:(HSNavBarBtn *)button {
  [self.refreshLab removeFromSuperview];
  [self.statusView removeFromSuperview];
  [self.serviceItemView removeFromSuperview];

  // 如果titleBtn选中
  if (self.titleBtn.selected) {
    [self titleBtnClicked];
  }
  button.selected = !button.selected;
  // 左边的被点击，选择地区
  if (button.selected && button == self.leftNavBtn) {
    [self.refreshLab removeFromSuperview];
    [self bgBtnClicked];
    self.leftNavBtn.selected = YES;
    // 创建背景半透明按钮
    [self setupBgButton];
    [self setupRegionCollectionView];
    [self loadRegions];

  } else if (button.selected &&
             button == self.rightNavBtn) { // 右边的被点击选择服务
    [self.refreshLab removeFromSuperview];
    [self bgBtnClicked];
    self.rightNavBtn.selected = YES;
    // 创建背景半透明按钮
    [self setupBgButton];
    [self.navigationController.view addSubview:self.serviceItemView];
  } else { // 取消点击
    [self bgBtnClicked];
  }
}

/**
 *  背景按钮点击
 */
- (void)bgBtnClicked {
  [self.bgBtn removeFromSuperview];
  self.bgBtnDidAdded = NO;

  [self.regionCollectionView removeFromSuperview];
  [self.serviceItemView removeFromSuperview];
  [self.statusView removeFromSuperview];

  self.tableView.scrollEnabled = YES;

  self.titleBtn.selected = NO;
  self.leftNavBtn.selected = NO;
  self.rightNavBtn.selected = NO;
}

/**
 *  cell按钮点击
 */
- (void)regionBtnClicked:(UIButton *)regionBtn {
        [self.refreshLab removeFromSuperview];
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

#pragma mark - 数据加载
/**
 *  加载region
 */
- (void)loadRegions {
  // 将原来加载按钮取消
  [self.regionRefreshButton removeFromSuperview];
  // weak self,否则block中循环引用
    __weak __typeof(self) weakSelf = self;
  // 将_region置空
  _regions = nil;
  [self.regionCollectionView reloadData];
  // 隐藏所有HUD
  [MBProgressHUD hideAllHUDsForView:self.regionCollectionView animated:YES];
  // 创建hud
  hud = [MBProgressHUD showHUDAddedTo:self.regionCollectionView animated:YES];
  hud.labelText = @"正在加载";

    NSMutableDictionary *regionAttrDict = [NSMutableDictionary dictionary];
    regionAttrDict[@"cityCode"] = @"C037";
    
    [[HS_NetAPIManager sharedManager]request_Grab_CountyWithParams:regionAttrDict andBlock:^(id data, NSError *error) {
        [hud hide:YES];
        if (data) {
            _regions = data;
            [weakSelf.refreshLab removeFromSuperview];
            [weakSelf.regionCollectionView reloadData];
        }else{
            [NSObject showHudTipStr:@"似乎与服务器断开连接"];
            weakSelf.regionRefreshButton.center =
            weakSelf.regionCollectionView.center;
            weakSelf.regionRefreshButton.bounds = CGRectMake(0, 0, 100, 50);
            [weakSelf.regionCollectionView
             addSubview:weakSelf.regionRefreshButton];
        }
    }];
}

/**
 *  表格刷新-加载新数据
 */
- (void)loadNewData {
  [super loadNewData];
  __weak __typeof(self) weakSelf = self;
  // 先移除label
  [self.refreshLab removeFromSuperview];
  // 访问服务器
    NSMutableDictionary *attrDict = [NSMutableDictionary dictionary];
    attrDict[@"serviceCounty"] = self.regionStr;
    attrDict[@"serviceType"] = self.serviceStr;
    
    [[HS_NetAPIManager sharedManager]request_Grab_DeclareWithParams:attrDict andBlock:^(id data, NSError *error) {
        [self.refreshLab removeFromSuperview];
        if (data) {
            if ([data isKindOfClass:[NSArray class]]) {
                self.serviceDeclare = data;
                // 设置badgeValue
                self.tabBarItem.badgeValue =
                [NSString stringWithFormat:@"%d", (int)self.serviceDeclare.count];
                [self.tableView reloadData];
                [self.tableView.header endRefreshing];
            }else{
//         取消刷新
                  [self.tableView.header endRefreshing];
                  // 将serviceDeclare置空
                  self.serviceDeclare = nil;
                  HSRefreshLab *refreshLab =
                      [HSRefreshLab refreshLabelWithText:@"需"
                                    @"求为0，请下拉刷新重试，或选"
                                    @"择其他服务类别"];
        
                  CGFloat labelW = XBScreenWidth;
                  CGFloat labelX = 0;
                  CGFloat labelY = XBScreenHeight * 0.3;
                  CGFloat labelH = 20;
                  refreshLab.frame = CGRectMake(labelX, labelY, labelW, labelH);
                  self.refreshLab = refreshLab;
                // 设置badgeValue
                self.tabBarItem.badgeValue = @"0";
                  [self.view addSubview:refreshLab];
                  [self.tableView reloadData];
            }
            
        }else{
            [self.refreshLab removeFromSuperview];
            [NSObject showHudTipStr:@"似乎与服务器断开连接"];
            // 将serviceDeclare置空
            self.serviceDeclare = nil;

            HSRefreshLab *refreshLab = [HSRefreshLab
                                        refreshLabelWithText:
                                        @"无法连接服务器，请检查网络连接是否正确"];
            CGFloat labelW = XBScreenWidth;
            CGFloat labelX = 0;
            CGFloat labelY = XBScreenHeight * 0.3;
            CGFloat labelH = 20;
            refreshLab.frame = CGRectMake(labelX, labelY, labelW, labelH);
            weakSelf.refreshLab = refreshLab;
            [weakSelf.view addSubview:refreshLab];
            [self.tableView reloadData];
            [self.tableView.header endRefreshing];
            
        }
    }];
}

#pragma mark - datasource
#pragma mark  UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  if (tableView == self.statusTableView) {
    return 1;
  } else if (tableView == self.serviceItemTableView) {
    return 1;
  } else {
    return [super numberOfSectionsInTableView:tableView];
  }
}
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
  if (tableView == self.statusTableView) {
    return 2;
  } else if (tableView == self.serviceItemTableView) {
    return self.serviceArray.count;
  } else {
    return [super tableView:tableView numberOfRowsInSection:section];
  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (tableView == self.statusTableView ||
      tableView == self.serviceItemTableView) {
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
      UIView *selectedView = [[UIView alloc] initWithFrame:cell.frame];
      selectedView.backgroundColor = [UIColor grayColor];
      cell.selectedBackgroundView = selectedView;

      cell.layer.cornerRadius = 5;
      cell.layer.masksToBounds = YES;

      // 添加lable
      UILabel *cellLabel = [[UILabel alloc] init];
      CGFloat labW = 100;
      CGFloat labH = 20;
      CGFloat labY = cell.contentView.frame.size.height * 0.5 - 0.5 * labH;
      CGFloat labX = tableView.frame.size.width * 0.5 - 0.5 * labW;
      cellLabel.frame = CGRectMake(labX, labY, labW, labH);
      cellLabel.textColor = [UIColor whiteColor];
      cellLabel.textAlignment = NSTextAlignmentCenter;
      [cell.contentView addSubview:cellLabel];

      if (tableView == self.statusTableView) {
        if (indexPath.row == 0) {
          cellLabel.text = @"空闲";
        } else {
          cellLabel.text = @"忙碌";
        }
      } else {
        cellLabel.text = self.serviceArray[indexPath.row];
      }
    }
    return cell;
  } else {
    return [super tableView:tableView cellForRowAtIndexPath:indexPath];
  }
}

#pragma mark - delegate
#pragma mark  CollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:
    (UICollectionView *)collectionView {
  return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
  return self.regions.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  HSCollectionViewCell *cell = (HSCollectionViewCell *)
      [collectionView dequeueReusableCellWithReuseIdentifier:@"Grab"
                                                forIndexPath:indexPath];
  cell.delegate = self;
  HSCoveredCountry *region = self.regions[indexPath.item];
  NSString *regionTitle = [NSString stringWithFormat:@"%@", region.countyName];
  [cell.cellBtn setTitle:regionTitle forState:UIControlStateNormal];
  [cell.cellBtn addTarget:self
                   action:@selector(regionBtnClicked:)
         forControlEvents:UIControlEventTouchUpInside];
  return cell;
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

#pragma mark  UITableViewDelegate
- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if (tableView == self.statusTableView) {

    // 访问服务器
      NSMutableDictionary *attrDict = [NSMutableDictionary dictionary];
      attrDict[@"servantID"] = self.servant.servantID;
      attrDict[@"servantStatus"] = @"";
      if (indexPath.row == 0) {
          attrDict[@"servantStatus"] = @"空闲";
      } else {
          attrDict[@"servantStatus"] = @"忙碌";
      }
      NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
      [[HS_NetAPIManager sharedManager]request_Grab_StatusWithParams:attrDict andBlock:^(id data, NSError *error) {
          if (data) {
              if (![data isEqualToString:@"Failed"]) {
                  // 设置状态标题
                  [self.titleBtn setTitle:data forState:UIControlStateNormal];

              }else{
                  [NSObject showHudTipStr:@"状态更改失败"];
                  NSString *titleStr = [defaults objectForKey:StatusStrKey];
                  [self.titleBtn setTitle:titleStr forState:UIControlStateNormal];

              }
          }else{
              [NSObject showHudTipStr:@"似乎与服务器断开连接"];
          }
      }];
    [self titleBtnClicked];
  } else if (tableView == self.serviceItemTableView) {
    [self navBtnClicked:self.rightNavBtn];
    self.serviceStr = self.serviceArray[indexPath.row];
    [self.rightNavBtn setTitle:self.serviceStr forState:UIControlStateNormal];
    // 存储所选服务项目名称
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.serviceStr forKey:ServiceStrKey];
    [defaults synchronize];

    [self setupRefreshView];
  }
}

- (CGFloat)tableView:(UITableView *)tableView
    heightForHeaderInSection:(NSInteger)section {
  if (tableView == self.statusTableView ||
      tableView == self.serviceItemTableView) {
    return 0;
  } else {
    return [super tableView:tableView heightForHeaderInSection:section];
  }
}

- (CGFloat)tableView:(UITableView *)tableView
    heightForFooterInSection:(NSInteger)section {
  if (tableView == self.statusTableView ||
      tableView == self.serviceItemTableView) {
    return 0;
  } else {
    return [super tableView:tableView heightForFooterInSection:section];
  }
}

#pragma mark  UIAlertViewDelegate
- (void)alertView:(UIAlertView *_Nonnull)alertView
    clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (buttonIndex == 0) {
    [self navBtnClicked:self.leftNavBtn];
  }
}

#pragma mark  HSDeclareCellDelegate
- (void)declareCell:(HSDeclareCell *)declareCell
    rightButtonDidClickedAtIndexPath:(NSIndexPath *)indexPath {
  [super declareCell:declareCell rightButtonDidClickedAtIndexPath:indexPath];
  // 创建hud
  hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view
                             animated:YES];
  hud.labelText = @"正在抢单...";
  HSServiceDeclare *serviceDeclare = self.serviceDeclare[indexPath.section];
    serviceDeclare.servantID = self.servant.servantID;
    serviceDeclare.servantName = self.servant.servantName;
    
    [[HS_NetAPIManager sharedManager]request_Grab_WithParams:[serviceDeclare toParams] andBlock:^(id data, NSError *error) {
        [hud hide:YES];
        if (data) {
            if ([data isEqualToString:@"Success"]) {
                [NSObject showHudTipStr:@"抢单成功"];
                [self loadNewData];
            }else{
                [NSObject showHudTipStr:@"抢单失败"];
            }
        }else{
            [NSObject showHudTipStr:@"似乎与服务器断开连接"];
        }
    }];
}

@end
