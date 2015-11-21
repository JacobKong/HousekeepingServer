//
//  HSAccount.h
//  HousekeepingServer
//
//  Created by Jacob on 15/10/3.
//  Copyright © 2015年 com.jacob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSAccount : NSObject<NSCoding>
@property (copy, nonatomic) NSString *servantItems; // 用户服务项目
@property (assign, nonatomic) int state; // 状态
- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)accountWithDict:(NSDictionary *)dict;

@end
