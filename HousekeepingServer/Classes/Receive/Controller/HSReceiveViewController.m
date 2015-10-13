//
//  HSReceiveViewController.m
//  HousekeepingService
//
//  Created by Jacob on 15/9/19.
//  Copyright (c) 2015年 com.jacob. All rights reserved.
//

#import "HSReceiveViewController.h"
#import "HSHTTPRequestOperationManager.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "MJExtension.h"
#import "HSServiceDeclare.h"

@interface HSReceiveViewController ()<HSDeclareCellDelegate, UIAlertViewDelegate>{
    MBProgressHUD *hud;
}
@property (strong, nonatomic) NSIndexPath *selectedIndexPath;
@end

@implementation HSReceiveViewController

- (void)viewDidLoad {
    self.tableView.rowHeight = 330;
    self.rightBtnTitle = @"接单";
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController *vc = [[UIViewController alloc] init];
    vc.view.backgroundColor = [UIColor blueColor];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 刷新
- (void)loadNewData{
    [super loadNewData];
    __weak __typeof(self) weakSelf = self;
    // 先移除label
    [self.refreshLab removeFromSuperview];
    // 访问服务器
    AFHTTPRequestOperationManager *manager =
    (AFHTTPRequestOperationManager *)[HSHTTPRequestOperationManager manager];
    NSMutableDictionary *attrDict = [NSMutableDictionary dictionary];
    attrDict[@"servantID"] = self.servant.servantID;
    NSString *urlStr = [NSString
                        stringWithFormat:
                        @"%@/MobileServiceDeclareAction?operation=_queyOwnservice",
                        kHSBaseURL];
    [manager POST:urlStr
       parameters:attrDict
          success:^(AFHTTPRequestOperation *_Nonnull operation,
                    id _Nonnull responseObject) {
              [MBProgressHUD hideHUDForView:self.view animated:YES];
              if ([kServiceResponse isEqualToString:@"Success"]) {
                  self.serviceDeclare = [HSServiceDeclare objectArrayWithKeyValuesArray:kDataResponse];
                  NSLog(@"%@", self.serviceDeclare);
                  [self.tableView reloadData];
                  if (self.serviceDeclare.count == 0) {
                      HSRefreshLab *refreshLab = [HSRefreshLab
                                                  refreshLabelWithText:
                                                  @"目前没有您的接单，请刷新重试"];
                      
                      CGFloat labelW = XBScreenWidth;
                      CGFloat labelX = 0;
                      CGFloat labelY = XBScreenHeight * 0.3;
                      CGFloat labelH = 20;
                      refreshLab.frame = CGRectMake(labelX, labelY, labelW, labelH);
                      self.refreshLab = refreshLab;
                      [self.view addSubview:refreshLab];
                  }
                  [self.tableView.header endRefreshing];
              } else {
                  // 取消刷新
                  [self.tableView.header endRefreshing];
                  HSRefreshLab *refreshLab = [HSRefreshLab
                                              refreshLabelWithText:
                                              @"目前没有您的接单，请刷新重试"];
                  
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

#pragma mark - HSServiceCellDelegate
- (void)declareCell:(HSDeclareCell *)declareCell rightButtonDidClickedAtIndexPath:(NSIndexPath *)indexPath{
    [super declareCell:declareCell leftButtonDidClickedAtIndexPath:indexPath];
    // 创建hud
    hud = [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
    hud.labelText = @"正在接单...";
    
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
                  hud.labelText = @"接单成功";
                  hud.customView = MBProgressHUDSuccessView;
                  [hud hide:YES afterDelay:1.0];
                  // 重载数据
                  [self loadNewData];
                  
              } else {
                  // hud
                  hud.mode = MBProgressHUDModeCustomView;
                  hud.labelText = @"接单失败";
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

- (void)declareCell:(HSDeclareCell *)declareCell leftButtonDidClickedAtIndexPath:(NSIndexPath *)indexPath{
    [super declareCell:declareCell rightButtonDidClickedAtIndexPath:indexPath];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您确定拒绝该订单吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
    self.selectedIndexPath = indexPath;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        // 创建hud
        hud = [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
        hud.labelText = @"正在拒单...";
        
        HSServiceDeclare *serviceDeclare = self.serviceDeclare[self.selectedIndexPath.section];
        // 访问服务器
        AFHTTPRequestOperationManager *manager =
        (AFHTTPRequestOperationManager *)[HSHTTPRequestOperationManager manager];
        
        NSMutableDictionary *attrDict = [NSMutableDictionary dictionary];
        attrDict[@"id"] = [NSString stringWithFormat:@"%d", serviceDeclare.ID];
        
        NSString *urlStr =
        [NSString stringWithFormat:@"%@/MobileServiceDeclareAction?operation=_refuse",
         kHSBaseURL];
        [manager POST:urlStr
           parameters:attrDict
              success:^(AFHTTPRequestOperation *_Nonnull operation,
                        id _Nonnull responseObject) {
                  if ([kServiceResponse isEqualToString:@"Success"]) {
                      // hud
                      hud.mode = MBProgressHUDModeCustomView;
                      hud.labelText = @"拒单成功";
                      hud.customView = MBProgressHUDSuccessView;
                      [hud hide:YES afterDelay:1.0];
                      // 重载数据
                      [self loadNewData];
                      
                  } else {
                      // hud
                      hud.mode = MBProgressHUDModeCustomView;
                      hud.labelText = @"拒单失败";
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
}
@end
