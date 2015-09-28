//
//  HSInfoTableViewCell.m
//  HousekeepingServer
//
//  Created by Jacob on 15/9/26.
//  Copyright (c) 2015年 com.jacob. All rights reserved.
//

#import "HSInfoTableViewCell.h"
#import "HSInfoArrowItem.h"
#import "HSInfoItem.h"
#import "XBConst.h"
#import "UIView+SetFrame.h"
#import "HSInfoTextFieldItem.h"
#import "HSNoBorderTextField.h"

@interface HSInfoTableViewCell (){
    UIImageView *_arrowView;
//    UITextField *_textField;
    HSNoBorderTextField *_textField;
    
}
@property (weak, nonatomic) UIView *divider;

@end

@implementation HSInfoTableViewCell

#pragma mark 懒加载
/**
 *  再次方法中设置cell的textLable的frame
 */
- (void)layoutSubviews{
    [super layoutSubviews];
    self.textLabel.centerY = self.contentView.centerY;
}
/**
 *  返回cell
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"settings";
    HSInfoTableViewCell *cell =
    [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[HSInfoTableViewCell alloc]
                initWithStyle:UITableViewCellStyleValue1
                reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 初始化操作
        
        // 1.初始化背景
        [self setupBg];
        
        // 2.初始化子控件
        [self setupSubviews];
        
    }
    return self;
}

/**
 *  初始化背景
 */
- (void)setupBg
{
    // 设置普通背景
    UIView *bg = [[UIView alloc] init];
    bg.backgroundColor = [UIColor whiteColor];
    self.backgroundView = bg;
    
    // 设置选中时的背景
    UIView *selectedBg = [[UIView alloc] init];
    selectedBg.backgroundColor = XBMakeColorWithRGB(237, 233, 218, 1);
    self.selectedBackgroundView = selectedBg;

    UIView *divider = [[UIView alloc]initWithFrame:CGRectMake(15, self.height - 1, XBScreenWidth, 1)];
    divider.backgroundColor = XBMakeColorWithRGB(234, 234, 234, 1);
    [self.contentView addSubview:divider];
    self.divider = divider;

}

/**
 *  初始化子控件
 */
- (void)setupSubviews
{
    self.textLabel.backgroundColor = [UIColor clearColor];
    self.detailTextLabel.backgroundColor = [UIColor clearColor];
}


- (void)setItem:(HSInfoItem *)item{
    _item = item;
    
    // 1.设置数据
    [self setData:item];
    
    // 2.设置右边内容
    [self setRightContent:item];

    
}

- (void)setData:(HSInfoItem *)item {
    // 设置标题
    if (item.attrTitle) {
        self.textLabel.attributedText = item.attrTitle;
    }else{
        self.textLabel.text = item.title;
    }
    
    // 设置图标
    if (item.icon == nil){
        return;
    }else{
        // 如果有图片则使divider的x更大一些
        self.divider.frame = CGRectMake(50, self.height - 1, XBScreenWidth, 1);
    };
    self.imageView.image = [UIImage imageNamed:item.icon];
}

- (void)setRightContent:(HSInfoItem *)item {
    if ([self.item isKindOfClass:[HSInfoArrowItem class]]) {
        [self settingArrow];
        
    }else if ([self.item isKindOfClass:[HSInfoTextFieldItem class]]){
        [self settingTextField];
        HSInfoTextFieldItem *textFieldItem = (HSInfoTextFieldItem *)self.item;
        // 设置文本款内容
        [_textField setText:textFieldItem.text];
        // 设置placeHolder
        [_textField setAttributedPlaceholder:textFieldItem.attrPlaceholder];
        // 设置是否安全输入
        _textField.secureTextEntry = textFieldItem.isSecure;
        // 设置键盘类型
        if (textFieldItem.keyboardtype) {
            _textField.keyboardType = textFieldItem.keyboardtype;
        }else{
            _textField.keyboardType = UIReturnKeyDefault;
        }
        // 设置是否可输入
        if (textFieldItem.isEnable) {
            _textField.enabled = textFieldItem.enable;
        }else{
            _textField.enabled = NO;
        }
        // 设置delegate控制器
//        self.textField.delegate = textFieldItem.delegateVc;
//        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
//    } else if ([self.item isKindOfClass:[KWJSettingSwitchItem class]]) {
//        self.accessoryView = self.switchView;
//        self.selectionStyle = UITableViewCellSelectionStyleNone;
//    } else if ([self.item isKindOfClass:[KWJSettingLabelItem class]]) {
//        KWJSettingLabelItem *labelItem = (KWJSettingLabelItem *)self.item;
//        self.labelView.text = labelItem.labelTitle;
//        self.accessoryView = self.labelView;
//    }
    else {
        self.accessoryType = UITableViewCellAccessoryNone;
    }
}

- (void)settingArrow{
    if (_arrowView == nil) {
#warning 更改箭头颜色！
        _arrowView =
        [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_arrowright"]];
    }
    self.accessoryView = _arrowView;
    // 用默认的选中样式
    self.selectionStyle = UITableViewCellSelectionStyleDefault;
}

- (void)settingTextField{
    if (!_textField) {
        _textField = [[HSNoBorderTextField alloc]init];
        CGFloat textFiledW = self.contentView.frame.size.width - 120;
        CGFloat textFiledH = self.contentView.frame.size.height;
        _textField.bounds = CGRectMake(0, 100, textFiledW, textFiledH);
        // 光标颜色
        _textField.tintColor = [UIColor orangeColor];
        // 右边清空按钮
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        UIImageView *cancleView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"textfield_text_clear"]];
        [cancleView sizeToFit];
        _textField.rightView = cancleView;
        // 设置输入文字大小
        [_textField setFont:[UIFont systemFontOfSize:14]];
        
    }
    self.accessoryView = _textField;
    // 用默认的选中样式
    self.selectionStyle = UITableViewCellSelectionStyleDefault;
}
@end
