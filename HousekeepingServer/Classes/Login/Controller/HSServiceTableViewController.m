//
//  HSServiceTableViewController.m
//  HousekeepingServer
//
//  Created by Jacob on 15/11/10.
//  Copyright © 2015年 com.jacob. All rights reserved.
//

#import "HSServiceTableViewController.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "HSHTTPRequestOperationManager.h"
#import "XBConst.h"
#import "HSService.h"
#import "MJExtension.h"
#import "HSRefreshButton.h"
#import "LxDBAnything.h"
#import "HSSubService.h"
#import "HSNavigationViewController.h"
#import "HSInfoFooterView.h"
#import "HSOrangeButton.h"
#import "HSFinalRegistViewController.h"

@interface HSServiceTableViewController ()
@property(strong, nonatomic) NSArray *service;
@property(strong, nonatomic) NSArray *subService;

@property(strong, nonatomic) NSArray *serviceNameArry;
@property(strong, nonatomic) NSArray *subserviceArray;
@property(strong, nonatomic) MBProgressHUD *hud;
@property(strong, nonatomic) HSRefreshButton *serviceRefreshButton;
@property(strong, nonatomic) UIView *backgroundView;
@property(strong, nonatomic) RETableViewSection *serviceSection;
@property(copy, nonatomic) NSString *selectedString;

@property(strong, nonatomic) HSOrangeButton *doneSelectBtn;

@end

@implementation HSServiceTableViewController

- (NSArray *)service {
  if (!_service) {
    _service = [NSArray array];
  }
  return _service;
}

- (NSArray *)subService {
  if (!_subService) {
    _subService = [NSArray array];
  }
  return _subService;
}

- (NSArray *)serviceNameArry {
  if (!_serviceNameArry) {
    _serviceNameArry = [NSArray array];
  }
  return _serviceNameArry;
}

- (NSArray *)subserviceArray {
  if (!_subserviceArray) {
    _subserviceArray = [NSArray array];
  }
  return _subserviceArray;
}

- (HSRefreshButton *)serviceRefreshButton {
  if (!_serviceRefreshButton) {
    _serviceRefreshButton = [HSRefreshButton refreshButton];
    [_serviceRefreshButton addTarget:self
                              action:@selector(loadService)
                    forControlEvents:UIControlEventTouchUpInside];
  }
  return _serviceRefreshButton;
}

- (UIView *)backgroundView {
  if (!_backgroundView) {
    _backgroundView = [[UIView alloc] initWithFrame:self.view.bounds];
    _backgroundView.backgroundColor = self.tableView.backgroundColor;
  }
  return _backgroundView;
}
- (void)setItem:(REMultipleChoiceItem *)item {
  _item = item;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.title = @"服务类型选择";
  self.serviceSection =
      [[RETableViewSection alloc] initWithHeaderTitle:@"服务大类"];
  [self.manager addSection:self.serviceSection];
  // 加载服务
  [self loadService];

  // Do any additional setup after loading the view.
}
/**
 *   加载父类服务
 */
- (void)loadService {
  // 将刷新按钮删除
  [self.serviceRefreshButton removeFromSuperview];
  [self.backgroundView removeFromSuperview];
  self.item.value = nil;
  [self.tableView reloadData];
  // weak self,否则block中循环引用
  __typeof(&*self) __weak weakSelf = self;
  // 创建hud
  _hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view
                              animated:YES];
  _hud.labelText = @"正在加载";
  //    hud.dimBackground = YES;

  AFHTTPRequestOperationManager *manager =
      (AFHTTPRequestOperationManager *)[HSHTTPRequestOperationManager manager];
  NSMutableDictionary *serviceAttrDict = [NSMutableDictionary dictionary];
  serviceAttrDict[@"typeName"] = @"";
  NSString *serviceUrlStr =
      [NSString stringWithFormat:@"%@/MobileServiceTypeAction?operation=_query",
                                 kHSBaseURL];
  [manager POST:serviceUrlStr
      parameters:serviceAttrDict
      success:^(AFHTTPRequestOperation *_Nonnull operation,
                id _Nonnull responseObject) {
        if ([kServiceResponse isEqualToString:@"Success"]) {
          [_hud hide:YES afterDelay:1.0];
          _hud.completionBlock = ^{
            weakSelf.service =
                [HSService objectArrayWithKeyValuesArray:kDataResponse];
            for (int i = 0; i < weakSelf.service.count; i++) {
              HSService *service = weakSelf.service[i];

              [weakSelf.serviceSection
                  addItem:[RETableViewItem
                                 itemWithTitle:service.typeName
                                 accessoryType:
                                     UITableViewCellAccessoryDisclosureIndicator
                              selectionHandler:^(RETableViewItem *item) {
                                [item deselectRowAnimated:YES];
                                [weakSelf loadSubservice:service.typeName];
                              }]];
            }
            [weakSelf.tableView reloadData];
          };

        } else {
          self.service = nil;
          _hud.mode = MBProgressHUDModeCustomView;
          _hud.labelText = @"加载失败";
          _hud.customView = MBProgressHUDErrorView;
          [_hud hide:YES afterDelay:1.0];
          _hud.completionBlock = ^{
            weakSelf.serviceRefreshButton.center = weakSelf.tableView.center;
            weakSelf.serviceRefreshButton.bounds = CGRectMake(0, 0, 100, 50);
            [weakSelf.tableView addSubview:weakSelf.serviceRefreshButton];
          };
        }
      }
      failure:^(AFHTTPRequestOperation *_Nonnull operation,
                NSError *_Nonnull error) {
        self.service = nil;
        [self.tableView reloadData];
        _hud.mode = MBProgressHUDModeCustomView;
        _hud.labelText = @"网络错误";
        _hud.customView = MBProgressHUDErrorView;
        [_hud hide:YES afterDelay:1.0];
        _hud.completionBlock = ^{
          weakSelf.serviceRefreshButton.frame = CGRectMake(
              XBScreenWidth * 0.5 - 50, XBScreenHeight * 0.3, 100, 30);

          [weakSelf.tableView addSubview:weakSelf.backgroundView];
          [weakSelf.tableView addSubview:weakSelf.serviceRefreshButton];
        };
      }];
}

