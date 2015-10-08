//
//  HSProvince.h
//  HousekeepingServer
//
//  Created by Jacob on 15/10/7.
//  Copyright © 2015年 com.jacob. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HSCity;
@interface HSProvince : NSObject
@property (strong, nonatomic) NSArray *citylist;
@property (copy, nonatomic) NSString *ID;
@property (copy, nonatomic) NSString *provinceName;

+ (instancetype)provinceWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;
@end
