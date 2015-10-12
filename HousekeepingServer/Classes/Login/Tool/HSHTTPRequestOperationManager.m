//
//  HSHTTPRequestOperationManager.m
//  HousekeepingServer
//
//  Created by Jacob on 15/10/5.
//  Copyright © 2015年 com.jacob. All rights reserved.
//

#import "HSHTTPRequestOperationManager.h"
#import "AFNetworking.h"

@implementation HSHTTPRequestOperationManager
+ (instancetype)manager{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    manager.requestSerializer.timeoutInterval = 20.f;
    return (HSHTTPRequestOperationManager *)manager;
}
@end
