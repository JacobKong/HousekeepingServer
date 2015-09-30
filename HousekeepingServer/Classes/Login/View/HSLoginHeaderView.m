//
//  HSLoginHeaderView.m
//  HousekeepingServer
//
//  Created by Jacob on 15/9/30.
//  Copyright (c) 2015年 com.jacob. All rights reserved.
//

#import "HSLoginHeaderView.h"
#import "XBConst.h"

@implementation HSLoginHeaderView
+ (instancetype)headerView{
    HSLoginHeaderView *iconView = [[HSLoginHeaderView alloc]init];
    iconView.backgroundColor = [UIColor clearColor];
    CGFloat iconViewW = XBScreenWidth;
    CGFloat iconViewH = XBScreenHeight * 0.3;
    iconView.frame = CGRectMake(0, 0, iconViewW, iconViewH);
    
    UIImageView *iconImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon"]];
    [iconImage sizeToFit];
    iconImage.center = iconView.center;
    [iconView addSubview:iconImage];
    return iconView;
}

@end
