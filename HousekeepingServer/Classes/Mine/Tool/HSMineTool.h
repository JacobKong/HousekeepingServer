//
//  HSMineTool.h
//  HousekeepingServer
//
//  Created by Jacob on 15/9/28.
//  Copyright (c) 2015年 com.jacob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSMineTool : NSObject
+ (void)setBool:(BOOL)b forKey:(NSString *)key;
+ (BOOL)boolForKey:(NSString *)key;

+ (void)setObject:(id)obj forKey:(NSString *)key;
+ (id)objectForKey:(NSString *)key;

@end
