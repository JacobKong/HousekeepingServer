//
//  HSMineViewController.m
//  HousekeepingService
//
//  Created by Jacob on 15/9/19.
//  Copyright (c) 2015年 com.jacob. All rights reserved.
//

#import "HSMineViewController.h"
#import "HSInfoArrowItem.h"
#import "HSInfoItem.h"
#import "HSBasicInfoViewController.h"
#import "HSSettingViewController.h"
#import "HSAboutViewController.h"
#import "HSInfoGroup.h"
#import "HSNavBarBtn.h"
#import "HSInfoHeaderView.h"
#import "XBConst.h"
#import "HSChangPwdViewController.h"

@interface HSMineViewController ()

@end

@implementation HSMineViewController

- (void)viewDidLoad {
    [self setupGroup0];
    [self setupGroup1];

    HSNavBarBtn *settingBtn = [HSNavBarBtn navBarBtnWithBgImage:@"navigation_setting_config"];
    CGFloat settingBtnW = settingBtn.currentBackgroundImage.size.width;
    CGFloat settingBtnH = settingBtn.currentBackgroundImage.size.height;
    settingBtn.frame = CGRectMake(0, 0, settingBtnW, settingBtnH);

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:settingBtn];
    [settingBtn addTarget:self action:@selector(settingBtnClicked) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"navigation_setting_config"] style:UIBarButtonItemStylePlain target:self action:@selector(settingBtnClicked)];
    [super viewDidLoad];
}

- (void)settingBtnClicked{
    HSSettingViewController *settingVc = [[HSSettingViewController alloc]init];
    [self.navigationController pushViewController:settingVc animated:YES];
}

/**
 *  设置第0组
 */
- (void)setupGroup0{
    HSInfoGroup *g0 = [[HSInfoGroup alloc]init];

    [self.data addObject:g0];

    self.tableView.tableHeaderView = [HSInfoHeaderView headerView];
}

- (void)setupGroup1{
    HSInfoItem *basicInfo = [HSInfoArrowItem itemWithIcon:@"MoreAbout" title:@"基本信息" destVcClass:[HSBasicInfoViewController class]];
    
    HSInfoItem *changeInfo = [HSInfoArrowItem itemWithIcon:@"MoreAbout" title:@"修改密码" destVcClass:[HSChangPwdViewController class]];
    
    HSInfoItem *about = [HSInfoArrowItem itemWithIcon:@"MoreAbout" title:@"关于软件" destVcClass:[HSAboutViewController class]];
    
    HSInfoGroup *g1 = [[HSInfoGroup alloc]init];
    g1.items = @[basicInfo, changeInfo, about];
    
    [self.data addObject:g1];

}



@end
