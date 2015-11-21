//
//  NSObject+Common.m
//  HousekeepingServer
//
//  Created by Jacob on 15/11/21.
//  Copyright © 2015年 com.jacob. All rights reserved.
//

#import "NSObject+Common.h"
#import "MBProgressHUD.h"
#import "XBConst.h"

@implementation NSObject (Common)
+ (NSString *)tipFromError:(NSError *)error{
    if (error && error.userInfo) {
        NSMutableString *tipStr = [[NSMutableString alloc] init];
        if ([error.userInfo objectForKey:@"msg"]) {
            NSArray *msgArray = [[error.userInfo objectForKey:@"msg"] allValues];
            NSUInteger num = [msgArray count];
            for (int i = 0; i < num; i++) {
                NSString *msgStr = [msgArray objectAtIndex:i];
                if (i+1 < num) {
                    [tipStr appendString:[NSString stringWithFormat:@"%@\n", msgStr]];
                }else{
                    [tipStr appendString:msgStr];
                }
            }
        }else{
            if ([error.userInfo objectForKey:@"NSLocalizedDescription"]) {
                tipStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
            }else{
                [tipStr appendFormat:@"ErrorCode%ld", (long)error.code];
            }
        }
        return tipStr;
    }
    return nil;
}

+ (BOOL)showError:(NSError *)error{
    NSString *tipStr = [NSObject tipFromError:error];
    [NSObject showHudTipStr:tipStr];
    return YES;
}

+ (void)showHudTipStr:(NSString *)tipStr{
    if (tipStr && tipStr.length > 0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:kKeyWindow animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabelFont = [UIFont boldSystemFontOfSize:15.0];
        hud.detailsLabelText = tipStr;
        hud.margin = 10.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:1.0];
    }
}

#pragma mark BaseURL
+ (NSString *)baseURLStr{
    NSString *baseURLStr = @"http://192.168.23.6:8080/NationalService";
    return baseURLStr;
}

@end
