//
//  HSAccount.h
//  HousekeepingServer
//
//  Created by Jacob on 15/10/3.
//  Copyright © 2015年 com.jacob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSAccount : NSObject<NSCoding>
//@property (copy, nonatomic) NSString *servantID; // 用户名
//@property (copy, nonatomic) NSString *loginPassword; // 密码
@property (copy, nonatomic) NSString *servantName; // 用户姓名
- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)accountWithDict:(NSDictionary *)dict;

@end
