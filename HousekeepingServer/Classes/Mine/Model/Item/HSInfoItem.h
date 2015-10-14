//
//  HSInfoItem.h
//  HousekeepingServer
//
//  Created by Jacob on 15/9/26.
//  Copyright (c) 2015年 com.jacob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSMineTool.h"
typedef void (^HSInfoItemOption)();
@interface HSInfoItem : NSObject
/**
 *  图标
 */
@property (copy, nonatomic) NSString *icon;
/**
 *  标题
 */
@property (copy, nonatomic) NSString *title;

/**
 *  可设置字体样式的title
 */
@property (copy, nonatomic) NSAttributedString *attrTitle;

/**
 *  点击后cell需要执行的操作
 */
@property (strong, nonatomic) HSInfoItemOption option;

/**
 *  是否可交互
 */
@property (assign, nonatomic, getter=isEnable)  BOOL enable;
/**
 *  是否隐藏divider
 */
@property (assign, nonatomic, getter = isDividerHidden)  BOOL dividerHidden;


+(instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title;
+(instancetype)itemWithTitle:(NSString *)title;

@end
