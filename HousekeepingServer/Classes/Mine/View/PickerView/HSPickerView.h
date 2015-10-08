//
//  HSPickerView.h
//  HousekeepingServer
//
//  Created by Jacob on 15/10/4.
//  Copyright © 2015年 com.jacob. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HSPickerView;
@protocol HSPickerViewDelegate <NSObject>

@optional
- (void)pickerView:(HSPickerView *)pickerView cancelButtonDidClickedOnToolBar:(UIToolbar *)toolBar;
- (void)pickerView:(HSPickerView *)pickerView confirmButtonDidClickedOnToolBar:(UIToolbar *)toolBar;
//
//- (void)cancelButtonDidClicked;
//- (void)confirmButtonDidClicked;
@end

@interface HSPickerView : UIView
@property (weak, nonatomic) id<HSPickerViewDelegate> delegate;
@property (strong, nonatomic) UIPickerView *picker;
@property (strong, nonatomic) UIToolbar *toolBar;
+ (instancetype)picker;
@end
