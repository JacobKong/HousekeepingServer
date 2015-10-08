//
//  HSServant.h
//  HousekeepingServer
//
//  Created by Jacob on 15/10/8.
//  Copyright © 2015年 com.jacob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSServant : NSObject <NSCoding>
@property (copy, nonatomic) NSString *servantID;
@property (copy, nonatomic) NSString *idCardNo;
@property (copy, nonatomic) NSString *servantName;
@property (copy, nonatomic) NSString *loginPassword;
@property (copy, nonatomic) NSString *phoneNo;
@property (copy, nonatomic) NSString *servantMobil;
@property (copy, nonatomic) NSString *servantNationality;
@property (copy, nonatomic) NSString *isMarried;
@property (copy, nonatomic) NSString *educationLevel;
@property (copy, nonatomic) NSString *trainingIntro;
@property (copy, nonatomic) NSString *servantProvince;
@property (copy, nonatomic) NSString *servantCity;
@property (copy, nonatomic) NSString *servantCounty;
@property (copy, nonatomic) NSString *contactAddress;
@property (copy, nonatomic) NSString *registerLongitude;
@property (copy, nonatomic) NSString *registerLatitude;
@property (copy, nonatomic) NSString *qqNumber;
@property (copy, nonatomic) NSString *emailAddress;
@property (copy, nonatomic) NSString *servantGender;
@property (copy, nonatomic) NSString *workYears;
@property (copy, nonatomic) NSString *servantHonors;
@property (copy, nonatomic) NSString *servantIntro;
@property (copy, nonatomic) NSString *isStayHome;
@property (copy, nonatomic) NSString *holidayInMonth;
@property (copy, nonatomic) NSString *serviceItems;
@property (copy, nonatomic) NSString *careerType;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)servantWithDict:(NSDictionary *)dict;

@end
