//
//  HSInfoHeaderView.m
//  HousekeepingServer
//
//  Created by Jacob on 15/9/26.
//  Copyright (c) 2015年 com.jacob. All rights reserved.
//

#import "HSInfoHeaderView.h"
#import "XBConst.h"

@implementation HSInfoHeaderView
+ (instancetype)headerView{
    HSInfoHeaderView *infoView = [[HSInfoHeaderView alloc]init];
    infoView.backgroundColor = [UIColor whiteColor];
    CGFloat infoViewW = XBScreenWidth;
    CGFloat infoViewH = XBScreenHeight * 0.5;
    infoView.frame = CGRectMake(0, 0, infoViewW, infoViewH);
    
    UIImageView *iconImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon"]];
    [iconImage sizeToFit];
    iconImage.center = infoView.center;
    [infoView addSubview:iconImage];
    return infoView;
}



@end
