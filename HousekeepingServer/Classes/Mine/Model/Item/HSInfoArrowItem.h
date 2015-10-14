//
//  HSInfoArrowItem.h
//  HousekeepingServer
//
//  Created by Jacob on 15/9/26.
//  Copyright (c) 2015年 com.jacob. All rights reserved.
//

#import "HSInfoItem.h"

@interface HSInfoArrowItem : HSInfoItem
/**
 *  目标控制器
 */
@property (assign, nonatomic) Class destVcClass;
+(instancetype)itemWithTitle:(NSString *)title destVcClass:(Class) destVcClass;
+(instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title destVcClass:(Class) destVcClass;
+ (instancetype)itemWithAttrTitle:(NSAttributedString *)title destVcClass:(Class) destVcClass;
@end
