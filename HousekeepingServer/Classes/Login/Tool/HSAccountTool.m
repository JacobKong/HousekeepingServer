//
//  HSAccountTool.m
//  HousekeepingServer
//
//  Created by Jacob on 15/10/3.
//  Copyright © 2015年 com.jacob. All rights reserved.
//

#import "HSAccountTool.h"
@implementation HSAccountTool
#define HSAccountFile [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]stringByAppendingPathComponent:@"account.data"]
+ (void)saveAccount:(HSAccount *)account{
    [NSKeyedArchiver archiveRootObject:account toFile:HSAccountFile];
}

+ (HSAccount *)account{
    HSAccount *account = [NSKeyedUnarchiver unarchiveObjectWithFile:HSAccountFile];
    return account;
}

+ (void)removeAccount{
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    [fileMgr removeItemAtPath:HSAccountFile error:nil];
}
@end
