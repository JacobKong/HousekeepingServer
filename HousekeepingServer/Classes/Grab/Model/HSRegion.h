//
//  HSRegion.h
//  HousekeepingServer
//
//  Created by Jacob on 15/9/24.
//  Copyright (c) 2015年 com.jacob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSRegion : NSObject
@property (copy, nonatomic) NSString *areaName;
@property (copy, nonatomic) NSString *ID;

+ (instancetype)regionWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;

@end
