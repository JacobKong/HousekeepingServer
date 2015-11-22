//
//  HSLogin.m
//  HousekeepingServer
//
//  Created by Jacob on 15/11/22.
//  Copyright © 2015年 com.jacob. All rights reserved.
//

#import "HSLogin.h"
#import "NSString+Common.h"

@implementation HSLogin
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.servantID = @"";
        self.loginPassword = @"";
    }
    return self;
}

- (NSDictionary *)toParams{
        return @{@"servantID" : self.servantID,
                 @"loginPassword" : [self.loginPassword sha1Str]};
}

@end
