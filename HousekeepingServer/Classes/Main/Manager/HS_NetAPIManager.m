//
//  HS_NetAPIManager.m
//  HousekeepingServer
//
//  Created by Jacob on 15/11/21.
//  Copyright © 2015年 com.jacob. All rights reserved.
//

#import "HS_NetAPIManager.h"
#import "HS_NetAPIClient.h"
#import "HSAccount.h"
#import "HSAccountTool.h"
#import "XBConst.h"
#import "MJExtension.h"
#import "HSServant.h"
#import "HSServantTool.h"
#import "HSService.h"
#import "HSCoveredCountry.h"
#import "HSServiceDeclare.h"

@implementation HS_NetAPIManager
+ (instancetype)sharedManager {
  static HS_NetAPIManager *shared_manager = nil;
  static dispatch_once_t pred;
  dispatch_once(&pred, ^{
    shared_manager = [[self alloc] init];
  });
  return shared_manager;
}
#pragma mark - 登录
- (void)request_Login_WithParams:(id)params
                        andBlock:(void (^)(id data, NSError *error))block {
  NSString *path = @"NationalService/MobileServantInfoAction?operation=_login";
  [[HS_NetAPIClient sharedJsonClient]
      requestJsonDataWithPath:path
                   withParams:params
               withMethodType:Post
                autoShowError:NO
                     andBlock:^(id data, NSError *error) {
                       if (kServerResponse) {
                         if ([kServerResponse isEqualToString:@"Success"]) {
                           // 创建模型
                           HSAccount *account =
                               [HSAccount objectWithKeyValues:data];
                           // 存储模型数据
                           [HSAccountTool saveAccount:account];
                         }
                         block(kServerResponse, nil);
                       } else {
                         block(nil, error);
                       }
                     }];
}

- (void)request_Login_ServantInfoWithParams:
            (id)params andBlock:(void (^)(id data, NSError *error))block {
  NSString *path =
      @"NationalService/MobileServantInfoAction?operation=_queryByServantID";
  [[HS_NetAPIClient sharedJsonClient]
      requestJsonDataWithPath:path
                   withParams:params
               withMethodType:Post
                autoShowError:NO
                     andBlock:^(id data, NSError *error) {
                       if (kServerResponse) {
                         if ([kServerResponse isEqualToString:@"Success"]) {
                           // 创建模型
                           HSServant *servant = [HSServant
                               objectWithKeyValues:kServerDataResponse];
                           // 存储模型
                           [HSServantTool saveServant:servant];
                         }
                         block(kServerResponse, nil);
                       } else {
                         block(nil, error);
                       }
                     }];
}

#pragma mark - 注册
- (void)request_Register_CheckServantIDWithParams:
            (id)params andBlock:(void (^)(id data, NSError *error))block {
  NSString *path =
      @"NationalService/MobileServantInfoAction?operation=_checkServantID";
  [[HS_NetAPIClient sharedJsonClient]
      requestJsonDataWithPath:path
                   withParams:params
               withMethodType:Post
                autoShowError:NO
                     andBlock:^(id data, NSError *error) {
                       if (kServerResponse) {
                         block(kServerResponse, nil);
                       } else {
                         block(nil, error);
                       }
                     }];
}

- (void)request_Register_WithParams:(id)params
                        headPicture:(UIImage *)headPicture
                           andBlock:(void (^)(id data, NSError *error))block {
  NSString *path =
      @"NationalService/MoblieServantRegisteAction?operation=_register";

  NSDictionary *fileDic;
  if (headPicture) {
    fileDic = @{
      @"image" : headPicture,
      @"name" : @"icon",
      @"fileName" : @"icon.jpg"
    };
  }

  [[HS_NetAPIClient sharedJsonClient]
      requestJsonDataWithPath:path
                         file:fileDic
                   withParams:params
               withMethodType:Post
                     andBlock:^(id data, NSError *error) {
                       if (kServerResponse) {
                         if ([kServerResponse isEqualToString:@"Success"]) {
                           // 创建模型
                           HSServant *servant = [HSServant
                               objectWithKeyValues:kServerDataResponse];
                           // 存档
                           [HSServantTool saveServant:servant];
                         }
                         block(kServerResponse, nil);
                       } else {
                         block(nil, error);
                       }

                     }];
}
#pragma mark - 服务项目
- (void)request_ServiceItemWithParams:(id)params
                             andBlock:(void (^)(id data, NSError *error))block {
  NSString *path = @"NationalService/MobileServiceTypeAction?operation=_query";
  [[HS_NetAPIClient sharedJsonClient]
      requestJsonDataWithPath:path
                   withParams:params
               withMethodType:Post
                autoShowError:NO
                     andBlock:^(id data, NSError *error) {
                       if (kServerResponse) {
                         NSArray *serviceArray = [HSService
                             objectArrayWithKeyValuesArray:kServerDataResponse];
                         block(serviceArray, nil);
                       } else {
                         block(nil, error);
                       }
                     }];
}

