//
//  HS_NetAPIManager.h
//  HousekeepingServer
//
//  Created by Jacob on 15/11/21.
//  Copyright © 2015年 com.jacob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface HS_NetAPIManager : NSObject
+ (instancetype)sharedManager;
// 登录
- (void)request_Login_WithParams:(id)params andBlock:(void (^)(id data, NSError *error))block;
- (void)request_Login_ServantInfoWithParams:(id)params andBlock:(void (^)(id data, NSError *error))block;
// 注册
- (void)request_Register_CheckServantIDWithParams:(id)params andBlock:(void (^)(id data, NSError *error))block;
//- (void)request_Register_WithParams:(id)params headPicture:(NSDictionary *)headPictureFile andBlock:(void (^)(id data, NSError *error))block;
- (void)request_Register_WithParams:(id)params headPicture:(UIImage *)headPicture andBlock:(void (^)(id data, NSError *error))block;

// 服务项目
- (void)request_ServiceItemWithParams:(id)params andBlock:(void (^)(id data, NSError *error))block;

// 抢单
- (void)request_Grab_CountyWithParams:(id)params andBlock:(void (^)(id data, NSError *error))block;
- (void)request_Grab_StatusWithParams:(id)params andBlock:(void (^)(id data, NSError *error))block;
- (void)request_Grab_DeclareWithParams:(id)params andBlock:(void (^)(id data, NSError *error))block;
- (void)request_Grab_WithParams:(id)params andBlock:(void (^)(id data, NSError *error))block;
@end
