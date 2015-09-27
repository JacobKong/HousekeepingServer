//
//  HSInfoGroup.h
//  HousekeepingServer
//
//  Created by Jacob on 15/9/26.
//  Copyright (c) 2015年 com.jacob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSInfoGroup : NSObject
/**
 *  组内的item数组
 */
@property (strong, nonatomic) NSArray *items;
/**
 *  头部信息
 */
@property (copy, nonatomic) NSString *header;
/**
 *  尾部模型
 */
@property (copy, nonatomic) NSString *footer;


+ (instancetype)groupWithItems:(NSArray *)items;
@end
