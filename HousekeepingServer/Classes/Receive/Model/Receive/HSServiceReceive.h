//
//  HSServiceReceive.h
//  HousekeepingServer
//
//  Created by Jacob on 15/10/12.
//  Copyright © 2015年 com.jacob. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *
 customerID = yang123;
 customerName = "\U6de1\U6de1\U7684";
 declareTime = "2015-10-11 02:55:46";
 id = 20;
 isAccepted = 0;
 orderNo = "";
 phoneNo = 123456789;
 remarks = "\U4e0d\U8981\U6765\Uff01\Uff01";
 salary = 100;
 servantID = jacob;
 servantName = "";
 serviceAddress = "\U6587\U5316\U8def3\U5df711\U53f7";
 serviceCity = "\U6c88\U9633\U5e02";
 serviceCounty = "\U548c\U5e73\U533a";
 serviceLatitude = "41.7708615594819";
 serviceLongitude = "123.426010352616";
 serviceProvince = "\U8fbd\U5b81\U7701";
 serviceTime = "2015-10-03 06:50:13 +0000";
 serviceType = "\U6708\U5ac2";
 */

@interface HSServiceReceive : NSObject
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
@end
