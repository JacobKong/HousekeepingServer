//
//  HSNavigationViewController.m
//  HousekeepingServer
//
//  Created by Jacob on 15/9/21.
//  Copyright (c) 2015年 com.jacob. All rights reserved.
//

#import "HSNavigationViewController.h"
#define HSColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
@interface HSNavigationViewController ()

@end

@implementation HSNavigationViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

+ (void)initialize
{
    // 设置导航栏主题
    [self setupNavBar];
    //设置导航栏的按钮样式
    [self setupNavBarItem];
}

/**
 *  设置导航栏主题
 */
+ (void)setupNavBar{
    // 取出appearance对象
    UINavigationBar *navBar = [UINavigationBar appearance];
    
    // 设置导航栏字体
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSForegroundColorAttributeName] = [UIColor whiteColor];
    dict[NSFontAttributeName] = [UIFont boldSystemFontOfSize:19];
    dict[UITextAttributeTextShadowOffset] = [NSValue valueWithUIOffset:UIOffsetZero];
    [navBar setTitleTextAttributes:dict];
    // 设置导航栏颜色
    [navBar setBarTintColor:HSColor(234, 103, 7)];
    // 设置返回按钮颜色
    [navBar setTintColor:[UIColor whiteColor]];
    // 设置indicator
    [navBar setBackIndicatorImage:[UIImage imageNamed:@"navigationbar_indicator"]];
    [navBar setBackIndicatorTransitionMaskImage:[UIImage imageNamed:@"navigationbar_indicator"]];
    
}

/**
 *  设置导航栏的按钮样式
 */
+ (void)setupNavBarItem{
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:14];
    textAttrs[UITextAttributeTextShadowOffset] = [NSValue valueWithUIOffset:UIOffsetZero];
    [item setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    [item setTitleTextAttributes:textAttrs forState:UIControlStateHighlighted];
}


- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }

    [super pushViewController:viewController animated:YES];
}
@end
