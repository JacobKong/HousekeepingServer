//
//  HSServedViewController.m
//  HousekeepingServer
//
//  Created by Jacob on 15/9/25.
//  Copyright (c) 2015年 com.jacob. All rights reserved.
//

#import "HSServedViewController.h"
#import "XBConst.h"

@implementation HSServedViewController
- (void)setXBParam:(NSString *)XBParam
{
    _XBParam = XBParam;
    XBLog(@"HSServedViewController received param === %@",XBParam);
}

- (void)dealloc
{
    XBLog(@"HSServedViewController delloc");
}
- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blueColor];
}

@end
