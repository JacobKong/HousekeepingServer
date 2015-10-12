//
//  HSCoveredCountry.h
//  HousekeepingServer
//
//  Created by Jacob on 15/10/8.
//  Copyright © 2015年 com.jacob. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *              cityCode = C037;
 cityName = "\U6c88\U9633\U5e02";
 countyName = "\U548c\U5e73\U533a";
 id = 429;
 isCovered = 1;
 */
@interface HSCoveredCountry : NSObject
@property (copy, nonatomic) NSString *cityCode;
@property (copy, nonatomic) NSString *cityName;
@property (copy, nonatomic) NSString *countyName;
@property (assign, nonatomic)  int ID;
@property (assign, nonatomic, getter = isCovered)  BOOL isCovered;
@end
