//
//  HSOrderDetailsViewController.m
//  HousekeepingServer
//
//  Created by Jacob on 15/10/14.
//  Copyright © 2015年 com.jacob. All rights reserved.
//

#import "HSOrderDetailsViewController.h"
#import "HSInfoLableItem.h"
#import "HSInfoGroup.h"
#import "XBConst.h"
#import "HSInfoArrowItem.h"
#import "HSOrderCommentViewController.h"

@interface HSOrderDetailsViewController ()
@property (strong, nonatomic) NSMutableDictionary *titleAttr;
@property (strong, nonatomic) NSMutableDictionary *labelAttr;
@end

@implementation HSOrderDetailsViewController

- (NSMutableDictionary *)titleAttr{
    if (_titleAttr) {
        _titleAttr = [NSMutableDictionary dictionary];
        _titleAttr[NSFontAttributeName] = [UIFont systemFontOfSize:15];
        _titleAttr[NSForegroundColorAttributeName] = [UIColor darkGrayColor];
        _titleAttr[NSForegroundColorAttributeName] =
        XBMakeColorWithRGB(28, 21, 80, 1);
    }
    return _titleAttr;
}

- (NSMutableDictionary *)labelAttr{
    if (_labelAttr) {
        _labelAttr = [NSMutableDictionary dictionary];
        _labelAttr[NSFontAttributeName] = [UIFont systemFontOfSize:15];
        _labelAttr[NSForegroundColorAttributeName] =
        XBMakeColorWithRGB(28, 21, 80, 1);
    }
    return _labelAttr;
}

- (void)viewDidLoad {
    // 添加第一组
    [self setupGroup0];

    // 添加第二组
    [self setupGroup1];

    // 添加第三组
    [self setupGroup2];
    
    self.clearsSelectionOnViewWillAppear = NO;

    [super viewDidLoad];
    
}

- (void)setupGroup0{
    NSAttributedString *customerIDStr = [[NSAttributedString alloc]initWithString:@"客户ID" attributes:self.titleAttr];
    NSAttributedString *customerNameStr = [[NSAttributedString alloc]initWithString:@"客户姓名" attributes:self.titleAttr];
    NSAttributedString *contactPhoneStr = [[NSAttributedString alloc]initWithString:@"联系电话" attributes:self.titleAttr];
    NSAttributedString *contactAddressStr = [[NSAttributedString alloc]initWithString:@"通讯地址" attributes:self.titleAttr];
    NSAttributedString *remarksStr = [[NSAttributedString alloc]initWithString:@"备注" attributes:self.titleAttr];
    
    
    NSAttributedString *customerIDText = [[NSAttributedString alloc]initWithString:self.serviceOrder.customerID attributes:self.labelAttr];
    
    NSAttributedString *customerNameText = [[NSAttributedString alloc]initWithString:self.serviceOrder.customerName attributes:self.labelAttr];
    
    NSString *paidAmountString = [NSString stringWithFormat:@"%ld", self.serviceOrder.contactPhone];
    NSAttributedString *contactPhoneText = [[NSAttributedString alloc]initWithString:paidAmountString attributes:self.labelAttr];
    
    NSAttributedString *contactAddressText = [[NSAttributedString alloc]initWithString:self.serviceOrder.contactAddress attributes:self.labelAttr];
    
    NSString *remarksString = [NSString string];
    if (![self.serviceOrder.remarks isEqualToString:@""]) {
        remarksString = self.serviceOrder.remarks;
    }else{
        remarksString = @"客户尚未付款";
    }
    NSAttributedString *remarksText = [[NSAttributedString alloc]initWithString:remarksString attributes:self.labelAttr];
    
    HSInfoLableItem *customerID = [HSInfoLableItem itemWithTitle:customerIDStr];
    customerID.attrText = customerIDText;
    
    HSInfoLableItem *customerName = [HSInfoLableItem itemWithTitle:customerNameStr];
    customerName.attrText = customerNameText;
    
    HSInfoLableItem *contactPhone = [HSInfoLableItem itemWithTitle:contactPhoneStr];
    contactPhone.attrText = contactPhoneText;
    
    HSInfoLableItem *contactAddress = [HSInfoLableItem itemWithTitle:contactAddressStr];
    contactAddress.attrText = contactAddressText;
    
    HSInfoLableItem *remarks = [HSInfoLableItem itemWithTitle:remarksStr];
    remarks.attrText = remarksText;
    
    HSInfoGroup *g0 = [[HSInfoGroup alloc] init];
    g0.items = @[ customerID, customerName, contactPhone, contactAddress, remarks];
    g0.header = @"客户信息";
    
    [self.data addObject:g0];
}

