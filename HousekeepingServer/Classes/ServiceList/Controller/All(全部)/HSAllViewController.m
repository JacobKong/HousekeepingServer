//
//  HSAllViewController.m
//  HousekeepingServer
//
//  Created by Jacob on 15/9/25.
//  Copyright (c) 2015年 com.jacob. All rights reserved.
//

#import "HSAllViewController.h"
#import "XBConst.h"

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
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}
@end
