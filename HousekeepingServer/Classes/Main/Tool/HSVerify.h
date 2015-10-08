//
//  HSVerify.h
//  HousekeepingServer
//
//  Created by Jacob on 15/10/4.
//  Copyright © 2015年 com.jacob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSVerify : NSObject
/**
 *  验证身份证
 */
+ (BOOL)verifyIDCardNumber:(NSString *)value;
/**
 *  验证手机号
 */
+ (BOOL)verifyPhoneNumber:(NSString *)phone;
/**
 *  验证是否用户密码6-18位数字和字母组合
 */
+ (BOOL)verifyPassword:(NSString *)password;
@end
