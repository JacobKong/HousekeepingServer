//
//  HS_NetAPIManager.h
//  HousekeepingServer
//
//  Created by Jacob on 15/11/21.
//  Copyright © 2015年 com.jacob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HS_NetAPIManager : NSObject
+ (instancetype)sharedManager;
- (void)request_Login_WithParams:(id)params andBlock:(void (^)(id data, NSError *error))block;
- (void)request_Login_ServantInfoWithParams:(id)params andBlock:(void (^)(id data, NSError *error))block;
@end
