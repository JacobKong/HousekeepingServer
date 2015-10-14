//
//  HSOrderBaseViewController.h
//  HousekeepingServer
//
//  Created by Jacob on 15/10/13.
//  Copyright © 2015年 com.jacob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSOrderCell.h"
#import "HSServiceOrder.h"
#import "HSServant.h"
#import "HSRefreshLab.h"
#import "HSServantTool.h"
#import "XBConst.h"
#import "MJRefresh.h"
#import "MJExtension.h"
#import "AFNetworking.h"
#import "HSHTTPRequestOperationManager.h"
#import "MBProgressHUD.h"

@interface HSOrderBaseViewController : UITableViewController<HSOrderCellDelegate>
/**
 *  服务人员
 */
@property (strong, nonatomic) HSServant *servant;
/**
 *  服务清单
 */
@property (strong, nonatomic) NSArray *serviceOrder;
/**
 *  刷新失败后的label
 */
@property(strong, nonatomic) HSRefreshLab *refreshLab;
/**
 *  左边按钮是否隐藏
 */
@property (assign, nonatomic, getter = isLeftBtnHidden)  BOOL leftBtnHiddn;
/**
 *  订单状态
 */
@property (copy, nonatomic) NSString *orderStatus;
/**
 *  refreshLabel蚊子内容
 */
@property (copy, nonatomic) NSString *refreshLabText;
- (void)setupRefreshView;
- (void)loadNewDataloadNewDataWithOrderStatus:(NSString *)orderStatus refreshLabText:(NSString *)refreshLabText;

@end
