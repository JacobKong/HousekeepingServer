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

//NSDate转NSString
+ (NSString *)stringFromDate:(NSDate *)date
{
    
    //用于格式化NSDate对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设置格式：zzz表示时区
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //NSDate转NSString
    NSString *dateString = [dateFormatter stringFromDate:date];
    //输出currentDateString
    return dateString;
}

//NSString转NSDate
+ (NSDate *)dateFromString:(NSString *)string
{
    //设置转换格式
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //NSString转NSDate
    NSDate *date=[formatter dateFromString:string];
    return date;
}
@end