- (void)setupGroup1{
    NSAttributedString *serviceTypeStr = [[NSAttributedString alloc]initWithString:@"服务类型" attributes:self.titleAttr];
    NSAttributedString *servicePriceStr = [[NSAttributedString alloc]initWithString:@"服务金额" attributes:self.titleAttr];
    NSAttributedString *paidAmountStr = [[NSAttributedString alloc]initWithString:@"实付金额" attributes:self.titleAttr];
    NSAttributedString *payTypeStr = [[NSAttributedString alloc]initWithString:@"付款类型" attributes:self.titleAttr];
    NSAttributedString *isSettledStr = [[NSAttributedString alloc]initWithString:@"是否结算" attributes:self.titleAttr];
    
    NSAttributedString *serviceTypeText = [[NSAttributedString alloc]initWithString:self.serviceOrder.serviceType attributes:self.labelAttr];
    
    NSAttributedString *servicePriceText = [[NSAttributedString alloc]initWithString:self.serviceOrder.servicePrice attributes:self.labelAttr];
    
    NSString *paidAmountString = [NSString stringWithFormat:@"%d元", self.serviceOrder.paidAmount];
    NSAttributedString *paidAmountText = [[NSAttributedString alloc]initWithString:paidAmountString attributes:self.labelAttr];
    
    NSString *payTypeString = [NSString string];
    if ([self.serviceOrder.payType isEqualToString:@""]) {
        payTypeString = @"客户尚未付款，暂无付款类型信息";
    }else{
        payTypeString = self.serviceOrder.payType;
    }

    NSAttributedString *payTypeText = [[NSAttributedString alloc]initWithString:payTypeString attributes:self.labelAttr];
    
    NSString *isSettledString = [NSString string];
    if (self.serviceOrder.isSettled) {
        isSettledString = @"已结算";
    }else{
        isSettledString = @"未结算";
    }
    
    NSAttributedString *isSettledText = [[NSAttributedString alloc]initWithString:isSettledString attributes:self.labelAttr];
    
    HSInfoLableItem *serviceType = [HSInfoLableItem itemWithTitle:serviceTypeStr];
    serviceType.attrText = serviceTypeText;
    
    HSInfoLableItem *servicePrice = [HSInfoLableItem itemWithTitle:servicePriceStr];
    servicePrice.attrText = servicePriceText;
    
    HSInfoLableItem *paidAmount = [HSInfoLableItem itemWithTitle:paidAmountStr];
    paidAmount.attrText = paidAmountText;
    
    HSInfoLableItem *payType = [HSInfoLableItem itemWithTitle:payTypeStr];
    payType.attrText = payTypeText;
    
    HSInfoLableItem *isSettled = [HSInfoLableItem itemWithTitle:isSettledStr];
    isSettled.attrText = isSettledText;
    
    HSInfoGroup *g1 = [[HSInfoGroup alloc] init];
    g1.items = @[ serviceType, servicePrice, paidAmount, payType, isSettled];
    g1.header = @"服务信息";
    
    [self.data addObject:g1];

}

