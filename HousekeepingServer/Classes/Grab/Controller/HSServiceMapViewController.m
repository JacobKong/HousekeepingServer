//
//  HSServiceMapViewController.m
//  HousekeepingServer
//
//  Created by Jacob on 15/10/16.
//  Copyright © 2015年 com.jacob. All rights reserved.
//

#import "HSServiceMapViewController.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import "HSServiceDeclare.h"
#import "XBConst.h"
#import "UIImage+HSResizingImage.h"
#import "HSGrabButton.h"
#import "HSDeclareCell.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "HSHTTPRequestOperationManager.h"
#import "HSServant.h"
#import "HSServantTool.h"

/**
 *  declareAnnotation
 */
@interface HSDeclareAnnotation : BMKPointAnnotation

///所包含annotation个数
@property(nonatomic, assign) NSInteger size;
@property(strong, nonatomic) HSServiceDeclare *declare;
@end

@implementation HSDeclareAnnotation

@synthesize size = _size;
@synthesize declare = _declare;

@end

/*
 *HSDeclareAnnotationView
 */
@interface HSDeclareAnnotationView : BMKPinAnnotationView {
}

@end

@implementation HSDeclareAnnotationView

- (id)initWithAnnotation:(id<BMKAnnotation>)annotation
         reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
  return self;
}
@end

/**
 *  HSServiceMapViewController
 */
@interface HSServiceMapViewController () <
    BMKMapViewDelegate, BMKLocationServiceDelegate, HSDeclareCellDelegate> {
  BMKLocationService *_locService;
  BMKMapView *_mapView;
  NSIndexPath *_indexPath;
  MBProgressHUD *hud;
        HSDeclareAnnotation *_selectedAnnotation;
        BMKUserLocation *_userLocation;
}
@property(strong, nonatomic) HSDeclareCell *cell;
@property(strong, nonatomic) HSServant *servant;
@end

@implementation HSServiceMapViewController
#pragma mark - getter
- (HSDeclareCell *)cell {
  if (!_cell) {
    _cell = [HSDeclareCell serviceDeclareCell];
    _cell.delegate = self;
  }
  return _cell;
}

- (HSServant *)servant {
  if (!_servant) {
    _servant = [HSServantTool servant];
  }
  return _servant;
}

#pragma mark - view加载
- (void)viewDidLoad {
  // 标题
  self.title = @"地图抢单";
  // 设置导航栏按钮
  [self setupNavBarBtn];
  // 设置背景
  self.view.backgroundColor = [UIColor whiteColor];
  // 加载地图
  BMKMapView *mapView = [[BMKMapView alloc] initWithFrame:self.view.bounds];
  // 比例尺
  mapView.showMapScaleBar = YES;
  //自定义比例尺的位置
  mapView.mapScaleBarPosition = CGPointMake(mapView.frame.size.width - 70,
                                            mapView.frame.size.height - 40);
  //设置地图缩放级别
  [mapView setZoomLevel:15];
  // 指南针
  [mapView setCompassPosition:CGPointMake(10, 10)];
  _mapView = mapView;
  [self.view addSubview:_mapView];

  // 初始化BMKLocationService
  _locService = [[BMKLocationService alloc] init];
  _locService.delegate = self;
  // 开始定位
  [_locService startUserLocationService];
  _mapView.showsUserLocation = NO; //先关闭显示的定位图层
  _mapView.userTrackingMode = BMKUserTrackingModeFollow; //设置定位的状态
  _mapView.showsUserLocation = YES;                      //显示定位图层
    
    // 设置定位按钮
    [self setupLocateBtn];

  [super viewDidLoad];
  // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
  [_mapView viewWillAppear];
  _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
  [_mapView viewWillDisappear];
  _mapView.delegate = nil; // 不用时，置nil
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [self addPointAnnotations];
}

- (void)setupNavBarBtn {
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
      initWithImage:[UIImage imageNamed:@"navigation_common_icon_close_white"]
              style:UIBarButtonItemStylePlain
             target:self
             action:@selector(closeBtnClicked)];
}

