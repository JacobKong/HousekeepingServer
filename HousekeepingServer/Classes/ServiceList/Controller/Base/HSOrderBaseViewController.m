//
//  HSOrderBaseViewController.m
//  HousekeepingServer
//
//  Created by Jacob on 15/10/13.
//  Copyright © 2015年 com.jacob. All rights reserved.
//

#import "HSOrderBaseViewController.h"
#import "HSOrderDetailsViewController.h"

@interface HSOrderBaseViewController () <UIAlertViewDelegate> {
  MBProgressHUD *hud;
}
@property(strong, nonatomic) NSIndexPath *selectedIndexPath;

@end

@implementation HSOrderBaseViewController

#pragma mark - tableView样式
- (instancetype)init {
  self = [super init];
  if (self) {
      self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    return [super initWithStyle:UITableViewStyleGrouped];
  }
  return self;
}

- (id)initWithStyle:(UITableViewStyle)style {
  return [super initWithStyle:UITableViewStyleGrouped];
}

- (HSServant *)servant {
  if (!_servant) {
    _servant = [HSServantTool servant];
  }
  return _servant;
}

- (NSMutableArray *)serviceOrder{
    if (!_serviceOrder) {
        _serviceOrder = [NSMutableArray array];
    }
    return _serviceOrder;
}
- (void)viewDidLoad {
    self.tableView.rowHeight = 300;
  [self setupRefreshView];
  [super viewDidLoad];
}

/**
 *  view即将显示时调用
 */
- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  // 一进入该界面就开始刷新
  [self setupRefreshView];
  self.tableView.backgroundColor = XBMakeColorWithRGB(234, 234, 234, 1);
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  [self.tableView.header endRefreshing];
}

- (void)viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];
  [self.tableView.header endRefreshing];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return self.serviceOrder.count;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
  return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  HSOrderCell *cell = [HSOrderCell cellWithTableView:tableView];
  cell.serviceOrder = self.serviceOrder[indexPath.section];
  cell.delegate = self;
  cell.indexPath = indexPath;
  return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HSOrderDetailsViewController *orderDetailsVc = [[HSOrderDetailsViewController alloc]init];
    orderDetailsVc.serviceOrder = self.serviceOrder[indexPath.section];
    [self.navigationController pushViewController:orderDetailsVc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}


/**
 *  添加refreshView
 */
- (void)setupRefreshView {
  __weak __typeof(self) weakSelf = self;

  // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
  MJRefreshNormalHeader *header =
      [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadNewDataloadNewDataWithOrderStatus:self.orderStatus
                                         refreshLabText:self.refreshLabText];
      }];
  // 设置自动切换透明度(在导航栏下面自动隐藏)
  header.automaticallyChangeAlpha = YES;
  if (!self.tableView.header) {
    self.tableView.header = header;
  }
  // 马上进入刷新状态
  [self.tableView.header beginRefreshing];
}

- (void)setupFooterRefreshView{
      __weak __typeof(self) weakSelf = self;
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadNewDataloadNewDataWithOrderStatus:self.orderStatus refreshLabText:self.refreshLabText];
    }];
}

