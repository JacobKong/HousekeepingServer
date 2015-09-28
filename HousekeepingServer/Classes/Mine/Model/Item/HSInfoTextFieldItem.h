//
//  HSInfoTextFieldItem.h
//  HousekeepingServer
//
//  Created by Jacob on 15/9/26.
//  Copyright (c) 2015年 com.jacob. All rights reserved.
//

#import "HSInfoItem.h"
#import "HSBasicInfoViewController.h"

@interface HSInfoTextFieldItem : HSInfoItem
/**
 *  可设置颜色、字体的placeholder
 */
@property (copy, nonatomic) NSAttributedString *attrPlaceholder;
/**
 *  是否安全输入
 */
@property (assign, nonatomic, getter=isSecure)  BOOL secure;
/**
 *  键盘类型
 */
@property (assign, nonatomic) UIKeyboardType keyboardtype;
/**
 *  是否可输入
 */
@property (assign, nonatomic, getter=isEnable)  BOOL enable;
/**
 *  文本框文字
 */
@property (copy, nonatomic) NSString *text;

+ (instancetype)itemWithTitle:(NSAttributedString*)attrTitle placeholder:(NSAttributedString *)attrPlaceholder text:(NSString *)text;
+ (instancetype)itemWithTitle:(NSAttributedString*)attrTitle placeholder:(NSAttributedString *)attrPlaceholder;
@end
