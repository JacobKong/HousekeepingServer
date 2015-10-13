//
//  HSServantTool.m
//  HousekeepingServer
//
//  Created by Jacob on 15/10/8.
//  Copyright © 2015年 com.jacob. All rights reserved.
//

#import "HSServantTool.h"
#import "HSServant.h"
#define HSServantFile [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject]stringByAppendingPathComponent:@"servant.data"]
@implementation HSServantTool
+ (void)saveServant:(HSServant *)servant{
    [NSKeyedArchiver archiveRootObject:servant toFile:HSServantFile];
}

+ (HSServant *)servant{
    HSServant *servant = [HSServant sharedServant];
    servant = [NSKeyedUnarchiver unarchiveObjectWithFile:HSServantFile];
    return servant;
}

+ (void)removeServant{
    NSFileManager *manager = [NSFileManager defaultManager];
    [manager removeItemAtPath:HSServantFile error:nil];
}
@end
