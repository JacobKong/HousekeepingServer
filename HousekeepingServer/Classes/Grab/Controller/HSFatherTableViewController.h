//
//  HSFatherTableViewController.h
//  HousekeepingServer
//
//  Created by Jacob on 15/10/12.
//  Copyright © 2015年 com.jacob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XBConst.h"
#import "HSServant.h"
#import "HSRefreshLab.h"
#import "MJRefresh.h"
#import "HSServantTool.h"

@interface HSFatherTableViewController : UITableViewController
@property (strong, nonatomic) HSServant *servant;
@property(strong, nonatomic) HSRefreshLab *refreshLab; // 刷新失败后现实的label

- (void)setupRefreshView;
- (void)loadNewData;
@end
