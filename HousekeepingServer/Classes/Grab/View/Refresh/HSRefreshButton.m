//
//  HSRefreshButton.m
//  HousekeepingServer
//
//  Created by Jacob on 15/10/9.
//  Copyright © 2015年 com.jacob. All rights reserved.
//

#import "HSRefreshButton.h"
#import "XBConst.h"

@implementation HSRefreshButton
+ (instancetype)refreshButton{
    HSRefreshButton *button = [HSRefreshButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"重新加载" forState:UIControlStateNormal];
    [button setTitleColor:XBMakeColorWithRGB(234, 103, 7, 1) forState:UIControlStateNormal];
    [button setTitleColor:XBMakeColorWithRGB(234, 103, 7, 1) forState:UIControlStateHighlighted];
    
    [button setBackgroundImage:[UIImage imageNamed:@"navigation_bg_dropdown_left"] forState:UIControlStateNormal];
    
    [button setBackgroundImage:[UIImage imageNamed:@"navigation_bg_dropdown_left_selected"] forState:UIControlStateSelected];

    return button;
}
@end
