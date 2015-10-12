//
//  HSService.h
//  HousekeepingServer
//
//  Created by Jacob on 15/9/25.
//  Copyright (c) 2015年 com.jacob. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface HSService : NSObject
@property (copy, nonatomic) NSString *ID;
@property (copy, nonatomic) NSString *parentId;
@property (copy, nonatomic) NSString *typeIntro;
@property (copy, nonatomic) NSString *typeLogo;
@property (copy, nonatomic) NSString *typeName;
@end
