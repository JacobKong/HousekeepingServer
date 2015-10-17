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
#import "HSInfoLableItem.h"
#import "HSRegistViewController.h"

@interface HSInfoTableViewCell () {
  UIImageView *_arrowView;
  HSNoBorderTextField *_textField;
  UILabel *_label;
}
@property(weak, nonatomic) UIView *divider;

@end
@implementation HSInfoTableViewCell

#pragma mark 懒加载
/**
 *  再次方法中设置cell的textLable的frame
 */
- (void)layoutSubviews {
  [super layoutSubviews];
  self.textLabel.centerY = self.contentView.centerY;
}
/**
 *  返回cell
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView {
  static NSString *ID = @"settings";
  HSInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
  if (cell == nil) {
    cell = [[HSInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
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
- (void)setupBg {
  // 设置普通背景
  UIView *bg = [[UIView alloc] init];
  bg.backgroundColor = [UIColor whiteColor];
  self.backgroundView = bg;

  // 设置选中时的背景
  UIView *selectedBg = [[UIView alloc] init];
  selectedBg.backgroundColor = XBMakeColorWithRGB(237, 233, 218, 1);
  self.selectedBackgroundView = selectedBg;

  UIView *divider = [[UIView alloc]
      initWithFrame:CGRectMake(15, self.height - 1, XBScreenWidth, 1)];
  divider.backgroundColor = XBMakeColorWithRGB(234, 234, 234, 1);
  [self.contentView addSubview:divider];
  self.divider = divider;
}

/**
 *  初始化子控件
 */
- (void)setupSubviews {
  self.textLabel.backgroundColor = [UIColor clearColor];
  self.detailTextLabel.backgroundColor = [UIColor clearColor];
}

- (void)setItem:(HSInfoItem *)item {
  _item = item;

  // 1.设置数据
  [self setData:item];

  // 2.设置右边内容
  [self setRightContent:item];
}

- (void)setData:(HSInfoItem *)item {
  if (item.attrTitle) {
    self.textLabel.attributedText = item.attrTitle;
  } else {
    self.textLabel.text = item.title;
  }
  if (item.icon == nil) {
    return;
  } else {
    // 如果有图片则使divider的x更大一些
    self.divider.frame = CGRectMake(50, self.height - 1, XBScreenWidth, 1);
  };
    
  self.imageView.image = [UIImage imageNamed:item.icon];
}

- (void)setRightContent:(HSInfoItem *)item {
  if ([item isKindOfClass:[HSInfoArrowItem class]]) {
    [self settingArrow];
  } else if ([item isKindOfClass:[HSInfoTextFieldItem class]]) {
    [self settingTextField];
    HSInfoTextFieldItem *textFieldItem = (HSInfoTextFieldItem *)item;
    self.accessoryView = self.textField;
    // 设置文本内容
    [_textField setText:textFieldItem.text];
    // 设置placeHolder
    [_textField setAttributedPlaceholder:textFieldItem.attrPlaceholder];
    // 设置是否安全输入
    _textField.secureTextEntry = textFieldItem.isSecure;
    // 设置键盘类型
    if (textFieldItem.keyboardtype) {
      _textField.keyboardType = textFieldItem.keyboardtype;
    } else {
      _textField.keyboardType = UIReturnKeyDefault;
    }
    // 设置是否可输入
    if (textFieldItem.isEnable) {
      _textField.enabled = textFieldItem.enable;
    } else {
      _textField.enabled = NO;
    }
    // 设置delegate控制器
    if (textFieldItem.loginDelegateVc) {
      _textField.delegate = textFieldItem.loginDelegateVc;
    } else if (textFieldItem.registDelegateVc) {
      _textField.delegate = textFieldItem.registDelegateVc;
    } else if (textFieldItem.finalRegistDelegateVc) {
      _textField.delegate = textFieldItem.finalRegistDelegateVc;
    } else if (textFieldItem.mineInfoDelegateVc) {
      _textField.delegate = textFieldItem.mineInfoDelegateVc;
    }

  } else if ([item isKindOfClass:[HSInfoLableItem class]]) {
    [self settingLabel];
    HSInfoLableItem *labelItem = (HSInfoLableItem *)item;
    // 设置文本内容
    if (labelItem.attrText) {
      _label.attributedText = labelItem.attrText;
    }
    if (labelItem.text) {
      _label.text = labelItem.text;
    }
    _label.userInteractionEnabled = labelItem.enable;
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
    // 什么也没有，清空右边显示的view
    self.accessoryView = nil;
    // 用默认的选中样式
    self.selectionStyle = UITableViewCellSelectionStyleDefault;
  }
}

- (void)settingArrow {
  if (_arrowView == nil) {
#warning 更改箭头颜色！
    _arrowView = [[UIImageView alloc]
        initWithImage:[UIImage imageNamed:@"icon_arrowright"]];
  }
  self.accessoryView = _arrowView;
  // 用默认的选中样式
  self.selectionStyle = UITableViewCellSelectionStyleDefault;
}

- (void)settingTextField {
  if (!_textField) {
    _textField = [[HSNoBorderTextField alloc] init];
    CGFloat textFiledW;
    if (XBScreenWidth > 320) {
      textFiledW = self.contentView.frame.size.width * 0.85;
    } else {
      textFiledW = self.contentView.frame.size.width * 0.65;
    }
    CGFloat textFiledH = self.contentView.frame.size.height;
    _textField.bounds = CGRectMake(0, 0, textFiledW, textFiledH);
  }
  self.accessoryView = _textField;
  // 用默认的选中样式
  self.selectionStyle = UITableViewCellSelectionStyleDefault;
}

- (void)settingLabel {
  if (!_label) {
    _label = [[UILabel alloc] init];
    CGFloat labelW;
    //    if (XBScreenWidth > 320) {
    //      labelW = self.contentView.frame.size.width * 0.85;
    //    } else {
    labelW = self.contentView.frame.size.width * 0.65;
    //    }
    CGFloat labelH = self.contentView.frame.size.height;
    _label.bounds = CGRectMake(0, 0, labelW, labelH);
    _label.textAlignment = NSTextAlignmentLeft;
    _label.backgroundColor = [UIColor clearColor];
    _label.textColor = [UIColor blackColor];
    _label.font = [UIFont systemFontOfSize:15];
  }
  self.accessoryView = _label;
  // 用默认的选中样式
  self.selectionStyle = UITableViewCellSelectionStyleDefault;
}

@end
