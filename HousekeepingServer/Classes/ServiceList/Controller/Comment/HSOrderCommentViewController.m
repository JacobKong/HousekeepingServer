//
//  HSOrderCommentViewController.m
//  HousekeepingServer
//
//  Created by Jacob on 15/10/14.
//  Copyright © 2015年 com.jacob. All rights reserved.
//

#import "HSOrderCommentViewController.h"
#import "HSOrderCommentCell.h"
#import "HSOrderComment.h"
#import "AFNetworking.h"
#import "HSHTTPRequestOperationManager.h"
#import "MBProgressHUD.h"
#import "XBConst.h"
#import "MJExtension.h"
#import "HSRefreshButton.h"
#import "HSRefreshLab.h"

@interface HSOrderCommentViewController ()<HSOrderCommentCellDelegate>{
    MBProgressHUD *hud;
}
@property (strong, nonatomic) HSRefreshButton *commentRefreshButton;
@property (strong, nonatomic) NSArray *orderComment;
@property(strong, nonatomic) HSRefreshLab *refreshLab;
@end

@implementation HSOrderCommentViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        return [super initWithStyle:UITableViewStyleGrouped];
    }
    return self;
}

- (HSRefreshButton *)commentRefreshButton {
    if (!_commentRefreshButton) {
        _commentRefreshButton = [HSRefreshButton refreshButton];
        [_commentRefreshButton addTarget:self
                                 action:@selector(loadComment)
                       forControlEvents:UIControlEventTouchUpInside];
    }
    return _commentRefreshButton;
}

- (id)initWithStyle:(UITableViewStyle)style {
    return [super initWithStyle:UITableViewStyleGrouped];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.orderComment = nil;
    self.tableView.rowHeight = 170;
    self.title = @"客户评价";
    self.clearsSelectionOnViewWillAppear = NO;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.orderComment = nil;
    [self loadComment];
}

- (void)loadComment{
    // 删除刷新按钮
    [self.commentRefreshButton removeFromSuperview];
    // 访问服务器
    __weak __typeof(self) weakSelf = self;
    hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.userInteractionEnabled = YES;
    hud.labelText = @"正在加载...";
    AFHTTPRequestOperationManager *manager =
    (AFHTTPRequestOperationManager *)[HSHTTPRequestOperationManager manager];
    NSMutableDictionary *attrDict = [NSMutableDictionary dictionary];
    attrDict[@"servantID"] = self.servantID;
    NSString *urlStr = [NSString
                        stringWithFormat:@"%@/MobileServantInfoAction?operation=_queryComment",
                        kHSBaseURL];
    
    [manager POST:urlStr
       parameters:attrDict
          success:^(AFHTTPRequestOperation *_Nonnull operation,
                    id _Nonnull responseObject) {
              [MBProgressHUD hideHUDForView:self.view animated:YES];
              if ([kServiceResponse isEqualToString:@"Success"]) {
                  hud.mode = MBProgressHUDModeCustomView;
                  hud.labelText = @"加载成功";
                  hud.customView = MBProgressHUDSuccessView;
                  [hud hide:YES afterDelay:0.5];
                  hud.completionBlock = ^{
                      _orderComment = [HSOrderComment objectArrayWithKeyValuesArray:kDataResponse];
                      if (_orderComment.count == 0) {
                          HSRefreshLab *refreshLab = [HSRefreshLab
                                                      refreshLabelWithText:
                                                      @"当前无客户对您的服务评价"];
                          CGFloat labelW = XBScreenWidth;
                          CGFloat labelX = 0;
                          CGFloat labelY = 10;
                          CGFloat labelH = 20;
                          refreshLab.frame = CGRectMake(labelX, labelY, labelW, labelH);
                          weakSelf.refreshLab = refreshLab;
                          [weakSelf.tableView reloadData];
                      }else{
                          [weakSelf.tableView reloadData];
                      }
                  };
              } else {
                  hud.mode = MBProgressHUDModeCustomView;
                  hud.labelText = @"加载失败，请重新加载";
                  hud.customView = MBProgressHUDErrorView;
                  [hud hide:YES afterDelay:2.0];
                  hud.completionBlock = ^{
                      CGFloat buttonW = 100;
                      CGFloat buttonX = self.view.center.x - 0.5*buttonW;
                      CGFloat buttonY = XBScreenHeight * 0.3;
                      CGFloat buttonH = 50;
                      weakSelf.commentRefreshButton.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
                      
                      [weakSelf.view
                       addSubview:weakSelf.commentRefreshButton];
                  };
            }
          }
          failure:^(AFHTTPRequestOperation *_Nonnull operation,
                    NSError *_Nonnull error) {
              XBLog(@"failure:%@", error);
              hud.mode = MBProgressHUDModeCustomView;
              hud.labelText = @"网络错误，请重新加载";
              hud.customView = MBProgressHUDErrorView;
              [hud hide:YES afterDelay:1.0];
              hud.completionBlock = ^{
                  CGFloat buttonW = 100;
                  CGFloat buttonX = self.view.center.x - 0.5*buttonW;
                  CGFloat buttonY = XBScreenHeight * 0.3;
                  CGFloat buttonH = 50;
                weakSelf.commentRefreshButton.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);

                [weakSelf.view
                   addSubview:weakSelf.commentRefreshButton];
              };
         }];
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _orderComment.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HSOrderCommentCell *cell = [HSOrderCommentCell cellWithTableView:tableView];
    if (self.orderComment.count) {
        cell.orderComment = self.orderComment[indexPath.section];
        cell.delegate = self;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}
#pragma mark - HSOrderCommentCellDelegate
- (void)confirmButtonDidClicked{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)reloadCommentButtonDidClicked{
    [self loadComment];
}

@end
