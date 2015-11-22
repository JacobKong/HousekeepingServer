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

@interface HSReceiveViewController () <HSDeclareCellDelegate,
                                       UIAlertViewDelegate> {
  MBProgressHUD *hud;
}
@property(strong, nonatomic) NSIndexPath *selectedIndexPath;
@end

@implementation HSReceiveViewController

- (void)viewDidLoad {
  self.tableView.rowHeight = 310;
    CGRect tempFrame = self.tableView.frame;
    tempFrame.size.height = XBScreenHeight - 66;
    self.tableView.frame = tempFrame;
  self.rightBtnTitle = @"接单";
    // 设置badgeValue
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *receiveBadgeValue = [userDefaults objectForKey:ReceiveBadgeValueKey];
    if (receiveBadgeValue) {
        self.tabBarItem.badgeValue = receiveBadgeValue;
    }

  [super viewDidLoad];
  // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  // 一进入该界面就开始刷新
  [self setupRefreshView];
}

#pragma mark - 刷新
- (void)loadNewData {
  [super loadNewData];
  __weak __typeof(self) weakSelf = self;
  // 先移除label
  [self.refreshLab removeFromSuperview];
  // 访问服务器
    NSMutableDictionary *attrDict = [NSMutableDictionary dictionary];
    attrDict[@"servantID"] = self.servant.servantID;
    
    [[HS_NetAPIManager sharedManager]request_Recevice_DeclareWithParams:attrDict andBlock:^(id data, NSError *error) {
        if (data) {
            self.serviceDeclare = data;
            self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d", (int)self.serviceDeclare.count];
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
            } else {
                [self.refreshLab removeFromSuperview];
          }

            [self.tableView.header endRefreshing];
        }else{
            [NSObject showHudTipStr:@"似乎与服务器断开连接"];
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

#pragma mark - HSServiceCellDelegate
- (void)declareCell:(HSDeclareCell *)declareCell
    rightButtonDidClickedAtIndexPath:(NSIndexPath *)indexPath {
  [super declareCell:declareCell leftButtonDidClickedAtIndexPath:indexPath];
  // 创建hud
  hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view
                             animated:YES];
  hud.labelText = @"正在接单...";

  HSServiceDeclare *serviceDeclare = self.serviceDeclare[indexPath.section];
    serviceDeclare.servantID = self.servant.servantID;
    serviceDeclare.servantName = self.servant.servantName;
    
    [[HS_NetAPIManager sharedManager]request_Receive_WithParams:[serviceDeclare toParams] andBlock:^(id data, NSError *error) {
        [hud hide:YES];
        if (data) {
            if ([data isEqualToString:@"Success"]) {
                [NSObject showHudTipStr:@"接单成功"];
                [self loadNewData];
            }else{
                [NSObject showHudTipStr:@"接单失败"];
            }
        }else{
            [NSObject showHudTipStr:@"似乎与服务器断开连接"];
        }
    }];
}

- (void)declareCell:(HSDeclareCell *)declareCell
    leftButtonDidClickedAtIndexPath:(NSIndexPath *)indexPath {
  [super declareCell:declareCell rightButtonDidClickedAtIndexPath:indexPath];
  UIAlertView *alert =
      [[UIAlertView alloc] initWithTitle:@"提示"
                                 message:@"您确定拒绝该订单吗？"
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
    hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view
                               animated:YES];
    hud.labelText = @"正在拒单...";

    HSServiceDeclare *serviceDeclare =
        self.serviceDeclare[self.selectedIndexPath.section];
      NSMutableDictionary *attrDict = [NSMutableDictionary dictionary];
      attrDict[@"id"] = [NSString stringWithFormat:@"%d", serviceDeclare.ID];
      
      [[HS_NetAPIManager sharedManager]request_Recevice_RefuseWithParams:attrDict andBlock:^(id data, NSError *error) {
          [hud hide:YES];
          if (data) {
              if ([data isEqualToString:@"Success"]) {
                  [NSObject showHudTipStr:@"拒单成功"];
                  // 重载数据
                  [self loadNewData];

              }else{
                  [NSObject showHudTipStr:@"拒单失败"];
              }
          }else{
              [NSObject showHudTipStr:@"似乎与服务器断开连接"];
          }
      }];
    }
}
@end
