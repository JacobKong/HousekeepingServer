//
//  HSInfoFooterView.h
//  HousekeepingServer
//
//  Created by Jacob on 15/9/26.
//  Copyright (c) 2015年 com.jacob. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HSInfoFooterView;
@protocol InfoFooterViewDelegate <NSObject>

@optional
- (BOOL)didChangeBtnEnable;

@end
@interface HSInfoFooterView : UIView
@property (strong, nonatomic) UIButton *button;
@property (weak, nonatomic) id<InfoFooterViewDelegate> delegate;

/**
 *  返回一个没有任何子控件的footerView
 *
 */
+ (instancetype)footerView;
/**
 *  返回一个带有title标题的按钮的footerView
 *
 *  @param title btn的标题
 *
 *  @return 一个带有title标题的按钮的footerView
 */
+ (instancetype)footerViewWithBtnTitle:(NSString *)title;
@end
