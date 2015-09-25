//
//  HSServingViewController.m
//  HousekeepingServer
//
//  Created by Jacob on 15/9/25.
//  Copyright (c) 2015年 com.jacob. All rights reserved.
//

#import "HSServingViewController.h"
#import "XBConst.h"

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
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor];
}

@end
