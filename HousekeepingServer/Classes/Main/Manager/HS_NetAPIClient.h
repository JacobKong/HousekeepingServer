//
//  HS_NetAPIClient.h
//  HousekeepingServer
//
//  Created by Jacob on 15/11/21.
//  Copyright © 2015年 com.jacob. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
typedef enum { Get = 0, Post, Put, Delete } NetworkMethod;

@interface HS_NetAPIClient : AFHTTPRequestOperationManager
+ (id)sharedJsonClient;

- (void)requestJsonDataWithPath:(NSString *)aPath
                     withParams:(NSDictionary *)params
                 withMethodType:(NetworkMethod)method
                       andBlock:(void (^)(id data, NSError *error))block;

- (void)requestJsonDataWithPath:(NSString *)aPath
                     withParams:(NSDictionary *)params
                 withMethodType:(NetworkMethod)method
                  autoShowError:(BOOL)autoShowError
                       andBlock:(void (^)(id data, NSError *error))block;

- (void)requestJsonDataWithPath:(NSString *)aPath
                           file:(NSDictionary *)file
                     withParams:(NSDictionary *)params
                 withMethodType:(NetworkMethod)method
                       andBlock:(void (^)(id data, NSError *error))block;

@end
