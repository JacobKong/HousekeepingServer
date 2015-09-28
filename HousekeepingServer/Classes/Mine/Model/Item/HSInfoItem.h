//
//  HSInfoItem.h
//  HousekeepingServer
//
//  Created by Jacob on 15/9/26.
//  Copyright (c) 2015年 com.jacob. All rights reserved.
//

#import <UIKit/UIKit.h>
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


@property (strong, nonatomic) HSInfoItemOption option;

+(instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title;
+(instancetype)itemWithTitle:(NSString *)title;

@end
