//
//  HSCity.m
//  HousekeepingServer
//
//  Created by Jacob on 15/10/7.
//  Copyright © 2015年 com.jacob. All rights reserved.
//

#import "HSCity.h"
#import "HSRegion.h"

@implementation HSCity
+ (instancetype)cityWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        // 1.注入所有属性
        [self setValuesForKeysWithDictionary:dict];
        
        // 2.特殊处理arealist属性
        NSMutableArray *areaArray = [NSMutableArray array];
        for (NSDictionary *dict in self.arealist) {
            HSRegion *region = [HSRegion regionWithDict:dict];
            [areaArray addObject:region];
        }
        self.arealist = areaArray;
    }
    return self;
}

@end
