//
//  HSMineTool.m
//  HousekeepingServer
//
//  Created by Jacob on 15/9/28.
//  Copyright (c) 2015年 com.jacob. All rights reserved.
//

#import "HSMineTool.h"
#define HSUserDefaults [NSUserDefaults standardUserDefaults]

@implementation HSMineTool
+ (void)setBool:(BOOL)b forKey:(NSString *)key
{
    [HSUserDefaults setBool:b forKey:key];
    [HSUserDefaults synchronize];
}

+ (BOOL)boolForKey:(NSString *)key
{
    return [HSUserDefaults boolForKey:key];
}

+ (void)setObject:(id)obj forKey:(NSString *)key
{
    [HSUserDefaults setObject:obj forKey:key];
    [HSUserDefaults synchronize];
}

+ (id)objectForKey:(NSString *)key
{
    return [HSUserDefaults objectForKey:key];
}

@end