- (void)setupGroup2{
    NSAttributedString *orderNoStr = [[NSAttributedString alloc]initWithString:@"订单编号" attributes:self.titleAttr];
    NSAttributedString *orderStatusStr = [[NSAttributedString alloc]initWithString:@"订单状态" attributes:self.titleAttr];
    NSAttributedString *orderTimeStr = [[NSAttributedString alloc]initWithString:@"订单时间" attributes:self.titleAttr];
    NSAttributedString *confirmTimeStr = [[NSAttributedString alloc]initWithString:@"确认时间" attributes:self.titleAttr];
    NSAttributedString *payTimeStr = [[NSAttributedString alloc]initWithString:@"付款时间" attributes:self.titleAttr];
    
    NSAttributedString *orderNoText = [[NSAttributedString alloc]initWithString:self.serviceOrder.orderNo attributes:self.labelAttr];
    
    NSAttributedString *orderStatusText = [[NSAttributedString alloc]initWithString:self.serviceOrder.orderStatus attributes:self.labelAttr];
    
    NSAttributedString *orderTimeText = [[NSAttributedString alloc]initWithString:self.serviceOrder.orderTime attributes:self.labelAttr];
    
    NSString *confirmTimeString = [NSString string];
    if (![self.serviceOrder.confirmTime isEqualToString:@""]) {
        confirmTimeString = self.serviceOrder.confirmTime;
    }else{
        confirmTimeString = @"客户尚未确认订单";
    }
    NSAttributedString *confirmTimeText = [[NSAttributedString alloc]initWithString:confirmTimeString attributes:self.labelAttr];
    
    NSString *payTimeString = [NSString string];
    if (![self.serviceOrder.confirmTime isEqualToString:@""]) {
        payTimeString = self.serviceOrder.payTime;
    }else{
        payTimeString = @"客户尚未付款";
    }
    NSAttributedString *payTimeText = [[NSAttributedString alloc]initWithString:payTimeString attributes:self.labelAttr];
    
    HSInfoLableItem *orderNo = [HSInfoLableItem itemWithTitle:orderNoStr];
    orderNo.attrText = orderNoText;
    
    HSInfoLableItem *orderStatus = [HSInfoLableItem itemWithTitle:orderStatusStr];
    orderStatus.attrText = orderStatusText;
    
    HSInfoLableItem *orderTime = [HSInfoLableItem itemWithTitle:orderTimeStr];
    orderTime.attrText = orderTimeText;
    
    HSInfoLableItem *confirmTime = [HSInfoLableItem itemWithTitle:confirmTimeStr];
    confirmTime.attrText = confirmTimeText;
    
    HSInfoLableItem *payTime = [HSInfoLableItem itemWithTitle:payTimeStr];
    payTime.attrText = payTimeText;

    HSInfoGroup *g2 = [[HSInfoGroup alloc] init];
    g2.items = @[ orderNo, orderStatus, orderTime, confirmTime, payTime];
    g2.header = @"订单信息";
    
    [self.data addObject:g2];

}

- (void)setupGroup3{
    NSMutableDictionary *titleAttr = [NSMutableDictionary dictionary];
    titleAttr[NSFontAttributeName] = [UIFont systemFontOfSize:15];
    titleAttr[NSForegroundColorAttributeName] = [UIColor darkGrayColor];
    titleAttr[NSForegroundColorAttributeName] =
    XBMakeColorWithRGB(28, 21, 80, 1);
    
    NSAttributedString *checkCommentStr = [[NSAttributedString alloc]initWithString:@"查看该客户评论对您的服务评价" attributes:titleAttr];

    HSInfoArrowItem *checkComment = [HSInfoArrowItem itemWithAttrTitle:checkCommentStr destVcClass:[HSOrderCommentViewController class]];
    
    HSInfoGroup *g3 = [[HSInfoGroup alloc] init];
    g3.items = @[checkComment];
    g3.header = @"查看评价";
    
    [self.data addObject:g3];
}
@end
