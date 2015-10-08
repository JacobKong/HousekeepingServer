//
//  HSAccountTool.h
//  HousekeepingServer
//
//  Created by Jacob on 15/10/3.
//  Copyright © 2015年 com.jacob. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HSAccount;
@interface HSAccountTool : NSObject
+ (void)saveAccount:(HSAccount *) account;
+ (HSAccount *)account;
+ (void)removeAccount;
@end
