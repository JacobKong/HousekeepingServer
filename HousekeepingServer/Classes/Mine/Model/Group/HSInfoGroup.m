//
//  HSInfoGroup.m
//  HousekeepingServer
//
//  Created by Jacob on 15/9/26.
//  Copyright (c) 2015年 com.jacob. All rights reserved.
//

#import "HSInfoGroup.h"

@implementation HSInfoGroup
+ (instancetype)groupWithItems:(NSArray *)items{
    HSInfoGroup *group = [[self alloc]init];
    group.items = items;
    return group;
}
@end
