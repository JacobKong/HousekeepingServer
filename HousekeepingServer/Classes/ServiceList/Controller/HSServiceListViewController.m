//
//  HSServiceListViewController.m
//  HousekeepingService
//
//  Created by Jacob on 15/9/19.
//  Copyright (c) 2015年 com.jacob. All rights reserved.
//

#import "HSServiceListViewController.h"
#import "HSAllViewController.h"
#import "HSUnpayedViewController.h"
#import "HSServingViewController.h"
#import "HSServedViewController.h"
#import "XBConst.h"
#define HSColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

@interface HSServiceListViewController ()

@end

@implementation HSServiceListViewController


//重载init方法
- (instancetype)init
{
    
    
    
    if (self = [super initWithTagViewHeight:40])
    {
        
    }
    return self;
}




- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //设置自定义属性
    CGFloat tagW = XBScreenWidth / 4;
    self.tagItemSize = CGSizeMake(tagW, 40);
//        self.selectedIndicatorSize = CGSizeMake(100, 10);
        self.selectedTitleColor = HSColor(234, 103, 7);
    self.selectedIndicatorColor = HSColor(234, 103, 7);
        self.selectedTitleFont = [UIFont systemFontOfSize:15];
    
        self.graceTime = 15;
    //    self.gapAnimated = YES;
    
    self.backgroundColor = [UIColor whiteColor];
    
    NSArray *titleArray = @[
                            @"全部",
                            @"待付款",
                            @"服务中",
                            @"服务完成",
                            ];
    
    NSArray *classNames = @[
                            [HSAllViewController class],
                            [HSUnpayedViewController class],
                            [HSServingViewController class],
                            [HSServedViewController class]
                            ];
    
    NSArray *params = @[
                        @"All",
                        @"Unpayed",
                        @"Serving",
                        @"Served"
                        ];
    
    
    [self reloadDataWith:titleArray andSubViewdisplayClasses:classNames withParams:params];
    
    
}




@end
