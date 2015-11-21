//
//  NSObject+Common.h
//  HousekeepingServer
//
//  Created by Jacob on 15/11/21.
//  Copyright © 2015年 com.jacob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Common)
#pragma mark Tip M
+ (NSString *)tipFromError:(NSError *)error;
+ (BOOL)showError:(NSError *)error;
+ (void)showHudTipStr:(NSString *)tipStr;

#pragma mark BaseURL
+ (NSString *)baseURLStr;

@end
