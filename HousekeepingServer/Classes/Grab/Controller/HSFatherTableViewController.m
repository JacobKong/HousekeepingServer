//
//  HSFatherTableViewController.m
//  HousekeepingServer
//
//  Created by Jacob on 15/10/12.
//  Copyright © 2015年 com.jacob. All rights reserved.
//

#import "HSFatherTableViewController.h"
@interface HSFatherTableViewController ()
@end

@implementation HSFatherTableViewController

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        self.tableView.backgroundColor = XBMakeColorWithRGB(234, 234, 234, 1);
    }
    return _tableView;
}
#pragma mark - tableView样式

- (void)viewDidLoad {
    UIView *containerView = [[UIView alloc] initWithFrame:self.view.frame];
    self.view = containerView;
    self.containerView = containerView;
    [self.containerView addSubview:self.tableView];
//    [self.view addSubview:self.tableView];
    [super viewDidLoad];
}

- (HSServant *)servant{
    if (!_servant) {
        _servant = [HSServantTool servant];
    }
    return _servant;
}

/**
 *  view即将显示时调用
 */
- (void)viewWillAppear:(BOOL)animated {
//    [self.tableView.header beginRefreshing];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.tableView.header endRefreshing];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.tableView.header endRefreshing];
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
    // 是否隐藏按钮
    if (self.leftBtnHiddn) {
        cell.leftBtn.hidden = YES;
    }else{
        cell.leftBtn.hidden = NO;
    }
    
    if (self.rightBtnHidden) {
        cell.rightBtn.hidden = YES;
    }else{
        cell.rightBtn.hidden = NO;
    }
    
    // 设置标题
    if (self.leftBtnTitle) {
        [cell.leftBtn setTitle:self.leftBtnTitle forState:UIControlStateNormal];
    }
    
    if (self.rightBtnTitle) {
        [cell.rightBtn setTitle:self.rightBtnTitle forState:UIControlStateNormal];
    }
    
    cell.serviceDeclare = self.serviceDeclare[indexPath.section];
    cell.delegate = self;
    cell.indexPath = indexPath;
    return cell;
}

- (void)setupRefreshView{
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

- (void)loadNewData{}

#pragma mark - HSDeclareCellDelegate
- (void)declareCell:(HSDeclareCell *)declareCell leftButtonDidClickedAtIndexPath:(NSIndexPath *)indexPath{
    
}
- (void)declareCell:(HSDeclareCell *)declareCell rightButtonDidClickedAtIndexPath:(NSIndexPath *)indexPath{
    
}
@end
