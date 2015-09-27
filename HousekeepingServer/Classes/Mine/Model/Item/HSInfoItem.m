//
//  HSInfoItem.m
//  HousekeepingServer
//
//  Created by Jacob on 15/9/26.
//  Copyright (c) 2015年 com.jacob. All rights reserved.
//

#import "HSInfoItem.h"

@implementation HSInfoItem
+(instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title{
    HSInfoItem *item = [[HSInfoItem alloc]init];
    item.icon = icon;
    item.title = title;
    return item;
}
+(instancetype)itemWithTitle:(NSString *)title{
    HSInfoItem *item = [[HSInfoItem alloc]init];
    item.title = title;
    return item;
}


@end
