//
//  HSSubService.h
//  HousekeepingServer
//
//  Created by Jacob on 15/10/9.
//  Copyright © 2015年 com.jacob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSSubService : NSObject

@property (copy, nonatomic) NSString *ID;
@property (copy, nonatomic) NSString *parentId;
@property (copy, nonatomic) NSString *typeIntro;
@property (copy, nonatomic) NSString *typeLogo;
@property (copy, nonatomic) NSString *typeName;
@end
