//
//  HSInfoFooterView.m
//  HousekeepingServer
//
//  Created by Jacob on 15/9/26.
//  Copyright (c) 2015年 com.jacob. All rights reserved.
//

#import "HSInfoFooterView.h"
#import "UIImage+HSResizingImage.h"
#import "XBConst.h"

@implementation HSInfoFooterView

- (UIButton *)button{
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button setBackgroundImage:[UIImage resizeableImage:@"common_button_orange"] forState:UIControlStateNormal];
        [_button setBackgroundImage:[UIImage resizeableImage:@"common_button_orange_highlighted"] forState:UIControlStateHighlighted];
    }
    return _button;
}

+ (instancetype)footerViewWithBtnTitle:(NSString *)title{
    return [[self alloc]initWithBtnTitle:title];
}

+ (instancetype)footerView{
    HSInfoFooterView *footerView = [[HSInfoFooterView alloc]init];
    footerView.frame = CGRectMake(0, 0, XBScreenWidth, 50);
    return footerView;
}

- (instancetype)initWithBtnTitle:(NSString *)title{
    HSInfoFooterView *footerView = [[HSInfoFooterView alloc]init];
    footerView.frame = CGRectMake(0, 0, XBScreenWidth, 50);
    CGFloat buttonX = 10;
    CGFloat buttonW = footerView.frame.size.width - 2 * buttonX;
    CGFloat buttonH = 50;
    CGFloat buttonY = footerView.center.y - buttonH * 0.5;
    self.button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
    [self.button setTitle:title forState:UIControlStateNormal];
    [footerView addSubview:self.button];
    return footerView;
}
@end
