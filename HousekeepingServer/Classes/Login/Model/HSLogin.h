//
//  HSLogin.h
//  HousekeepingServer
//
//  Created by Jacob on 15/11/22.
//  Copyright © 2015年 com.jacob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSLogin : NSObject
@property (copy, nonatomic) NSString *servantID;
@property (copy, nonatomic) NSString *loginPassword;

- (NSDictionary *)toParams;
@end
