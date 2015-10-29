//
//  HSTabBarViewController.h
//  HousekeepingService
//
//  Created by Jacob on 15/9/19.
//  Copyright (c) 2015年 com.jacob. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HSTabBar;
@interface HSTabBarViewController : UITabBarController
@property (weak, nonatomic) HSTabBar *customTabBar;
//- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
@end
