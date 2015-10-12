//
//  HSRefreshLab.m
//  HousekeepingServer
//
//  Created by Jacob on 15/10/11.
//  Copyright © 2015年 com.jacob. All rights reserved.
//

#import "HSRefreshLab.h"

@implementation HSRefreshLab
+ (instancetype)refreshLabelWithText:(NSString *) text{
    HSRefreshLab *label = [[HSRefreshLab alloc]init];
    label.text = text;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor lightGrayColor];
    return label;
}

@end
