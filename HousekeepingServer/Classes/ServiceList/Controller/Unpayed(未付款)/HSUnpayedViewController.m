//
//  HSUnpayedViewController.m
//  HousekeepingServer
//
//  Created by Jacob on 15/9/25.
//  Copyright (c) 2015年 com.jacob. All rights reserved.
//

#import "HSUnpayedViewController.h"
#import "XBConst.h"

@interface HSUnpayedViewController (){
    MBProgressHUD *hud;
}

@end

@implementation HSUnpayedViewController
- (void)setXBParam:(NSString *)XBParam
{
    _XBParam = XBParam;
    XBLog(@"HSUnpayedViewController received param === %@",XBParam);
}

- (void)dealloc
{
    XBLog(@"HSUnpayedViewController delloc");
}

- (void)viewDidLoad{
    self.tableView.rowHeight = 220;
    self.orderStatus = @"待付款";
    self.refreshLabText = @"目前尚无待付款的订单，请刷新重试";
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 一进入该界面就开始刷新
}
@end
