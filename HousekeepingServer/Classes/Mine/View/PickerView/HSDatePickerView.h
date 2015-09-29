//
//  HSDatePickerView.h
//  HousekeepingServer
//
//  Created by Jacob on 15/9/29.
//  Copyright (c) 2015年 com.jacob. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HSDatePickerViewDelegate <NSObject>

@optional
- (void)dateCancelButtonDidClicked;
- (void)dateConfirmButtonDidClicked;

@end
@interface HSDatePickerView : UIView
@property (weak, nonatomic) id<HSDatePickerViewDelegate> delegate;
@property (strong, nonatomic) UIDatePicker *datePicker;
+ (instancetype)datePicker;
@end
