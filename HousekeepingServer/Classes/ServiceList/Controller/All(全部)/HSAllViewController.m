//
//  HSAllViewController.m
//  HousekeepingServer
//
//  Created by Jacob on 15/9/25.
//  Copyright (c) 2015年 com.jacob. All rights reserved.
//

#import "HSAllViewController.h"


@interface HSAllViewController (){
    MBProgressHUD *hud;
}
@end

@implementation HSAllViewController
- (void)setXBParam:(NSString *)XBParam
{
    _XBParam = XBParam;
    XBLog(@"HSAllViewController.h received param === %@",XBParam);
}

- (void)dealloc
{
    XBLog(@"HSAllViewController.h delloc");
}

- (void)viewDidLoad{
    self.tableView.rowHeight = 220;
    self.refreshLabText = @"您没有任何订单，请刷新重试";
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 一进入该界面就开始刷新
}


@end
