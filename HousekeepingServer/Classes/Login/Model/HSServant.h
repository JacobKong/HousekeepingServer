//
//  HSServant.h
//  HousekeepingServer
//
//  Created by Jacob on 15/10/8.
//  Copyright © 2015年 com.jacob. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  careerType = "\U65e0";
 clientClick = 0;
 contactAddress = "\U5c71\U897f\U592a\U539f";
 educationLevel = "\U672c\U79d1";
 emailAddress = "";
 headPicture = "upload/20151008/20151008115839836.png";
 holidayInMonth = 5;
 id = 15;
 idCardNo = 140108199502010814;
 isMarried = 1;
 isStayHome = 1;
 loginPassword = 123abc;
 phoneNo = 18502408510;
 qqNumber = 947124563;
 realLatitude = 0;
 realLongitude = 0;
 registerDate = "2015-10-08 11:58:39:835";
 registerLatitude = "41.653619";
 registerLongitude = "123.420758";
 servantAge = 20;
 servantBirthday = "1995-02-01";
 servantCategory = "";
 servantCity = "\U5317\U4eac";
 servantCounty = "\U4e1c\U57ce\U533a";
 servantGender = "\U7537";
 servantHonors = "\U65e0";
 servantID = jacob;
 servantIntro = "\U6d17\U7897\U5de5";
 servantMobil = 18502408510;
 servantName = "\U5b54\U4f1f\U6770";
 servantNationality = "\U6c49";
 servantProvince = "\U5317\U4eac";
 servantSalary = "";
 servantScore = 0;
 servantState = "";
 servantStatus = "\U7a7a\U95f2";
 serviceArea = "";
 serviceCount = 0;
 serviceItems = "\U6d17\U7897|\U6253\U626b";
 settleRate = "";
 trainingIntro = "\U65e0";
 workYears = 1;
 */
@interface HSServant : NSObject <NSCoding>
@property (copy, nonatomic) NSString *careerType;
@property (assign, nonatomic)  int clientClick;
@property (copy, nonatomic) NSString *contactAddress;
@property (copy, nonatomic) NSString *educationLevel;
@property (copy, nonatomic) NSString *emailAddress;
@property (copy, nonatomic) NSString *headPicture;
@property (assign, nonatomic)  int holidayInMonth;
@property (assign, nonatomic)  int id;
@property (copy, nonatomic) NSString *idCardNo;
@property (assign, nonatomic, getter=isMarried) BOOL isMarried;
@property (assign, nonatomic, getter=isStayHome) BOOL isStayHome;
@property (copy, nonatomic) NSString *loginPassword;
@property (assign, nonatomic)  long phoneNo;
@property (assign, nonatomic)  long qqNumber;
@property (assign, nonatomic)  double realLatitude;
@property (assign, nonatomic)  double realLongitude;
@property (copy, nonatomic) NSString *registerDate;
@property (copy, nonatomic) NSString *registerLatitude;
@property (copy, nonatomic) NSString *registerLongitude;
@property (assign, nonatomic)  int servantAge;
@property (copy, nonatomic) NSString *servantBirthday;
@property (copy, nonatomic) NSString *servantCategory;
@property (copy, nonatomic) NSString *servantCity;
@property (copy, nonatomic) NSString *servantCounty;
@property (copy, nonatomic) NSString *servantGender;
@property (copy, nonatomic) NSString *servantHonors;
@property (copy, nonatomic) NSString *servantID;
@property (copy, nonatomic) NSString *servantIntro;
@property (assign, nonatomic)  long servantMobil;
@property (copy, nonatomic) NSString *servantName;
@property (copy, nonatomic) NSString *servantNationality;
@property (copy, nonatomic) NSString *servantProvince;
@property (copy, nonatomic) NSString *servantSalary;
@property (copy, nonatomic) NSString *servantScore;
@property (copy, nonatomic) NSString *servantState;
@property (copy, nonatomic) NSString *servantStatus;
@property (copy, nonatomic) NSString *serviceArea;
@property (assign, nonatomic)  int serviceCount;
@property (copy, nonatomic) NSString *serviceItems;
@property (copy, nonatomic) NSString *settleRate;
@property (copy, nonatomic) NSString *trainingIntro;
@property (assign, nonatomic)  int workYears;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)servantWithDict:(NSDictionary *)dict;

+ (id)sharedServant;
@end
