//
//  HSBaseViewController.m
//  HousekeepingServer
//
//  Created by Jacob on 15/9/26.
//  Copyright (c) 2015年 com.jacob. All rights reserved.
//

#import "HSBaseViewController.h"
#import "HSInfoItem.h"
#import "HSInfoGroup.h"
#import "HSInfoTableViewCell.h"
#import "HSInfoArrowItem.h"
#import "XBConst.h"
#import "HSNoBorderTextField.h"
#import "HSInfoTextFieldItem.h"


@interface HSBaseViewController ()<UIGestureRecognizerDelegate>
@end

@implementation HSBaseViewController
//- (instancetype)init
//{
//    self = [super init];
//    if (self) {
//        return [super initWithStyle:UITableViewStyleGrouped];
//
//    }
//    return self;
//}
//
//- (id)initWithStyle:(UITableViewStyle)style{
//    return [super initWithStyle:UITableViewStyleGrouped];
//}
//
//- (NSMutableArray *)data{
//    if (!_data) {
//        _data = [NSMutableArray array];
//    }
//    return _data;
//}

- (void)viewDidLoad{
    [super viewDidLoad];
    // Create manager
    //
    self.manager = [[RETableViewManager alloc] initWithTableView:self.tableView
                                                        delegate:self];
    
    // 设置actionBar的颜色
    [[REActionBar appearance] setTintColor:[UIColor orangeColor]];
    
    // 背景颜色
    self.tableView.backgroundColor = XBMakeColorWithRGB(234, 234, 234, 1);
    
}

//
//- (void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    self.tableView.backgroundColor = XBMakeColorWithRGB(234, 234, 234, 1);
//    
//}
//
//#pragma mark - Table view data source
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    // Return the number of sections.
//    return self.data.count;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView
// numberOfRowsInSection:(NSInteger)section {
//    // Return the number of rows in the section.
//    HSInfoGroup *group = self.data[section];
//    return group.items.count;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView
//         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    // 1.创建cell
//    HSInfoTableViewCell *cell =
//    [HSInfoTableViewCell cellWithTableView:tableView];
//    HSInfoGroup *group = self.data[indexPath.section];
//    cell.item = group.items[indexPath.row];
//    self.cell = cell;
//    // Configure the cell...
//    
//    return cell;
//}
//
///**
// *  选中某一行跳转
// */
//- (void)tableView:(UITableView *)tableView
//didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    // 1.取消选中这行
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    
//    // 数据模型
//    HSInfoGroup *group = self.data[indexPath.section];
//    HSInfoItem *item = group.items[indexPath.row];
//    if (item.option && item.enable == YES) {
//        item.option();
//        return;
//    } else if ([item isKindOfClass:[HSInfoArrowItem class]]) {
//        HSInfoArrowItem *arrowitem = (HSInfoArrowItem *)item;
//        // 如果没有需要跳转的控制器
//        if (arrowitem.destVcClass){
//        UIViewController *destVC = [[arrowitem.destVcClass alloc] init];
//        destVC.title = item.title;
//        [self.navigationController pushViewController:destVC animated:YES];
//        }
//    }
//    return;
//}
//
//- (NSString *)tableView:(UITableView *)tableView
//titleForHeaderInSection:(NSInteger)section {
//    HSInfoGroup *group = self.data[section];
//    return group.header;
//}
//
//- (NSString *)tableView:(UITableView *)tableView
//titleForFooterInSection:(NSInteger)section {
//    HSInfoGroup *group = self.data[section];
//    return group.footer;
//}
//
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 44;
//}

@end
