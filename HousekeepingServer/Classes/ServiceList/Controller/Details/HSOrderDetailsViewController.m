//
//  HSOrderDetailsViewController.m
//  HousekeepingServer
//
//  Created by Jacob on 15/10/14.
//  Copyright © 2015年 com.jacob. All rights reserved.
//

#import "HSOrderDetailsViewController.h"
#import "XBConst.h"
#import "HSOrderCommentViewController.h"
#import "MBProgressHUD.h"

@interface HSOrderDetailsViewController ()
@property (strong, nonatomic) RETableViewSection *customerInfoSection;
@property (strong, nonatomic) RETableViewSection *serviceInfoSection;
@property (strong, nonatomic) RETableViewSection *orderInfoSection;
@property (strong, nonatomic) RETableViewSection *commentSection;

@property (strong, nonatomic) NSMutableDictionary *titleAttr;
@property (strong, nonatomic) NSMutableDictionary *labelAttr;
@end

@implementation HSOrderDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 标题
    self.title = @"订单详情";
    self.clearsSelectionOnViewWillAppear = NO;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    // 添加第一组
    self.customerInfoSection = [self addCustomerInfoSection];
    
    // 添加第二组
    self.serviceInfoSection = [self addServiceInfoSection];
    
    // 添加第三组
    self.orderInfoSection = [self addOrderInfoSection];
    
    // 添加第四组
    self.commentSection = [self addCommentSection];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"正在加载";
    [hud hide:YES afterDelay:1.0];
    hud.completionBlock = ^{
        [self.tableView reloadData];
    };

}

- (RETableViewSection *)addCustomerInfoSection{
    RETableViewSection *section =
    [RETableViewSection sectionWithHeaderTitle:@"客户信息"];
    [self.manager addSection:section];
    
    NSString *remarksString = [NSString string];
    if (![self.serviceOrder.remarks isEqualToString:@""]) {
        remarksString = self.serviceOrder.remarks;
    }else{
        remarksString = @"该客户无备注";
    }
    
    RETextItem *customerID = [RETextItem itemWithTitle:@"客户ID" value:self.serviceOrder.customerID];
    RETextItem *customerName = [RETextItem itemWithTitle:@"客户姓名" value:self.serviceOrder.customerName];
    RETextItem *contactPhone = [RETextItem itemWithTitle:@"联系电话" value:[NSString stringWithFormat:@"%ld", self.serviceOrder.contactPhone]];
    RETextItem *contactAddress = [RETextItem itemWithTitle:@"通讯地址" value:self.serviceOrder.contactAddress];
    RETextItem *remarks = [RETextItem itemWithTitle:@"备注" value:remarksString];

    [section addItem:customerID];
    [section addItem:customerName];
    [section addItem:contactPhone];
    [section addItem:contactAddress];
    [section addItem:remarks];
    
    return section;
}

- (RETableViewSection *)addServiceInfoSection{
    RETableViewSection *section =
    [RETableViewSection sectionWithHeaderTitle:@"服务信息"];
    [self.manager addSection:section];
    
    NSString *paidAmountString = [NSString stringWithFormat:@"%d元", self.serviceOrder.paidAmount];
    
    NSString *payTypeString = [NSString string];
    if ([self.serviceOrder.payType isEqualToString:@""]) {
        payTypeString = @"客户尚未付款，暂无付款类型信息";
    }else{
        payTypeString = self.serviceOrder.payType;
    }
    
    NSString *isSettledString = [NSString string];
    if (self.serviceOrder.isSettled) {
        isSettledString = @"已结算";
    }else{
        isSettledString = @"未结算";
    }

    RETextItem *serviceType = [RETextItem itemWithTitle:@"服务类型" value:self.serviceOrder.serviceType];
    RETextItem *servicePrice= [RETextItem itemWithTitle:@"服务金额" value:self.serviceOrder.servicePrice];
    RETextItem *paidAmount = [RETextItem itemWithTitle:@"实付金额" value:paidAmountString];
    RETextItem *payType = [RETextItem itemWithTitle:@"付款类型" value:payTypeString];
    RETextItem *isSettled = [RETextItem itemWithTitle:@"是否结算" value:isSettledString];

    [section addItem:serviceType];
    [section addItem:servicePrice];
    [section addItem:paidAmount];
    [section addItem:payType];
    [section addItem:isSettled];
    
    return section;
}

- (RETableViewSection *)addOrderInfoSection{
    RETableViewSection *section =
    [RETableViewSection sectionWithHeaderTitle:@"订单信息"];
    [self.manager addSection:section];
    
    NSString *confirmTimeString = [NSString string];
    if (![self.serviceOrder.confirmTime isEqualToString:@""]) {
        confirmTimeString = self.serviceOrder.confirmTime;
    }else{
        confirmTimeString = @"客户尚未确认订单";
    }
    
    NSString *payTimeString = [NSString string];
    if (![self.serviceOrder.confirmTime isEqualToString:@""]) {
        payTimeString = self.serviceOrder.payTime;
    }else{
        payTimeString = @"客户尚未付款";
    }

    RETextItem *orderNo = [RETextItem itemWithTitle:@"订单编号" value:self.serviceOrder.orderNo];
    RETextItem *orderStatus= [RETextItem itemWithTitle:@"订单状态" value:self.serviceOrder.orderStatus];
    RETextItem *orderTime = [RETextItem itemWithTitle:@"订单时间" value:self.serviceOrder.orderTime];
    RETextItem *confirmTime = [RETextItem itemWithTitle:@"确认时间" value:confirmTimeString];
    RETextItem *payTime = [RETextItem itemWithTitle:@"付款时间" value:payTimeString];
    
    [section addItem:orderNo];
    [section addItem:orderStatus];
    [section addItem:orderTime];
    [section addItem:confirmTime];
    [section addItem:payTime];
    return section;
}

- (RETableViewSection *)addCommentSection{
    RETableViewSection *section =
    [RETableViewSection sectionWithHeaderTitle:@"客户评价"];
    [self.manager addSection:section];
    RETableViewItem *checkComment = [RETableViewItem itemWithTitle:@"查看客户评论对您的服务评价" accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
        [item deselectRowAnimated:YES];
        HSOrderCommentViewController *orderCommentVc = [[HSOrderCommentViewController alloc]init];
        orderCommentVc.servantID = self.serviceOrder.servantID;
        [self.navigationController pushViewController:orderCommentVc animated:YES];
    }];
    
    [section addItem:checkComment];
    return section;
}

- (void)tableView:(UITableView *)tableView
willLayoutCellSubviews:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath {
        for (UIView *view in cell.contentView.subviews) {
        if ([view isKindOfClass:[UILabel class]] ||
            [view isKindOfClass:[UITextField class]]) {
            ((UILabel *)view).font = [UIFont systemFontOfSize:14];
            ((UILabel *)view).textColor = [UIColor darkGrayColor];
            ((UILabel *)view).textAlignment = NSTextAlignmentLeft;
            if ([view isKindOfClass:[UITextField class]]) {
                CGRect temp = ((UILabel *)view).frame;
                temp.origin.x = 86;
                ((UILabel *)view).frame = temp;
            }
            ((UITextField *)view).enabled = NO;
        }
    }
}

@end
