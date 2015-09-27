//
//  HSNoBorderTextField.m
//  HousekeepingServer
//
//  Created by Jacob on 15/9/26.
//  Copyright (c) 2015年 com.jacob. All rights reserved.
//

#import "HSNoBorderTextField.h"
#import "XBConst.h"

@implementation HSNoBorderTextField
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 光标颜色
        self.tintColor = [UIColor orangeColor];
        // 右边清空按钮
        self.clearButtonMode = UITextFieldViewModeWhileEditing;
        UIImageView *cancleView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"textfield_text_clear"]];
        [cancleView sizeToFit];
        self.rightView = cancleView;
        // 设置输入文字大小
        [self setFont:[UIFont systemFontOfSize:14]];
    }
    return self;
}

@end
