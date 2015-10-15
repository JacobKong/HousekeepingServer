//
//  HSInfoArrowItem.m
//  HousekeepingServer
//
//  Created by Jacob on 15/9/26.
//  Copyright (c) 2015年 com.jacob. All rights reserved.
//

#import "HSInfoArrowItem.h"

@implementation HSInfoArrowItem
+ (instancetype)itemWithIcon:(NSString *)icon
                       title:(NSString *)title
                 destVcClass:(__unsafe_unretained Class)destVcClass {
    HSInfoArrowItem *item = [[self alloc] init];
    item.icon = icon;
    item.title = title;
    item.destVcClass = destVcClass;
    return item;
}
+ (instancetype)itemWithTitle:(NSString *)title
                  destVcClass:(__unsafe_unretained Class)destVcClass {
    HSInfoArrowItem *item = [[self alloc] init];
    item.title = title;
    item.destVcClass = destVcClass;
    return item;
}

+ (instancetype)itemWithAttrTitle:(NSAttributedString *)title destVcClass:(__unsafe_unretained Class) destVcClass{
    HSInfoArrowItem *item = [[self alloc] init];
    item.attrTitle = title;
    item.destVcClass = destVcClass;
    return item;
}

+(instancetype)itemWithAttrTitle:(NSAttributedString *)title{
    HSInfoArrowItem *item = [[HSInfoArrowItem alloc]init];
    item.attrTitle = title;
    return item;
}

@end
