//
//  HSServiceDeclare.h
//  HousekeepingServer
//
//  Created by Jacob on 15/10/9.
//  Copyright © 2015年 com.jacob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
/**
 *  
 customerID = yang123;
 customerName = "\U7b71\U7136";
 declareTime = "2015-10-09 02:21:03";
 id = 15;
 isAccepted = 0;
 orderNo = "";
 phoneNo = 18842424625;
 remarks = "";
 salary = "0.01";
 servantID = "";
 servantName = "";
 serviceAddress = "\U4e1c\U5317\U5927\U5b66";
 serviceCity = "\U6c88\U9633\U5e02";
 serviceCounty = "\U548c\U5e73\U533a";
 serviceLatitude = "41.7708615594819";
 serviceLongitude = "123.426010352616";
 serviceProvince = "\U8fbd\U5b81\U7701";
 serviceTime = "2015-10-14 06:20:30 +0000";
 serviceType = "\U6708\U5ac2";
 */
@interface HSServiceDeclare : NSObject
@property (copy, nonatomic) NSString *customerID;
@property (copy, nonatomic) NSString *customerName;
@property (copy, nonatomic) NSString *declareTime;
@property (assign, nonatomic)  int ID;
@property (assign, nonatomic, getter=isAccepted)  BOOL isAccepted;
@property (copy, nonatomic) NSString *orderNo;
@property (copy, nonatomic) NSString *phoneNo;
@property (copy, nonatomic) NSString *remarks;
@property (copy, nonatomic) NSString *salary;
@property (copy, nonatomic) NSString *servantID;
@property (copy, nonatomic) NSString *servantName;
@property (copy, nonatomic) NSString *serviceAddress;
@property (copy, nonatomic) NSString *serviceCity;
@property (copy, nonatomic) NSString *serviceCounty;
@property (copy, nonatomic) NSString *serviceLatitude;
@property (copy, nonatomic) NSString *serviceLongitude;
@property (copy, nonatomic) NSString *serviceProvince;
@property (copy, nonatomic) NSString *serviceTime;
@property (copy, nonatomic) NSString *serviceType;

- (NSDictionary *)toParams;
@end
