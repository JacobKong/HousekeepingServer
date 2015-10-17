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
#import "HSDeclareCell.h"
#import "HSServiceDeclare.h"

@interface HSFatherTableViewController : UIViewController <HSDeclareCellDelegate, UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) HSServant *servant;
@property(strong, nonatomic) HSRefreshLab *refreshLab; // 刷新失败后现实的label
@property(strong, nonatomic) NSArray *serviceDeclare;
@property (assign, nonatomic, getter=isLeftBtnHidden)  BOOL leftBtnHiddn;
@property (assign, nonatomic, getter=isRightBtnHidden)  BOOL rightBtnHidden;

@property (strong, nonatomic) UITableView *tableView;
@property (weak, nonatomic) UIView *containerView;

@property (copy, nonatomic) NSString *leftBtnTitle;
@property (copy, nonatomic) NSString *rightBtnTitle;

- (void)setupRefreshView;
- (void)loadNewData;
@end
