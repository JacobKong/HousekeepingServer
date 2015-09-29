//
//  HSSexPicker.m
//  HousekeepingServer
//
//  Created by Jacob on 15/9/29.
//  Copyright (c) 2015年 com.jacob. All rights reserved.
//

#import "HSSexPicker.h"
#import "HSToolBarButton.h"
#import "XBConst.h"

@interface HSSexPicker ()
@property (strong, nonatomic) UIToolbar *toolBar;
@property (strong, nonatomic) UIView *sexPicker;
@end

@implementation HSSexPicker
+ (instancetype)sexPicker{
    return [[self alloc]init];
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
    if ([self.delegate respondsToSelector:@selector(sexCancelButtonDidClicked)]) {
        [self.delegate sexCancelButtonDidClicked];
    }
}

- (void)confirmBtnClicked{
    if ([self.delegate respondsToSelector:@selector(sexConfirmButtonDidClicked)]) {
        [self.delegate sexConfirmButtonDidClicked];
    }
}

- (UIPickerView *)picker{
    if (!_picker) {
        _picker = [[UIPickerView alloc]init];
        // 显示选中框
        _picker.showsSelectionIndicator = YES;
        // 背景
        _picker.backgroundColor = XBMakeColorWithRGB(234, 234, 234, 1);
    }
    return _picker;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = XBMakeColorWithRGB(234, 234, 234, 1);
        [self addSubview:self.toolBar];
        [self addSubview:self.picker];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    // 设置frame
    self.toolBar.frame = CGRectMake(0, 0, XBScreenWidth, 44);
    
    CGFloat datePickerY = self.toolBar.frame.size.height;
    CGFloat datePickerW = XBScreenWidth;
    CGFloat datePickerH = self.frame.size.height - self.toolBar.frame.size.height;
    self.picker.frame = CGRectMake(0, datePickerY, datePickerW, datePickerH);

    
}
@end
