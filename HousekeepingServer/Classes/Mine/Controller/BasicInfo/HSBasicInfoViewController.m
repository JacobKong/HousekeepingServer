//
//  HSBasicInfoViewController.m
//  HousekeepingServer
//
//  Created by Jacob on 15/9/26.
//  Copyright (c) 2015年 com.jacob. All rights reserved.
//

#import "HSBasicInfoViewController.h"
#import "HSInfoFooterView.h"
#import "HSInfoTextFieldItem.h"
#import "HSInfoGroup.h"
#import "HSNavBarBtn.h"
#import "UIImage+HSResizingImage.h"
#import "HSNoBorderTextField.h"
#import "HSInfoTableViewCell.h"
#import "MBProgressHUD.h"

@interface HSBasicInfoViewController ()<InfoFooterViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) UIButton *saveBtn;
@property (weak, nonatomic) HSInfoFooterView *footerView;
@property (weak, nonatomic) UIBarButtonItem *rightBtn;
@property (strong, nonatomic) HSInfoGroup *g0;

@end

@implementation HSBasicInfoViewController


- (void)viewDidLoad{
    NSLog(@"%@", self.cell.subviews);

    // 添加第一组
    [self setupGroup0];
    
    // 设置footerView
    [self setupfooterView];
    
    // 设置导航栏按钮
    [self setupEditingBtn];
    
    // 设置敲击手势，取消键盘
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]   initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    // 监听文本框
//    self.cell.textField.enabled = NO;
//    HSInfoTableViewCell *cell = self.cell;
//    HSNoBorderTextField *textField = cell.textField;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textChange) name:UITextFieldTextDidChangeNotification object:nil];

    // 背景颜色
    self.view.backgroundColor = [UIColor whiteColor];
    [super viewDidLoad];
    
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
/**
 *  取消键盘
 */
-(void)dismissKeyboard {
    [self.view endEditing:YES];
}

- (void)setupGroup0{
    NSMutableDictionary *titleAttr = [NSMutableDictionary dictionary];
    titleAttr[NSFontAttributeName] = [UIFont systemFontOfSize:14];
    titleAttr[NSForegroundColorAttributeName] = [UIColor darkGrayColor];
    
    NSAttributedString *userNumStr = [[NSAttributedString alloc]initWithString:@"账号" attributes:titleAttr];
    NSAttributedString *userNameStr = [[NSAttributedString alloc]initWithString:@"姓名" attributes:titleAttr];
    NSAttributedString *sexStr = [[NSAttributedString alloc]initWithString:@"性别" attributes:titleAttr];
    NSAttributedString *birthdayStr = [[NSAttributedString alloc]initWithString:@"生日" attributes:titleAttr];
    NSAttributedString *IDCardStr = [[NSAttributedString alloc]initWithString:@"身份证号" attributes:titleAttr];
    NSAttributedString *phoneNumberStr = [[NSAttributedString alloc]initWithString:@"联系电话" attributes:titleAttr];
    NSAttributedString *emailStr = [[NSAttributedString alloc]initWithString:@"电子邮件" attributes:titleAttr];
    
    NSMutableDictionary *placeholderAttr = [NSMutableDictionary dictionary];
    placeholderAttr[NSFontAttributeName] = [UIFont systemFontOfSize:14];
    
    NSAttributedString *userNumPh = [[NSAttributedString alloc]initWithString:@"账号" attributes:placeholderAttr];
    NSAttributedString *userNamePh = [[NSAttributedString alloc]initWithString:@"姓名" attributes:placeholderAttr];
    NSAttributedString *sexPh = [[NSAttributedString alloc]initWithString:@"性别" attributes:placeholderAttr];
    NSAttributedString *birthdayPh = [[NSAttributedString alloc]initWithString:@"生日" attributes:placeholderAttr];
    NSAttributedString *IDCardPh = [[NSAttributedString alloc]initWithString:@"身份证号" attributes:placeholderAttr];
    NSAttributedString *phoneNumberPh = [[NSAttributedString alloc]initWithString:@"联系电话" attributes:placeholderAttr];
    NSAttributedString *emailPh = [[NSAttributedString alloc]initWithString:@"电子邮件" attributes:placeholderAttr];
    
    HSInfoTextFieldItem *userNum = [HSInfoTextFieldItem itemWithTitle:userNumStr placeholder:userNumPh text:@"20132037"];

    HSInfoTextFieldItem *userName = [HSInfoTextFieldItem itemWithTitle:userNameStr placeholder:userNamePh text:@"孔伟杰"];

    HSInfoTextFieldItem *sex = [HSInfoTextFieldItem itemWithTitle:sexStr placeholder:sexPh text:@"男"];

    HSInfoTextFieldItem *birthday = [HSInfoTextFieldItem itemWithTitle:birthdayStr placeholder:birthdayPh text:@"2013-10-10"];

    HSInfoTextFieldItem *IDCard = [HSInfoTextFieldItem itemWithTitle:IDCardStr placeholder:IDCardPh text:@"140"];

    HSInfoTextFieldItem *phoneNumber = [HSInfoTextFieldItem itemWithTitle:phoneNumberStr placeholder:phoneNumberPh text:@"185"];

    HSInfoTextFieldItem *email = [HSInfoTextFieldItem itemWithTitle:emailStr placeholder:emailPh text:@"947"];

    
    HSInfoGroup *g0 = [[HSInfoGroup alloc]init];
    g0.items = @[userNum, userName, sex, birthday, IDCard, phoneNumber, email];
    
    self.g0 = g0;
    [self.data addObject:self.g0];
    
}

