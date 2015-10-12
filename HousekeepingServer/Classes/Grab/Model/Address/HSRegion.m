//
//  HSRegion.m
//  HousekeepingServer
//
//  Created by Jacob on 15/9/24.
//  Copyright (c) 2015年 com.jacob. All rights reserved.
//

#import "HSRegion.h"

@implementation HSRegion
+ (instancetype)regionWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        // 1.注入所有属性
        self.areaName = dict[@"areaName"];
        self.ID = dict[@"ID"];
    }
    return self;
}
@end
