//
//  HSTabBarViewController.m
//  HousekeepingService
//
//  Created by Jacob on 15/9/19.
//  Copyright (c) 2015年 com.jacob. All rights reserved.
//

#import "HSTabBarViewController.h"
#import "HSGrabViewController.h"
#import "HSMineViewController.h"
#import "HSReceiveViewController.h"
#import "HSServiceListViewController.h"
#import "HSTabBar.h"
#import "HSNavigationViewController.h"
#import "UIView+SetFrame.h"
#import "HSLoginViewController.h"
#import "HSAccountTool.h"
#import "HSAccount.h"


@interface HSTabBarViewController ()<HSTabBarDelegate>
@property (weak, nonatomic) HSTabBar *customTabBar;
@property (strong, nonatomic) HSLoginViewController *loginVc;
@end

@implementation HSTabBarViewController

- (void)viewDidLoad {
    // 添加tabbar
    [self setupTabbar];

    // 添加子控制器
    [self setupChildViewController];
    
    // 判断是否加载登录界面
    HSAccount *account = [HSAccountTool account];
    // 之前没有登录过
    if (!account) {
        if (!_loginVc) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                HSLoginViewController *loginVc = [[HSLoginViewController alloc]init];
                [self presentViewController:loginVc animated:YES completion:nil];
                _loginVc = loginVc;
            });
        }
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // 删除系统自带的tabberItem
    for (UIView *view in self.tabBar.subviews) {
        if ([view isKindOfClass:[UIControl class]]) {
            [view removeFromSuperview];
        }
    }
}
/**
 *  添加子控制器
 */
- (void)setupChildViewController{
    HSGrabViewController *grabVc = [[HSGrabViewController alloc]init];
    [self addTabBarItemWithViewController:grabVc title:@"我的抢单" image:@"tabbar_grab_os7" selectedImage:@"tabbar_grab_selected_os7"];
    
    HSReceiveViewController *receiveVc = [[HSReceiveViewController alloc]init];
    [self addTabBarItemWithViewController:receiveVc title:@"我的接单" image:@"tabbar_grab_os7" selectedImage:@"tabbar_grab_selected_os7"];
    
    HSServiceListViewController *serviceListVc = [[HSServiceListViewController alloc]init];
    [self addTabBarItemWithViewController:serviceListVc title:@"服务清单" image:@"tabbar_grab_os7" selectedImage:@"tabbar_grab_selected_os7"];

    
    HSMineViewController *mineVc = [[HSMineViewController alloc]init];
    [self addTabBarItemWithViewController:mineVc title:@"个人中心" image:@"tabbar_profile_os7" selectedImage:@"tabbar_profile_selected_os7"];
    
}

/**
 *  设置子控制器的tabbarItem
 */
- (void)addTabBarItemWithViewController:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedimage{
    // 1.设置控制器的属性
    vc.title = title;
    vc.tabBarItem.image = [UIImage imageNamed:image];
    vc.view.backgroundColor = [UIColor whiteColor];
    vc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedimage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    // 2.包装导航控制器
    HSNavigationViewController *nav = [[HSNavigationViewController alloc]initWithRootViewController:vc];
    [self addChildViewController:nav];
    
    // 3.添加tabber内部按钮
    [self.customTabBar addTabBarButtonWithItem:vc.tabBarItem];
}

/**
 *  添加自定义tabbar
 */
- (void)setupTabbar{
    HSTabBar *customTabBar = [[HSTabBar alloc]init];
    customTabBar.frame = self.tabBar.bounds;
    self.customTabBar = customTabBar;
    self.customTabBar.delegate = self;
    [self.tabBar addSubview:customTabBar];
}

#pragma mark - HSTabBarDelegate
- (void)tabBar:(HSTabBar *)tabBar didSelectedFrom:(int)from to:(int)to{
    self.selectedIndex = to;
}
@end
