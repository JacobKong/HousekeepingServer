//
//  HSUnpayedViewController.m
//  HousekeepingServer
//
//  Created by Jacob on 15/9/25.
//  Copyright (c) 2015年 com.jacob. All rights reserved.
//

#import "HSUnpayedViewController.h"
#import "XBConst.h"

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
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor orangeColor];
}

@end
