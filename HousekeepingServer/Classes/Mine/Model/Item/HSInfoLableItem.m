//
//  HSInfoLableItem.m
//  HousekeepingServer
//
//  Created by Jacob on 15/9/29.
//  Copyright (c) 2015年 com.jacob. All rights reserved.
//

#import "HSInfoLableItem.h"

@implementation HSInfoLableItem
+ (instancetype)itemWithTitle:(NSAttributedString *)attrTitle{
    HSInfoLableItem *item = [[HSInfoLableItem alloc]init];
    item.attrTitle = attrTitle;
    return item;
}

- (void)setText:(NSString *)text
{
    _text = text;
}


@end
