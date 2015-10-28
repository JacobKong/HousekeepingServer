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
#import "BPush.h"
#import "HSGrabViewController.h"
@interface AppDelegate () <UIAlertViewDelegate>{
  UINavigationController *navigationController;
    HSTabBarViewController *_tabBarVc;
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
      HSTabBarViewController *tabBarVc = [[HSTabBarViewController alloc]init];
    self.window.rootViewController = tabBarVc;
      _tabBarVc = tabBarVc;
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
    // 在 App 启动时注册百度云推送服务，需要提供 Apikey
    [BPush registerChannel:launchOptions apiKey:@"w0eY93GmvqsdIip4rbVrBx3V" pushMode:BPushModeDevelopment withFirstAction:nil withSecondAction:nil withCategory:nil isDebug:YES];

    // App 是用户点击推送消息启动
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo) {
        NSLog(@"从消息启动:%@",userInfo);
        [BPush handleNotification:userInfo];
    }
    
#if TARGET_IPHONE_SIMULATOR
    Byte dt[32] = {0xc6, 0x1e, 0x5a, 0x13, 0x2d, 0x04, 0x83, 0x82, 0x12, 0x4c, 0x26, 0xcd, 0x0c, 0x16, 0xf6, 0x7c, 0x74, 0x78, 0xb3, 0x5f, 0x6b, 0x37, 0x0a, 0x42, 0x4f, 0xe7, 0x97, 0xdc, 0x9f, 0x3a, 0x54, 0x10};
    [self application:application didRegisterForRemoteNotificationsWithDeviceToken:[NSData dataWithBytes:dt length:32]];
#endif
    //角标清0
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];

    // Add the navigation controller's view to the window and display.
    [self.window addSubview:navigationController.view];
    
    //设置状态栏的字体颜色模式
    [[UIApplication sharedApplication]
     setStatusBarStyle:UIStatusBarStyleLightContent];
    [self.window makeKeyAndVisible];

  return YES;
}

- (void)application:(UIApplication *)application
    didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
  XBLog(@"---token---%@", deviceToken);
    //  向云推送注册 device token
    [BPush registerDeviceToken:deviceToken];
    // 绑定channel.将会在回调中看获得channnelid appid userid 等
    [BPush bindChannelWithCompleteHandler:^(id result, NSError *error) {
        // 需要在绑定成功后进行 settag listtag deletetag unbind 操作否则会失败
        NSLog(@"result---------%@", result);
        if (result) {
            [BPush setTag:@"Mytag" withCompleteHandler:^(id result, NSError *error) {
                if (result) {
                    NSLog(@"设置tag成功");
                }
            }];
        }
    }];
    
}

// 此方法是 用户点击了通知，应用在前台 或者开启后台并且应用在后台 时调起
- (void)application:(UIApplication *)application
    didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(nonnull void (^)(UIBackgroundFetchResult))completionHandler{
    
    completionHandler(UIBackgroundFetchResultNewData);
    NSLog(@"********** iOS7.0之后 background **********");
    // 应用在前台 或者后台开启状态下，不跳转页面，让用户选择。
    if (application.applicationState == UIApplicationStateActive || application.applicationState == UIApplicationStateBackground) {
        NSLog(@"acitve or background");
        UIAlertView *alertView =[[UIAlertView alloc]initWithTitle:@"收到一条消息" message:userInfo[@"aps"][@"alert"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }
    else//杀死状态下，直接跳转到跳转页面。
    {
        self.window.rootViewController = _tabBarVc;
    }
}

// 在 iOS8 系统中，还需要添加这个方法。通过新的 API 注册推送服务
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    // App 收到推送的通知
    [BPush handleNotification:userInfo];
    NSLog(@"********** ios7.0之前 **********");
    // 应用在前台 或者后台开启状态下，不跳转页面，让用户选择。
    if (application.applicationState == UIApplicationStateActive || application.applicationState == UIApplicationStateBackground) {
        NSLog(@"acitve or background");
        UIAlertView *alertView =[[UIAlertView alloc]initWithTitle:@"收到一条消息" message:userInfo[@"aps"][@"alert"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }
    else//杀死状态下，直接跳转到跳转页面。
    {
        HSGrabViewController *grabVc = [[HSGrabViewController alloc]init];
        // 根视图是nav 用push方式跳转
        [_tabBarVc.selectedViewController pushViewController:grabVc animated:YES];

    }
    NSLog(@"%@",userInfo);
}


- (void)application:(UIApplication *)application
    didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
  XBLog(@"DeviceToken 获取失败，原因：%@",error);
}

#pragma mark -
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        _tabBarVc.selectedIndex = 0;
    }
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