- (void)setupLocateBtn{
    UIButton *locateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [locateBtn setBackgroundImage:[UIImage imageNamed:@"mapview_region"] forState:UIControlStateNormal];
    
    CGFloat buttonW = 32;
    CGFloat buttonH = 32;
    CGFloat buttonX = 10;
    CGFloat buttonY = 74;
    locateBtn.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
    
    [locateBtn addTarget:self action:@selector(locateBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:locateBtn];
    
}

- (void)closeBtnClicked {
  [self dismissViewControllerAnimated:YES
                           completion:^{
                           }];
}

/**
 *  回到自身当前位置
 */
- (void)locateBtnClicked{
    BMKCoordinateRegion region;
    region.center.latitude  = _userLocation.location.coordinate.latitude;
    region.center.longitude = _userLocation.location.coordinate.longitude;
    region.span.latitudeDelta  = 0.2;
    region.span.longitudeDelta = 0.2;
    if (_mapView) {
        _mapView.region = region;
    }
    
}
#pragma mark - BMKMapViewDelegate
// 添加标注
- (void)addPointAnnotations {
  // 添加一个PointAnnotation
  for (HSServiceDeclare *serviceDeclare in self.serviceDeclare) {
    HSDeclareAnnotation *annotion = [[HSDeclareAnnotation alloc] init];
    CLLocationCoordinate2D coor;

    coor.latitude = [serviceDeclare.serviceLatitude doubleValue];
    coor.longitude = [serviceDeclare.serviceLongitude doubleValue];
    annotion.coordinate = coor;
    NSString *serviceAddress = [NSString
        stringWithFormat:@"工作地点：%@", serviceDeclare.serviceAddress];
    NSString *salary =
        [NSString stringWithFormat:@"薪资：%@元", serviceDeclare.salary];
    annotion.title = serviceAddress;
    annotion.subtitle = salary;
    annotion.declare = serviceDeclare;
    [_mapView addAnnotation:annotion];
  }
}

// 根据anntation生成大头针
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView
             viewForAnnotation:(id<BMKAnnotation>)annotation {
  if ([annotation isKindOfClass:[HSDeclareAnnotation class]]) {
    // 创建declareAnnotation
    HSDeclareAnnotation *declareAnnotation = (HSDeclareAnnotation *)annotation;
    // 创建HSDeclareAnnotationView
    HSDeclareAnnotationView *newAnnotationView =
        [[HSDeclareAnnotationView alloc] initWithAnnotation:annotation
                                            reuseIdentifier:@"myAnnotation"];
    newAnnotationView.image = [UIImage imageNamed:@"icon_map"];
    HSGrabButton *grabBtn = [HSGrabButton grabButton];
    grabBtn.serviceDeclare = declareAnnotation.declare;
    [grabBtn addTarget:self
                  action:@selector(bubbleViewBtnClickedWithGrabBtn:)
        forControlEvents:UIControlEventTouchUpInside];
    newAnnotationView.rightCalloutAccessoryView = grabBtn;
    newAnnotationView.animatesDrop = YES; //设置该标注点动画显示
    return newAnnotationView;
  }

  return nil;
}

- (void)mapView:(BMKMapView *)mapView
    didSelectAnnotationView:(BMKAnnotationView *)view {
    _selectedAnnotation = (HSDeclareAnnotation *)view.annotation;
}

// 抢单按钮点击
- (void)bubbleViewBtnClickedWithGrabBtn:(HSGrabButton *)grabBtn {
  if (!self.cell.frame.origin.y) {
    HSServiceDeclare *serviceDeclare = grabBtn.serviceDeclare;
    CGFloat cellW = 300;
    CGFloat cellH = 330;
    CGFloat cellX = (XBScreenWidth - cellW) * 0.5;
    CGFloat cellY = XBScreenHeight;
    self.cell.frame = CGRectMake(cellX, cellY, cellW, cellH);
    self.cell.backgroundColor = XBMakeColorWithRGB(255, 255, 255, 0.9);
    self.cell.serviceDeclare = serviceDeclare;
    self.cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.cell.leftBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.view addSubview:self.cell];
    // 动画效果
    [UIView animateWithDuration:0.5
        animations:^{
          CGRect cellF = self.cell.frame;
          cellF.origin.y = XBScreenHeight - cellH;
          self.cell.frame = cellF;
        }
        completion:^(BOOL finished){
        }];
  } else {
    [UIView animateWithDuration:0.3
        animations:^{
          CGRect cellF = self.cell.frame;
          cellF.origin.y = XBScreenHeight;
          self.cell.frame = cellF;
        }
        completion:^(BOOL finished) {
          [UIView animateWithDuration:0.5
                           animations:^{
                             CGRect cellF = self.cell.frame;
                             cellF.origin.y = XBScreenHeight - 330;
                             self.cell.frame = cellF;
                           }];
        }];
  }
}

#pragma mark - HSDeclareCellDelegate
- (void)declareCell:(HSDeclareCell *)declareCell
    leftButtonDidClickedAtIndexPath:(NSIndexPath *)indexPath {
  [UIView animateWithDuration:0.5
      animations:^{
        CGRect cellF = self.cell.frame;
        cellF.origin.y = XBScreenHeight;
        self.cell.frame = cellF;
      }
      completion:^(BOOL finished){
      }];
}

- (void)declareCell:(HSDeclareCell *)declareCell
    rightButtonDidClickedAtIndexPath:(NSIndexPath *)indexPath {
  // 创建hud
  hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view
                             animated:YES];
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
          // 删除该点
          [_mapView removeAnnotation:_selectedAnnotation];
            [self declareCell:self.cell leftButtonDidClickedAtIndexPath:_indexPath];

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
#pragma mark - BMKLocationServiceDelegate
/**
 *在地图View将要启动定位时，会调用此函数
 *@param mapView 地图View
 */
- (void)willStartLocatingUser {
  XBLog(@"start locate");
}

/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation {
  [_mapView updateLocationData:userLocation];
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
    _userLocation = userLocation;
  [_mapView updateLocationData:userLocation];
}

/**
 *在地图View停止定位后，会调用此函数
 *@param mapView 地图View
 */
- (void)didStopLocatingUser {
  XBLog(@"stop locate");
}

/**
 *定位失败后，会调用此函数
 *@param mapView 地图View
 *@param error 错误号，参考CLError.h中定义的错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error {
  XBLog(@"location error");
}

- (void)dealloc {
  if (_mapView) {
    _mapView = nil;
  }
}

@end
