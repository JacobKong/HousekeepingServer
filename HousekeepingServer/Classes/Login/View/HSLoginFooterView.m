//
//  HSLoginFooterView.m
//  HousekeepingServer
//
//  Created by Jacob on 15/9/30.
//  Copyright (c) 2015年 com.jacob. All rights reserved.
//

#import "HSLoginFooterView.h"
#import "UIImage+HSResizingImage.h"
#import "XBConst.h"
#import "HSOrangeButton.h"

@interface HSLoginFooterView ()

@end

@implementation HSLoginFooterView
- (HSOrangeButton *)loginBtn{
    if (!_loginBtn) {
        _loginBtn = [HSOrangeButton orangeButtonWithTitle:@"登录"];
        _loginBtn.enabled = NO;
        _loginBtn.alpha = 0.66;
//        [_loginBtn addTarget:self action:@selector(loginBtnClickded) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _loginBtn;
}


- (UIButton *)registBtn{
    if (!_registBtn) {
        _registBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_registBtn setTitle:@"注册账号" forState:UIControlStateNormal];
        [_registBtn setTitleColor:XBMakeColorWithRGB(234, 103, 7, 1) forState:UIControlStateNormal];
        _registBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _registBtn;
}

+ (instancetype)footerView{
    return [[self alloc]init];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.loginBtn];
        
        UIButton *registBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [registBtn setTitle:@"注册账号" forState:UIControlStateNormal];
        [registBtn setTitleColor:XBMakeColorWithRGB(234, 103, 7, 1) forState:UIControlStateNormal];
        registBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _registBtn = registBtn;
        [self addSubview:_registBtn];
//        [_registBtn addTarget:self action:@selector(registBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}

- (void)layoutSubviews{
    // 登录按钮frame
    CGFloat loginBtnX = 10;
    CGFloat loginBtnW = self.frame.size.width - 2 * loginBtnX;
    CGFloat loginBtnH = 50;
    CGFloat loginBtnY = 20;
    self.loginBtn.frame = CGRectMake(loginBtnX, loginBtnY, loginBtnW, loginBtnH);
    
    // 注册按钮frame
    CGFloat registBtnX = self.center.x - 40;
    CGFloat registBtnW = self.frame.size.width - 2 * registBtnX;
    CGFloat registBtnH = 40;
    CGFloat registBtnY = self.frame.size.height - 50;
    self.registBtn.frame = CGRectMake(registBtnX, registBtnY, registBtnW, registBtnH);

}

/**
 *  登录按钮点击
 */
//- (void)loginBtnClickded{
//    if ([self.delegate respondsToSelector:@selector(loginButtonDidClicked)]) {
//        [self.delegate loginButtonDidClicked];
//    }
//}

/**
 *  注册按钮点击
 */
//- (void)registBtnClicked{
//    if ([self.delegate respondsToSelector:@selector(registButtonDidClicked)]) {
//        [self.delegate registButtonDidClicked];
//    }
//}

@end
