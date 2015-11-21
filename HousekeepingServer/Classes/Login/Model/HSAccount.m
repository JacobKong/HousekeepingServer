//
//  HSAccount.m
//  HousekeepingServer
//
//  Created by Jacob on 15/10/3.
//  Copyright © 2015年 com.jacob. All rights reserved.
//

#import "HSAccount.h"

@implementation HSAccount
- (instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)accountWithDict:(NSDictionary *)dict{
    return [[self alloc]initWithDict:dict];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        _servantItems = [aDecoder decodeObjectForKey:@"servantItems"];
        _state = (int)[aDecoder decodeIntegerForKey:@"state"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.servantItems forKey:@"servantItems"];
    [coder encodeInteger:self.state forKey:@"state"];
}


@end
