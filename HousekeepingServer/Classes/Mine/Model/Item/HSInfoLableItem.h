//
//  HSInfoLableItem.h
//  HousekeepingServer
//
//  Created by Jacob on 15/9/29.
//  Copyright (c) 2015年 com.jacob. All rights reserved.
//

#import "HSInfoItem.h"
#import "HSInfoValueItem.h"

@interface HSInfoLableItem : HSInfoValueItem
+ (instancetype)itemWithTitle:(NSAttributedString*)attrTitle;
/**
 *  label的内容
 */
@property (nonatomic, copy) NSString *text;
@end
