//
//  HSCity.h
//  HousekeepingServer
//
//  Created by Jacob on 15/10/7.
//  Copyright © 2015年 com.jacob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSCity : NSObject
@property (strong, nonatomic) NSArray *arealist;
@property (copy, nonatomic) NSString *cityName;
@property (copy, nonatomic) NSString *ID;

+ (instancetype)cityWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;

@end
