//
//  HSReceiveCell.m
//  HousekeepingServer
//
//  Created by Jacob on 15/10/12.
//  Copyright © 2015年 com.jacob. All rights reserved.
//

#import "HSReceiveCell.h"
#import "UIImage+HSResizingImage.h"
#import "HSServiceReceive.h"

@interface HSReceiveCell ()
@property (weak, nonatomic) IBOutlet UILabel *customerNameLab;
@property (weak, nonatomic) IBOutlet UILabel *serviceTypeLab;
@property (weak, nonatomic) IBOutlet UILabel *phoneNoLab;
@property (weak, nonatomic) IBOutlet UILabel *serviceTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *salaryLab;
@property (weak, nonatomic) IBOutlet UITextView *addressTextView;
@property (weak, nonatomic) IBOutlet UIView *remarksView;
@property (weak, nonatomic) IBOutlet UITextView *remarksTextView;
@property (weak, nonatomic) IBOutlet UIButton *receiveBtn;
@property (weak, nonatomic) IBOutlet UIButton *refuseBtn;
@property (strong, nonatomic) UIWebView *webView;

- (IBAction)receive:(id)sender;
- (IBAction)refuse:(id)sender;
- (IBAction)showLocation:(id)sender;
- (IBAction)callClient:(id)sender;
@end

@implementation HSReceiveCell
+ (instancetype)cellWithTableView:(UITableView *)tableView{
    NSString *ID = @"grab";
    HSReceiveCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    // 如果缓存池中没有该ID的cell，则创建一个新的cell
    if (cell == nil) {
        // 创建一个新的cell
        cell = [[[NSBundle mainBundle]loadNibNamed:@"HSReceiveCell" owner:nil options:nil]lastObject];
    }
    return cell;
}

- (void)awakeFromNib {
    self.layer.cornerRadius = 10;
    self.layer.masksToBounds = YES;
    [self.receiveBtn setBackgroundImage:[UIImage resizeableImage:@"common_button_blue"] forState:UIControlStateNormal];
    [self.receiveBtn setBackgroundImage:[UIImage resizeableImage:@"common_button_blue_highlighted"] forState:UIControlStateHighlighted];
    
    [self.refuseBtn setBackgroundImage:[UIImage resizeableImage:@"common_button_blue"] forState:UIControlStateNormal];
    [self.refuseBtn setBackgroundImage:[UIImage resizeableImage:@"common_button_blue_highlighted"] forState:UIControlStateHighlighted];

    // 保持滚动帧率在55以上
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;

    // Initialization code
}

- (void)setServiceReceive:(HSServiceReceive *)serviceReceive{
    _serviceReceive = serviceReceive;
    
    [self setData];
}

- (void)setData{
    // 用户姓名
    self.customerNameLab.text = self.serviceReceive.customerName;
    // 服务时间
    self.serviceTimeLab.text = self.serviceReceive.serviceTime;
    // 薪资
    self.salaryLab.text = self.serviceReceive.salary;
    // 电话号码
    self.phoneNoLab.text = self.serviceReceive.phoneNo;
    // 详细地址
    NSString *addressStr = [NSString stringWithFormat:@"%@%@%@%@", self.serviceReceive.serviceProvince, self.serviceReceive.serviceCity, self.serviceReceive.serviceCounty, self.serviceReceive.serviceAddress];
    self.addressTextView.text = addressStr;
    // 备注
    if (![self.serviceReceive.remarks isEqualToString:@""]) {
        self.remarksTextView.text = self.serviceReceive.remarks;
    }else{
        self.remarksTextView.text = @"该客户没有留下备注。";
    }
    self.serviceTypeLab.text = self.serviceReceive.serviceType;
    
}

- (IBAction)receive:(id)sender {
    if ([self.delegate respondsToSelector:@selector(receiveCell:receiveButtonDidClickedAtIndexPath:)]) {
        [self.delegate receiveCell:self receiveButtonDidClickedAtIndexPath:self.indexPath];
    }
}

- (IBAction)refuse:(id)sender {
    if ([self.delegate respondsToSelector:@selector(receiveCell:refuseButtonDidClickedAtIndexPath:)]) {
        [self.delegate receiveCell:self refuseButtonDidClickedAtIndexPath:self.indexPath];
    }
}

- (IBAction)showLocation:(id)sender {
}

- (IBAction)callClient:(id)sender {
    if (!_webView) {
        _webView = [[UIWebView alloc]init];
    }
    NSString *phoneNoStr = [NSString stringWithFormat:@"tel://%@", self.serviceReceive.phoneNo];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:phoneNoStr]]];
}

@end
