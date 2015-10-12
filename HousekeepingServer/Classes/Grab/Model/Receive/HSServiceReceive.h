//
//  HSServiceReceive.h
//  HousekeepingServer
//
//  Created by Jacob on 15/10/12.
//  Copyright © 2015年 com.jacob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSServiceReceive : NSObject
/**
 *   commentTime = "";
 confirmTime = "";
 contactAddress = "\U4e1c\U5317\U5927\U5b66";
 contactPhone = 18842424625;
 customPhone = "";
 customerID = yang123;
 customerName = "\U6de1\U6de1\U7684";
 id = 39;
 isSettled = 0;
 itemIDs = "";
 orderNo = "b66ab114-2991-46da-b6a0-cc596f8d2220";
 orderStatus = "\U5f85\U4ed8\U6b3e";
 orderTime = "2015-10-12 09:59:08";
 paidAmount = 0;
 payTime = "";
 payType = "";
 remarks = "";
 servantID = "";
 servantName = "";
 serviceContent = "";
 servicePrice = "0.009999999776482582";
 serviceType = "\U6708\U5ac2";
 settleDate = "";
 */
@property (copy, nonatomic) NSString *commentTime;
@property (copy, nonatomic) NSString *confirmTime;
@property (copy, nonatomic) NSString *contactAddress;
@property (assign, nonatomic)  long contactPhone;
@property (copy, nonatomic) NSString *customPhone;
@property (copy, nonatomic) NSString *customerID;
@property (copy, nonatomic) NSString *customerName;
@property (assign, nonatomic)  int ID;
@property (assign, nonatomic, getter= isSettled)  BOOL isSettled;
@property (copy, nonatomic) NSString *itemIDs;
@property (copy, nonatomic) NSString *orderNo;
@property (copy, nonatomic) NSString *orderStatus;
@property (copy, nonatomic) NSString *orderTime;
@property (assign, nonatomic)  int paidAmount;
@property (copy, nonatomic) NSString *payTime;
@property (copy, nonatomic) NSString *payType;
@property (copy, nonatomic) NSString *remarks;
@property (copy, nonatomic) NSString *servantID;
@property (copy, nonatomic) NSString *servantName;
@property (copy, nonatomic) NSString *serviceContent;
@property (copy, nonatomic) NSString *servicePrice;
@property (copy, nonatomic) NSString *serviceType;
@property (copy, nonatomic) NSString *settleDate;
@end