#pragma mark - 抢单
- (void)request_Grab_CountyWithParams:(id)params
                             andBlock:(void (^)(id data, NSError *error))block {
  NSString *path = @"NationalService/MobileCountyInfoAction?operation=_query";
  [[HS_NetAPIClient sharedJsonClient]
      requestJsonDataWithPath:path
                   withParams:params
               withMethodType:Post
                autoShowError:NO
                     andBlock:^(id data, NSError *error) {
                       if (kServerResponse) {
                          NSArray *regionArray = [HSCoveredCountry objectArrayWithKeyValuesArray:kServerDataResponse];
                           block(regionArray, nil);
                       } else {
                         block(nil, error);
                       }
                     }];
}

- (void)request_Grab_StatusWithParams:(id)params
                             andBlock:(void (^)(id data, NSError *error))block {
  NSString *path =
      @"NationalService/MobileServantInfoAction?operation=_modifyStatus";
  [[HS_NetAPIClient sharedJsonClient]
      requestJsonDataWithPath:path
                   withParams:params
               withMethodType:Post
                autoShowError:NO
                     andBlock:^(id data, NSError *error) {
                         NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                       if (kServerResponse) {
                           if ([kServerResponse isEqualToString:@"Success"]) {
                               NSString *titleStr = [NSString
                                                     stringWithFormat:@"当前%@", params[@"servantStatus"]];
                               // 存储状态
                               [defaults setObject:titleStr forKey:StatusStrKey];
                               [defaults synchronize];
                               block(titleStr, nil);
                           }else{
                               block(kServerResponse, nil);
                           }
                       } else {
                         block(nil, error);
                       }
                     }];
}

- (void)request_Grab_DeclareWithParams:
            (id)params andBlock:(void (^)(id data, NSError *error))block {
  NSString *path = @"NationalService/"
                   @"MobileServiceDeclareAction?operation=_"
                   @"queryserviceDeclare";
  [[HS_NetAPIClient sharedJsonClient]
      requestJsonDataWithPath:path
                   withParams:params
               withMethodType:Post
                autoShowError:NO
                     andBlock:^(id data, NSError *error) {
                       if (kServerResponse) {
                           if ([kServerResponse isEqualToString:@"Success"]) {
                               NSArray *serviceDelcareArray =
                               [HSServiceDeclare objectArrayWithKeyValuesArray:kServerDataResponse];
                               // 存储badgeValue
                               NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                               [defaults
                                setObject:[NSString
                                           stringWithFormat:@"%d",
                                           (int)serviceDelcareArray.count]
                                forKey:GrabBadgeValueKey];
                               [defaults synchronize];
                               block(serviceDelcareArray, nil);
                           }else{
                               // 存储badgeValue
                               NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                               [defaults
                                setObject:@"0"
                                forKey:GrabBadgeValueKey];
                               [defaults synchronize];
                               
                               block(kServerResponse, nil);
                           }
                       } else {
                         block(nil, error);
                       }
                     }];
}

- (void)request_Grab_WithParams:(id)params
                       andBlock:(void (^)(id data, NSError *error))block {
  NSString *path = @"NationalService/MobileServiceOrderAction?operation=_add";
  [[HS_NetAPIClient sharedJsonClient]
      requestJsonDataWithPath:path
                   withParams:params
               withMethodType:Post
                autoShowError:NO
                     andBlock:^(id data, NSError *error) {
                       if (kServerResponse) {
                           block(kServerResponse, nil);
                       } else {
                         block(nil, error);
                       }
                     }];
}
@end
