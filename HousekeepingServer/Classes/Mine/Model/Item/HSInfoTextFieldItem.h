//
//  HSInfoTextFieldItem.h
//  HousekeepingServer
//
//  Created by Jacob on 15/9/26.
//  Copyright (c) 2015年 com.jacob. All rights reserved.
//

#import "HSInfoItem.h"
#import "HSInfoValueItem.h"
#import "HSLoginViewController.h"
#import "HSRegistViewController.h"
#import "HSFinalRegistViewController.h"
#import "HSMineInfoViewController.h"
@interface HSInfoTextFieldItem : HSInfoValueItem
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
 *  文本框文字
 */
@property (copy, nonatomic) NSString *text;
/**
 *  代理控制器1
 */
//@property (weak, nonatomic) HSBasicInfoViewController *basicDelegateVc;
/**
 *  代理控制器2
 */
@property (weak, nonatomic) HSLoginViewController *loginDelegateVc;
/**
 *  代理控制器3
 */
@property (weak, nonatomic) HSRegistViewController *registDelegateVc;
/**
 *  代理控制器4
 */
@property (weak, nonatomic) HSFinalRegistViewController *finalRegistDelegateVc;
/**
 *  代理控制器5
 */
@property (weak, nonatomic) HSMineInfoViewController *mineInfoDelegateVc;

/**
 *  keyboard的inputView
 */
@property (weak, nonatomic) UIView *inputView;
//+ (instancetype)itemWithTitle:(NSString*)title placeholder:(NSString *)placeholder;

+ (instancetype)itemWithTitle:(NSAttributedString*)attrTitle placeholder:(NSAttributedString *)attrPlaceholder text:(NSString *)text;
+ (instancetype)itemWithTitle:(NSAttributedString*)attrTitle placeholder:(NSAttributedString *)attrPlaceholder;
+ (instancetype)itemWithIcon:(NSString *)icon placeholder:(NSAttributedString *)attrPlaceHolder;
@end
