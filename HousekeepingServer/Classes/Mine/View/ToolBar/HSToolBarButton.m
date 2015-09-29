//
//  HSToolBarButton.m
//  HousekeepingServer
//
//  Created by Jacob on 15/9/29.
//  Copyright (c) 2015年 com.jacob. All rights reserved.
//

#import "HSToolBarButton.h"
#import "XBConst.h"

@implementation HSToolBarButton
+ (instancetype)toolBarButtonWithTitle:(NSString *)title{
    HSToolBarButton *button = [HSToolBarButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 50, 44);
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:XBMakeColorWithRGB(234, 103, 7, 1) forState:UIControlStateNormal];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    return button;
}
@end
