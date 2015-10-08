//
//  HSServantTool.h
//  HousekeepingServer
//
//  Created by Jacob on 15/10/8.
//  Copyright © 2015年 com.jacob. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HSServant;
@interface HSServantTool : NSObject
+ (void)saveServant:(HSServant *)servant;
+ (HSServant *)servant;
+ (void)removeServant;
@end
