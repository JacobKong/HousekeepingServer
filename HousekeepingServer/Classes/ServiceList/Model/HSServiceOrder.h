//
//  HServiceOrder.h
//  HousekeepingServer
//
//  Created by Jacob on 15/10/13.
//  Copyright © 2015年 com.jacob. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  
 commentTime = ""; 评价时间
 confirmTime = ""; 确认时间
 contactAddress = "\U4e1c\U5317\U5927\U5b66";  通讯地址
 contactPhone = 18842424625; 联系电话
 customPhone = "";
 customerID = yang123; 客户ID
 customerName = "\U7b71\U7136"; 客户姓名
 id = 57; order的id
 isSettled = 0; 是否结算
 itemIDs = "";
 orderNo = "f096a6fe-27e4-4ab1-874a-449b4abdba59";
 orderStatus = "\U5f85\U4ed8\U6b3e";
 orderTime = "2015-10-12 17:59:19";
 paidAmount = 0;
 payTime = "";
 payType = "";
 remarks = "";
 servantID = jacob;
 servantName = "\U5b54\U4f1f\U6770";
 serviceContent = "";
 servicePrice = "0.009999999776482582";
 serviceType = "\U6708\U5ac2";
 settleDate = "";
 */
@interface HSServiceOrder : NSObject
@property (copy, nonatomic) NSString *commentTime;
@property (copy, nonatomic) NSString *confirmTime;
@property (copy, nonatomic) NSString *contactAddress;
@property (assign, nonatomic)  long contactPhone;
@property (copy, nonatomic) NSString *customPhone;
@property (copy, nonatomic) NSString *customerID;
@property (copy, nonatomic) NSString *customerName;
@property (assign, nonatomic)  int ID;
@property (assign, nonatomic, getter = isSettled)  BOOL isSettled;
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
