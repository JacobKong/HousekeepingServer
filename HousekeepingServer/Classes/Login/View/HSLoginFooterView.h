//
//  HSLoginFooterView.h
//  HousekeepingServer
//
//  Created by Jacob on 15/9/30.
//  Copyright (c) 2015年 com.jacob. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HSOrangeButton;
@protocol HSLoginFooterViewDelegate <NSObject>

@optional
- (void)loginButtonDidClicked;
- (void)registButtonDidClicked;

@end
@interface HSLoginFooterView : UIView
+ (instancetype)footerView;
@property (strong, nonatomic) HSOrangeButton *loginBtn;
@property (weak, nonatomic) id<HSLoginFooterViewDelegate> delegate;
@end
