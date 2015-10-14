//
//  HSServingViewController.m
//  HousekeepingServer
//
//  Created by Jacob on 15/9/25.
//  Copyright (c) 2015年 com.jacob. All rights reserved.
//

#import "HSServingViewController.h"
#import "XBConst.h"

@interface HSServingViewController (){
    MBProgressHUD *hud;
}

@end

@implementation HSServingViewController
- (void)setXBParam:(NSString *)XBParam
{
    _XBParam = XBParam;
    XBLog(@"HSServingViewController received param === %@",XBParam);
}

- (void)dealloc
{
    XBLog(@"HSServingViewController delloc");
}

- (void)viewDidLoad{
    self.tableView.rowHeight = 220;
    self.orderStatus = @"服务中";
    self.refreshLabText = @"目前尚无服务完成的订单，请刷新重试";
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 一进入该界面就开始刷新
}

@end