/**
 *  加载子类
 */
- (void)loadSubservice:(NSString *)parent {
  __typeof(&*self) __weak weakSelf = self;
  // 向服务器发送请求
  // 取回serviceType
  AFHTTPRequestOperationManager *manager =
      (AFHTTPRequestOperationManager *)[HSHTTPRequestOperationManager manager];
  NSMutableDictionary *attrDict = [NSMutableDictionary dictionary];

  attrDict[@"typeName"] = parent;
  NSString *urlStr =
      [NSString stringWithFormat:@"%@/MobileServiceTypeAction?operation=_query",
                                 kHSBaseURL];
  [manager POST:urlStr
      parameters:attrDict
      success:^(AFHTTPRequestOperation *_Nonnull operation,
                id _Nonnull responseObject) {
        if ([kServiceResponse isEqualToString:@"Success"]) {
          self.subService =
              [HSSubService objectArrayWithKeyValuesArray:kDataResponse];
          // 有子类
          if (self.subService.count) {
            NSMutableArray *nameArray = [NSMutableArray array];
            for (int i = 0; i < self.subService.count; i++) {
              HSSubService *subservice = self.subService[i];
              [nameArray addObject:subservice.typeName];
            }
            self.subService = [nameArray copy];
            RETableViewOptionsController *subserviceOptionsVc =
                [[RETableViewOptionsController alloc]
                         initWithItem:self.item
                              options:self.subService
                       multipleChoice:YES
                    completionHandler:^(RETableViewItem *item) {
                      self.selectedString = @"";
                      for (int i = 0; i < self.item.value.count; i++) {
                        if (i != self.item.value.count - 1) {
                          self.selectedString = [self.selectedString
                              stringByAppendingString:self.item.value[i]];
                          self.selectedString = [self.selectedString
                              stringByAppendingString:@"|"];
                        } else {
                          self.selectedString = [self.selectedString
                              stringByAppendingString:self.item.value[i]];
                        }
                        NSLog(@"$$$$$$%@", self.selectedString);
                      }
                      [item reloadRowWithAnimation:UITableViewRowAnimationNone];
                    }];
            subserviceOptionsVc.title =
                [NSString stringWithFormat:@"当前已选-%@", parent];
            HSInfoFooterView *footerView = [HSInfoFooterView footerView];
            UIView *blankView = [[UIView alloc]
                initWithFrame:CGRectMake(0, 0, XBScreenWidth, 90)];
            HSOrangeButton *doneSelectBtn =
                [HSOrangeButton orangeButtonWithTitle:@"确认"];
            CGFloat buttonX = 10;
            CGFloat buttonW = blankView.frame.size.width - 2 * buttonX;
            CGFloat buttonH = 50;
            CGFloat buttonY = blankView.frame.size.height * 0.5 - buttonH * 0.5;
            doneSelectBtn.frame =
                CGRectMake(buttonX, buttonY, buttonW, buttonH);
            doneSelectBtn.enabled = YES;
            doneSelectBtn.alpha = 1;
            [doneSelectBtn addTarget:self
                              action:@selector(doneSelectBtnClicked)
                    forControlEvents:UIControlEventTouchUpInside];
            [blankView addSubview:doneSelectBtn];
            [footerView addSubview:blankView];
            subserviceOptionsVc.tableView.tableFooterView = footerView;
            weakSelf.doneSelectBtn = doneSelectBtn;

            [weakSelf.navigationController
                pushViewController:subserviceOptionsVc
                          animated:YES];
          } else { // 没有子类
            self.item.detailLabelText = parent;
            [self.item reloadRowWithAnimation:UITableViewRowAnimationNone];
            [self.navigationController popViewControllerAnimated:YES];
          }
        }
      }
      failure:^(AFHTTPRequestOperation *_Nonnull operation,
                NSError *_Nonnull error) {
        XBLog(@"error:%@", error);
        _hud.mode = MBProgressHUDModeCustomView;
        _hud.labelText = @"网络错误";
        _hud.customView = MBProgressHUDErrorView;
        [_hud hide:YES afterDelay:1.0];
      }];
}

- (void)doneSelectBtnClicked {
  [self.navigationController popToViewController:self.parentVc animated:YES];
  if (![self.selectedString isEqualToString:@""] &&
      self.selectedString != nil) {
    self.item.detailLabelText = self.selectedString;
  } else {
    self.item.detailLabelText = @"请选择服务项目";
  }
  [self.item reloadRowWithAnimation:UITableViewRowAnimationNone];
}
@end
