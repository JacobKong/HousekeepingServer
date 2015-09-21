//
//  HSTabBarViewController.m
//  HousekeepingService
//
//  Created by Jacob on 15/9/19.
//  Copyright (c) 2015年 com.jacob. All rights reserved.
//

#import "HSTabBarViewController.h"
#import "HSGrabViewController.h"
#import "HSHistoryViewController.h"
#import "HSMineViewController.h"
#import "HSReceiveViewController.h"
#import "HSServiceListViewController.h"

@interface HSTabBarViewController ()

@end

@implementation HSTabBarViewController

- (void)viewDidLoad {
    // 添加子控制器
    [self setupChildViewController];
    
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
    
    HSHistoryViewController *historyVc = [[HSHistoryViewController alloc]init];
    [self addTabBarItemWithViewController:historyVc title:@"历史接单" image:@"tabbar_grab_os7" selectedImage:@"tabbar_grab_selected_os7"];
    
    HSMineViewController *mineVc = [[HSMineViewController alloc]init];
    [self addTabBarItemWithViewController:mineVc title:@"我的信息" image:@"tabbar_grab_os7" selectedImage:@"tabbar_grab_selected_os7"];
    
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
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    [self addChildViewController:nav];
    
    // 3.添加tabber内部按钮
//    [self.customTabBar addTabBarButtonWithItem:vc.tabBarItem];
}
@end
