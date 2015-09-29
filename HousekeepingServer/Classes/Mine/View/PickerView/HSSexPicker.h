//
//  HSSexPicker.h
//  HousekeepingServer
//
//  Created by Jacob on 15/9/29.
//  Copyright (c) 2015年 com.jacob. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HSSexPickerViewDelegate <NSObject>

@optional
- (void)sexCancelButtonDidClicked;
- (void)sexConfirmButtonDidClicked;

@end

@interface HSSexPicker : UIView
@property (weak, nonatomic) id<HSSexPickerViewDelegate> delegate;
@property (strong, nonatomic) UIPickerView *picker;
+ (instancetype)sexPicker;
@end
