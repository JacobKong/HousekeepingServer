//
//  HSDatePickerView.m
//  HousekeepingServer
//
//  Created by Jacob on 15/9/29.
//  Copyright (c) 2015年 com.jacob. All rights reserved.
//

#import "HSDatePickerView.h"
#import "XBConst.h"
#import "HSToolBarButton.h"

@interface HSDatePickerView ()
@property(strong, nonatomic) UIView *pickerView;
@property(strong, nonatomic) UIToolbar *toolBar;

@end

@implementation HSDatePickerView
+ (instancetype)datePicker {
  //    HSDatePickerView *pickerView = [[HSDatePickerView alloc]init];
  return [[self alloc] init];
}
- (UIToolbar *)toolBar {
  if (!_toolBar) {
    // 添加toolBar
    _toolBar = [[UIToolbar alloc] init];
    _toolBar.backgroundColor = [UIColor whiteColor];
    _toolBar.tintColor = [UIColor orangeColor];

    // 添加toolBar按钮
    UIBarButtonItem *btnPlace = [[UIBarButtonItem alloc]
        initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                             target:nil
                             action:nil];

    HSToolBarButton *cancle = [HSToolBarButton toolBarButtonWithTitle:@"取"
                                                                      @"消"];
    UIBarButtonItem *cancelBtn =
        [[UIBarButtonItem alloc] initWithCustomView:cancle];
      [cancle addTarget:self action:@selector(cancelBtnClicked) forControlEvents:UIControlEventTouchUpInside];

    HSToolBarButton *confirm = [HSToolBarButton toolBarButtonWithTitle:@"确"
                                                                       @"定"];
    UIBarButtonItem *confirmBtn =
        [[UIBarButtonItem alloc] initWithCustomView:confirm];
      [confirm addTarget:self action:@selector(confirmBtnClicked) forControlEvents:UIControlEventTouchUpInside];

    NSArray *itemsArray = @[ cancelBtn, btnPlace, confirmBtn ];
    [_toolBar setItems:itemsArray animated:YES];
  }
  return _toolBar;
}

- (void)cancelBtnClicked{
    if ([self.delegate respondsToSelector:@selector(dateCancelButtonDidClicked)]) {
        [self.delegate dateCancelButtonDidClicked];
    }
}

- (void)confirmBtnClicked{
    if ([self.delegate respondsToSelector:@selector(dateConfirmButtonDidClicked)]) {
        [self.delegate dateConfirmButtonDidClicked];
    }
}

- (UIDatePicker *)datePicker {
  if (!_datePicker) {
    _datePicker = [[UIDatePicker alloc] init];
    // 设置显示模式
    _datePicker.datePickerMode = UIDatePickerModeDate;
    // 设置背景
    _datePicker.backgroundColor = XBMakeColorWithRGB(234, 234, 234, 1);
    NSDate *currentTime = [NSDate date];
    [_datePicker setMaximumDate:currentTime];
  }

  return _datePicker;
}
- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    self.backgroundColor = XBMakeColorWithRGB(234, 234, 234, 1);
    [self addSubview:self.toolBar];
    [self addSubview:self.datePicker];
  }
  return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  // 设置frame
  self.toolBar.frame = CGRectMake(0, 0, XBScreenWidth, 44);

  CGFloat datePickerY = self.toolBar.frame.size.height;
  CGFloat datePickerW = XBScreenWidth;
  CGFloat datePickerH = self.frame.size.height - self.toolBar.frame.size.height;
  self.datePicker.frame = CGRectMake(0, datePickerY, datePickerW, datePickerH);
}
@end