- (void)loadNewDataloadNewDataWithOrderStatus:(NSString *)orderStatus
                               refreshLabText:(NSString *)refreshLabText {
  __weak __typeof(self) weakSelf = self;
  // 先移除label
  [self.refreshLab removeFromSuperview];
  // 访问服务器
  AFHTTPRequestOperationManager *manager =
      (AFHTTPRequestOperationManager *)[HSHTTPRequestOperationManager manager];
  NSMutableDictionary *attrDict = [NSMutableDictionary dictionary];
  NSString *urlStr;
  if (self.orderStatus) {
    attrDict[@"orderStatus"] = orderStatus;
    urlStr = [NSString
        stringWithFormat:@"%@/MobileServiceOrderAction?operation=_queryOrder",
                         kHSBaseURL];

  } else {
    urlStr = [NSString
        stringWithFormat:@"%@/MobileServiceOrderAction?operation=_queryOrders",
                         kHSBaseURL];
  }
  attrDict[@"servantID"] = self.servant.servantID;
  [manager POST:urlStr
      parameters:attrDict
      success:^(AFHTTPRequestOperation *_Nonnull operation,
                id _Nonnull responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([kServiceResponse isEqualToString:@"Success"]) {

            self.serviceOrder = [HSServiceOrder objectArrayWithKeyValuesArray:kDataResponse];
            if (self.serviceOrder.count == 0) {
                HSRefreshLab *refreshLab =
                [HSRefreshLab refreshLabelWithText:@"当前项目无任何订单，请刷新重试"];
                CGFloat labelW = XBScreenWidth;
                CGFloat labelX = 0;
                CGFloat labelY = XBScreenHeight * 0.2;
                CGFloat labelH = 20;
                refreshLab.frame = CGRectMake(labelX, labelY, labelW, labelH);
                self.refreshLab = refreshLab;
                [self.view addSubview:refreshLab];

            }else{
                [self.refreshLab removeFromSuperview];
            }
          [self.tableView reloadData];
          [self.tableView.header endRefreshing];
        } else {
          // 取消刷新
          [self.tableView.header endRefreshing];
          HSRefreshLab *refreshLab =
              [HSRefreshLab refreshLabelWithText:refreshLabText];

          CGFloat labelW = XBScreenWidth;
          CGFloat labelX = 0;
          CGFloat labelY = XBScreenHeight * 0.2;
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
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeCustomView;
        hud.labelText = @"网络错误";
        hud.customView = MBProgressHUDErrorView;
        [hud hide:YES afterDelay:2.0];
        hud.completionBlock = ^{
          HSRefreshLab *refreshLab = [HSRefreshLab
              refreshLabelWithText:
                  @"无法连接服务器，请检查网络连接是否正确"];
          CGFloat labelW = XBScreenWidth;
          CGFloat labelX = 0;
          CGFloat labelY = 10;
          CGFloat labelH = 20;
          refreshLab.frame = CGRectMake(labelX, labelY, labelW, labelH);
          weakSelf.refreshLab = refreshLab;
          [weakSelf.view addSubview:refreshLab];
        };
        [self.tableView reloadData];

        [self.tableView.header endRefreshing];
      }];
}

#pragma mark - HSDeclareCellDelegate
- (void)orderCell:(HSOrderCell *)orderCell
    leftButtonDidClickedAtIndexPath:(NSIndexPath *)indexPath {
  HSServiceOrder *serviceOrder = self.serviceOrder[indexPath.section];
  NSString *alertStr = [NSString
      stringWithFormat:
          @"您确定收到用户：%@所付的%@元的服务金额了吗?",
          serviceOrder.customerName, serviceOrder.servicePrice];
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                  message:alertStr
                                                 delegate:self
                                        cancelButtonTitle:@"取消"
                                        otherButtonTitles:@"确定", nil];
  [alert show];
  self.selectedIndexPath = indexPath;
}

- (void)alertView:(UIAlertView *)alertView
    clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (buttonIndex == 1) {
    // 创建hud
    hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"正在确认...";

    HSServiceOrder *serviceOrder =
        self.serviceOrder[self.selectedIndexPath.section];
    // 访问服务器
    AFHTTPRequestOperationManager *manager = (AFHTTPRequestOperationManager *)
        [HSHTTPRequestOperationManager manager];

    NSMutableDictionary *attrDict = [NSMutableDictionary dictionary];
    attrDict[@"orderNo"] = serviceOrder.orderNo;
    NSString *urlStr = [NSString
        stringWithFormat:@"%@/MobileServiceOrderAction?operation=_vetifyCash",
                         kHSBaseURL];
    [manager POST:urlStr
        parameters:attrDict
        success:^(AFHTTPRequestOperation *_Nonnull operation,
                  id _Nonnull responseObject) {
          if ([kServiceResponse isEqualToString:@"Success"]) {
            // hud
            hud.mode = MBProgressHUDModeCustomView;
            hud.labelText = @"确认成功";
            hud.customView = MBProgressHUDSuccessView;
            [hud hide:YES afterDelay:1.0];
            // 重载数据
            [self loadNewDataloadNewDataWithOrderStatus:self.orderStatus
                                         refreshLabText:self.refreshLabText];

          } else {
            // hud
            hud.mode = MBProgressHUDModeCustomView;
            hud.labelText = @"确认失败，请重新确认";
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
}

@end