/**
 *  创建footerView
 */
- (void)setupfooterView{
    HSInfoFooterView *footerView = [HSInfoFooterView footerView];

    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveBtn setBackgroundImage:[UIImage resizeableImage:@"common_button_orange"] forState:UIControlStateNormal];
    [saveBtn setBackgroundImage:[UIImage resizeableImage:@"common_button_pressed_orange"] forState:UIControlStateHighlighted];
    
    CGFloat buttonX = 10;
    CGFloat buttonW = footerView.frame.size.width - 2 * buttonX;
    CGFloat buttonH = 40;
    CGFloat buttonY = footerView.center.y - buttonH * 0.5;
    saveBtn.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [footerView addSubview:saveBtn];

    self.footerView = footerView;
    self.saveBtn = saveBtn;
    saveBtn.hidden = YES;
    [saveBtn addTarget:self action:@selector(saveBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.tableFooterView = footerView;
}

/**
 *  保存按钮点击
 */
- (void)saveBtnClicked{
    NSMutableArray *itemArray = [NSMutableArray array];
    for (HSInfoTextFieldItem *textItem in self.g0.items) {
        textItem.enable = NO;
        [itemArray addObject:textItem];
    }
    self.g0.items = itemArray;
    [self.data removeLastObject];
    [self.data addObject:self.g0];
    [self.tableView reloadData];
    
    // 显示HUD
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
    hud.labelText = @"保存成功";
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [hud hide:YES];
        self.rightBtn.title = @"编辑";
    });

    self.saveBtn.enabled = NO;
    self.saveBtn.hidden = YES;
}

- (void)setupEditingBtn{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStyleDone target:self action:@selector(editBtnClicked)];
    self.rightBtn = self.navigationItem.rightBarButtonItem;
}

/**
 *  编辑按钮点击
 */
- (void)editBtnClicked{
    [self.data removeLastObject];
    self.saveBtn.hidden = !self.saveBtn.hidden;
    self.saveBtn.enabled = !self.saveBtn.enabled;
    
    if ([self.rightBtn.title isEqualToString:@"取消"]) {
        self.rightBtn.title = @"编辑";
        NSMutableArray *itemArray = [NSMutableArray array];
        for (HSInfoTextFieldItem *textItem in self.g0.items) {
            textItem.enable = NO;
            [itemArray addObject:textItem];
        }
        self.g0.items = itemArray;
        [self.data addObject:self.g0];
        [self.tableView reloadData];

    }else{
        self.rightBtn.title = @"取消";
        NSMutableArray *itemArray = [NSMutableArray array];
        for (HSInfoTextFieldItem *textItem in self.g0.items) {
            textItem.enable = YES;
            [itemArray addObject:textItem];
        }
        self.g0.items = itemArray;
        [self.data addObject:self.g0];
        [self.tableView reloadData];
    }
    
}

- (void)textChange{
    self.saveBtn.enabled = YES;
}
#pragma mark - UITextFieldDelegate
//- (void)textFieldDidBeginEditing:(UITextField *)textField{
//}
//
//- (void)textFieldDidEndEditing:(UITextField *)textField{
//    self.saveBtn.enabled = YES;
//}

@end
