//
//  HSServiceDeclare.m
//  HousekeepingServer
//
//  Created by Jacob on 15/10/9.
//  Copyright © 2015年 com.jacob. All rights reserved.
//

#import "HSServiceDeclare.h"

@implementation HSServiceDeclare
+ (NSDictionary *)replacedKeyFromPropertyName {
  return @{ @"ID" : @"id" };
}

- (NSDictionary *)toParams {
  return @{
    @"id" : [NSString stringWithFormat:@"%d", self.ID],
    @"customerID" :self.customerID,
    @"customerName" :self.customerName,
    @"servantID" :self.servantID,
    @"servantName" :self.servantName,
    @"contactAddress" :self.serviceAddress,
    @"contactPhone" :self.phoneNo,
    @"servicePrice" :self.salary,
    @"serviceType" :self.serviceType,
    @"serviceContent" :self.serviceType,
    @"remarks" :self.remarks
  };
}
@end
