//
//  HSServant.m
//  HousekeepingServer
//
//  Created by Jacob on 15/10/8.
//  Copyright © 2015年 com.jacob. All rights reserved.
//

#import "HSServant.h"
#import <objc/runtime.h>

@implementation HSServant
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"ID":@"id"};
}

- (instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)servantWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
}

#pragma mark - 归档解党
/**
 *  解档
 */
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        unsigned int count = 0;
        // 获取类中所有成员变量名
        Ivar *ivar = class_copyIvarList([HSServant class], &count);
        for (int i = 0; i < count; i++) {
            Ivar iva = ivar[i];
            const char *name = ivar_getName(iva);
            NSString *strName = [NSString stringWithUTF8String:name];
            // 进行解档读值
            id value = [coder decodeObjectForKey:strName];
            // 利用KVC赋值
            [self setValue:value forKey:strName];
        }
        free(ivar);
    }
    return self;
}

/**
 *  归档
 */
- (void)encodeWithCoder:(NSCoder *)aCoder{
    unsigned int count;
    Ivar *ivar = class_copyIvarList([HSServant class], &count);
    for (int i=0; i<count; i++) {
        Ivar iv = ivar[i];
        const char *name = ivar_getName(iv);
        NSString *strName = [NSString stringWithUTF8String:name];
        //利用KVC取值
        id value = [self valueForKey:strName];
        [aCoder encodeObject:value forKey:strName];
    }
    free(ivar);
}

#pragma mark - Singleton Methods
+ (id)sharedServant{
    return [[self alloc]init];
}

/**
 *  重写allocWithZone方法，用dispatch_once方法来实例化一个变量
 */
+ (id)allocWithZone:(struct _NSZone *)zone{
    static HSServant *sharedServant;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedServant = [super allocWithZone:zone];
    });
    return sharedServant;
}


@end
