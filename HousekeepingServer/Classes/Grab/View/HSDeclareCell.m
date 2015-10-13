//
//  HSDeclareCell.m
//  HousekeepingServer
//
//  Created by Jacob on 15/10/10.
//  Copyright © 2015年 com.jacob. All rights reserved.
//

#import "HSDeclareCell.h"
#import "UIImage+HSResizingImage.h"
#import "HSServiceDeclare.h"

@interface HSDeclareCell ()

@property (weak, nonatomic) IBOutlet UILabel *customerNameLab;
@property (weak, nonatomic) IBOutlet UILabel *serviceTypeLab;
@property (weak, nonatomic) IBOutlet UILabel *phoneNoLab;
@property (weak, nonatomic) IBOutlet UILabel *serviceTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *salaryLab;
@property (weak, nonatomic) IBOutlet UITextView *addressTextView;
@property (weak, nonatomic) IBOutlet UIView *remarksView;
@property (weak, nonatomic) IBOutlet UITextView *remarksTextView;
@property (strong, nonatomic) UIWebView *webView;
- (IBAction)leftBtnClicked:(id)sender;
- (IBAction)showLocation:(id)sender;
- (IBAction)callClient:(id)sender;

- (IBAction)rightBtnClicked:(id)sender;

@end

@implementation HSDeclareCell
+ (instancetype)cellWithTableView:(UITableView *)tableView{
    NSString *ID = @"grab";
    HSDeclareCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    // 如果缓存池中没有该ID的cell，则创建一个新的cell
    if (cell == nil) {
        // 创建一个新的cell
        cell = [[[NSBundle mainBundle]loadNibNamed:@"HSDeclareCell" owner:nil options:nil]lastObject];
    }
    return cell;
}

- (void)awakeFromNib{
    self.layer.cornerRadius = 10;
    self.layer.masksToBounds = YES;
    [self.leftBtn setBackgroundImage:[UIImage resizeableImage:@"common_button_blue"] forState:UIControlStateNormal];
    [self.leftBtn setBackgroundImage:[UIImage resizeableImage:@"common_button_blue_highlighted"] forState:UIControlStateHighlighted];
    
    [self.rightBtn setBackgroundImage:[UIImage resizeableImage:@"common_button_blue"] forState:UIControlStateNormal];
    [self.rightBtn setBackgroundImage:[UIImage resizeableImage:@"common_button_blue_highlighted"] forState:UIControlStateHighlighted];

    // 保持滚动帧率在55以上
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;

}

- (void)setServiceDeclare:(HSServiceDeclare *)serviceDeclare{
    _serviceDeclare = serviceDeclare;
    // 设置数据
    [self setupData];
}

- (void)setupData{
    // 用户姓名
    self.customerNameLab.text = self.serviceDeclare.customerName;
    // 服务时间
    self.serviceTimeLab.text = self.serviceDeclare.serviceTime;
    // 薪资
    self.salaryLab.text = self.serviceDeclare.salary;
    // 电话号码
    self.phoneNoLab.text = self.serviceDeclare.phoneNo;
    // 详细地址
    NSString *addressStr = [NSString stringWithFormat:@"%@%@%@%@", self.serviceDeclare.serviceProvince, self.serviceDeclare.serviceCity, self.serviceDeclare.serviceCounty, self.serviceDeclare.serviceAddress];
    self.addressTextView.text = addressStr;
    // 备注
    if (![self.serviceDeclare.remarks isEqualToString:@""]) {
        self.remarksTextView.text = self.serviceDeclare.remarks;
    }else{
        self.remarksTextView.text = @"该客户没有留下备注。";
    }
    self.serviceTypeLab.text = self.serviceDeclare.serviceType;
}

- (IBAction)leftBtnClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(declareCell:leftButtonDidClickedAtIndexPath:)]) {
        [self.delegate declareCell:self leftButtonDidClickedAtIndexPath:self.indexPath];
    }
}

- (IBAction)showLocation:(id)sender {
}

- (IBAction)callClient:(id)sender {
    if (!_webView) {
        _webView = [[UIWebView alloc]init];
    }
    NSString *phoneNoStr = [NSString stringWithFormat:@"tel://%@", self.serviceDeclare.phoneNo];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:phoneNoStr]]];
}

- (IBAction)rightBtnClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(declareCell:rightButtonDidClickedAtIndexPath:)]) {
        [self.delegate declareCell:self rightButtonDidClickedAtIndexPath:self.indexPath];
    }
}
@end
