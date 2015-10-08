//
//  HSProvince.m
//  HousekeepingServer
//
//  Created by Jacob on 15/10/7.
//  Copyright © 2015年 com.jacob. All rights reserved.
//

#import "HSProvince.h"
#import "HSCity.h"

@implementation HSProvince
+ (instancetype)provinceWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        // 1.注入所有属性
        [self setValuesForKeysWithDictionary:dict];
        
        // 2.特殊处理friends属性
        NSMutableArray *cityArray = [NSMutableArray array];
        for (NSDictionary *dict in self.citylist) {
            HSCity *city = [HSCity cityWithDict:dict];
            [cityArray addObject:city];
        }
        self.citylist = cityArray;
    }
    return self;
}
@end
