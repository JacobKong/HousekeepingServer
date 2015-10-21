//
//  HSOrderCell.m
//  HousekeepingServer
//
//  Created by Jacob on 15/10/13.
//  Copyright © 2015年 com.jacob. All rights reserved.
//

#import "HSOrderCell.h"
#import "UIImage+HSResizingImage.h"
#import "HSServiceOrder.h"

@interface HSOrderCell ()
@property (weak, nonatomic) IBOutlet UILabel *customerLab;
@property (weak, nonatomic) IBOutlet UILabel *serviceTypeLab;
@property (weak, nonatomic) IBOutlet UILabel *payStatusLab;
@property (weak, nonatomic) IBOutlet UILabel *servicePriceLab;
@property (weak, nonatomic) IBOutlet UILabel *paidAmountLab;
@property (weak, nonatomic) IBOutlet UILabel *contactPhoneLab;
@property (weak, nonatomic) IBOutlet UILabel *orderTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *confirmTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *isSettledLab;
@property (strong, nonatomic) UIWebView *webView;
- (IBAction)callClient:(id)sender;
- (IBAction)leftBtnClicked:(id)sender;

@end

@implementation HSOrderCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    NSString *ID = @"cell";
    HSOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    // 如果缓存池中没有该ID的cell，则创建一个新的cell
    if (cell == nil) {
        // 创建一个新的cell
        cell = [[[NSBundle mainBundle]loadNibNamed:@"HSOrderCell" owner:nil options:nil]lastObject];
    }
    return cell;
}

- (void)awakeFromNib{
    // 移除表面的contentView，否则无法响应按钮点击
    [self.contentView removeFromSuperview];
    self.layer.cornerRadius = 10;
    self.layer.masksToBounds = YES;
    [self.leftBtn setBackgroundImage:[UIImage resizeableImage:@"common_button_blue"] forState:UIControlStateNormal];
    [self.leftBtn setBackgroundImage:[UIImage resizeableImage:@"common_button_blue_highlighted"] forState:UIControlStateHighlighted];
    // 保持滚动帧率在55以上
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
}

- (void)setServiceOrder:(HSServiceOrder *)serviceOrder{
    _serviceOrder = serviceOrder;
    // 设置数据
    [self setupData];
}

- (void)setupData{
    self.customerLab.text = self.serviceOrder.customerName;
    self.serviceTypeLab.text = self.serviceOrder.serviceType;
    self.payStatusLab.text = self.serviceOrder.orderStatus;
        NSString *servicePriceStr = [NSString stringWithFormat:@"%@元", self.serviceOrder.servicePrice];
    self.servicePriceLab.text = servicePriceStr;
    NSString *paidAmountStr = [NSString stringWithFormat:@"%d元", self.serviceOrder.paidAmount];
    self.paidAmountLab.text = paidAmountStr;
    NSString *contactPhoneStr = [NSString stringWithFormat:@"%ld", self.serviceOrder.contactPhone];
    self.contactPhoneLab.text = contactPhoneStr;
    
    self.orderTimeLab.text = self.serviceOrder.orderTime;
    if (![self.serviceOrder.confirmTime isEqualToString:@""]) {
        self.confirmTimeLab.text = self.serviceOrder.confirmTime;
    }else{
        self.confirmTimeLab.text = @"客户尚未确认订单";
    }
    
    if (self.serviceOrder.isSettled) {
        self.isSettledLab.text = @"已结算";
    }else{
        self.isSettledLab.text = @"未结算";
    }
    
    if ([self.serviceOrder.orderStatus isEqualToString:@"待付款"]) {
        self.leftBtn.hidden = NO;
    }else{
        self.leftBtn.hidden = YES;
    }
}

- (IBAction)leftBtnClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(orderCell:leftButtonDidClickedAtIndexPath:)]) {
        [self.delegate orderCell:self leftButtonDidClickedAtIndexPath:self.indexPath];
    }
}

- (IBAction)callClient:(id)sender {
    if (!_webView) {
        _webView = [[UIWebView alloc]init];
    }
    NSString *phoneNoStr = [NSString stringWithFormat:@"tel://%ld", self.serviceOrder.contactPhone];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:phoneNoStr]]];
}

@end
