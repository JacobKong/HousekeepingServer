//
//  AppDelegate.m
//  HousekeepingService
//
//  Created by Jacob on 15/9/19.
//  Copyright (c) 2015年 com.jacob. All rights reserved.
//

#import "AppDelegate.h"
#import "HSTabBarViewController.h"
#import "HSServiceListViewController.h"
#import "HSLoginViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "HSHTTPRequestOperationManager.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import "HSAccount.h"
#import "HSAccountTool.h"
@interface AppDelegate () {
  UINavigationController *navigationController;
  BMKMapManager *_mapManager;
}

@property(strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  // 1.创建window
  self.window = [[UIWindow alloc] init];
  // 2.设置window的frame
  self.window.frame = [[UIScreen mainScreen] bounds];
  // 3.设置window的rootviewcontroller
  // 判断是否加载登录界面
  HSAccount *account = [HSAccountTool account];
  // 之前没有登录过
  if (!account) {
    HSLoginViewController *loginVc = [[HSLoginViewController alloc] init];
    self.window.rootViewController = loginVc;
  } else {
    self.window.rootViewController = [[HSTabBarViewController alloc] init];
  }
  // 定位访问
  self.locationManager = [[CLLocationManager alloc] init];

  if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {

    [self.locationManager requestWhenInUseAuthorization];
  }
  // 百度地图初始化
  _mapManager = [[BMKMapManager alloc] init];
  // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
  BOOL ret =
      [_mapManager start:@"w0eY93GmvqsdIip4rbVrBx3V" generalDelegate:nil];
  if (!ret) {
    NSLog(@"manager start failed!");
  }

  //  // 推送设置
  //-- Set Notification
  if ([application
          respondsToSelector:@selector(isRegisteredForRemoteNotifications)]) {
    // iOS 8 Notifications
    [application registerUserNotificationSettings:
                     [UIUserNotificationSettings
                         settingsForTypes:(UIUserNotificationTypeBadge |
                                           UIUserNotificationTypeAlert |
                                           UIRemoteNotificationTypeSound)
                               categories:nil]];

    [application registerForRemoteNotifications];
  } else {
    // iOS < 8 Notifications
    [application
        registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                            UIRemoteNotificationTypeAlert |
                                            UIRemoteNotificationTypeSound)];
  }

  // Add the navigation controller's view to the window and display.
  [self.window addSubview:navigationController.view];

  //设置状态栏的字体颜色模式
  [[UIApplication sharedApplication]
      setStatusBarStyle:UIStatusBarStyleLightContent];
  [self.window makeKeyAndVisible];
  // Override point for customization after application launch.
  return YES;
}

- (void)application:(UIApplication *)application
    didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
  XBLog(@"---token---%@", deviceToken);
}

- (void)application:(UIApplication *)application
    didReceiveRemoteNotification:(NSDictionary *)userInfo {
  NSLog(@"userInfo == %@", userInfo);
  NSString *message = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];

  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                  message:message
                                                 delegate:self
                                        cancelButtonTitle:@"取消"
                                        otherButtonTitles:@"确定", nil];

  [alert show];
}

- (void)application:(UIApplication *)application
    didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
  NSLog(@"Regist fail%@", error);
}

- (void)applicationWillResignActive:(UIApplication *)application {
  // Sent when the application is about to move from active to inactive state.
  // This can occur for certain types of temporary interruptions (such as an
  // incoming phone call or SMS message) or when the user quits the application
  // and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down
  // OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
  // Use this method to release shared resources, save user data, invalidate
  // timers, and store enough application state information to restore your
  // application to its current state in case it is terminated later.
  // If your application supports background execution, this method is called
  // instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
  // Called as part of the transition from the background to the inactive state;
  // here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
  // Restart any tasks that were paused (or not yet started) while the
  // application was inactive. If the application was previously in the
  // background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
  // Called when the application is about to terminate. Save data if
  // appropriate. See also applicationDidEnterBackground:.
}

@end
