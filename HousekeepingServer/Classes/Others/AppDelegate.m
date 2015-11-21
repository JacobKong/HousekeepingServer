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
#import "AFNetworking.h"
#import "HSServant.h"
#import "HSServantTool.h"
#import "HSTabBarButton.h"
#import "HSTabBar.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import "AFNetworkActivityIndicatorManager.h"

@interface AppDelegate () <UIAlertViewDelegate>{
  UINavigationController *navigationController;
    HSTabBarViewController *_tabBarVc;
  BMKMapManager *_mapManager;
}

@property(strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) HSServant *servant;
@end

@implementation AppDelegate
- (HSServant *)servant{
    if (!_servant) {
        _servant = [HSServantTool servant];
    }
    return _servant;
}

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
    XBLog(@"manager start failed!");
  }
    // 在 App 启动时注册百度云推送服务，需要提供 Apikey
    [BPush registerChannel:launchOptions apiKey:@"w0eY93GmvqsdIip4rbVrBx3V" pushMode:BPushModeDevelopment withFirstAction:nil withSecondAction:nil withCategory:nil isDebug:YES];

    // App 是用户点击推送消息启动
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo) {
        XBLog(@"从消息启动:%@",userInfo);
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
// fabric
    [Fabric with:@[[Crashlytics class]]];
    // 状态栏菊花显示
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];

  return YES;
}

- (void)application:(UIApplication *)application
    didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
  XBLog(@"---token---%@", deviceToken);
    //  向云推送注册 device token
    [BPush registerDeviceToken:deviceToken];
    // 绑定channel.将会在回调中看获得channnelid appid userid 等
    // 判断是否登录
    HSAccount *account = [HSAccountTool account];
    // 之前登录过
    if (account) {
        [BPush bindChannelWithCompleteHandler:^(NSDictionary *result, NSError *error) {
            // 需要在绑定成功后进行 settag listtag deletetag unbind 操作否则会失败
            XBLog(@"result---------%@, %@, %@", result, result[@"user_id"], self.servant.servantID);
            NSString *baiduUser = result[@"user_id"];
            NSString *channelID = result[@"channel_id"];
            if (result) {
                [BPush setTag:@"Mytag" withCompleteHandler:^(id result, NSError *error) {
                    if (result) {
                        // 访问服务器
                        AFHTTPRequestOperationManager *manager =
                        (AFHTTPRequestOperationManager *)[HSHTTPRequestOperationManager manager];
                        
                        // url
                        NSString *urlStr = [NSString
                                            stringWithFormat:@"%@/StoreRelationServlet?userID=%@&baiduUser=%@&channelID=%@&identification=ios",
                                            kHSBaseURL, self.servant.servantID, baiduUser, channelID];
                        XBLog(@"urlStr%@", urlStr);
                        [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                            XBLog(@"%@", responseObject);
                        } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
                            XBLog(@"%@", error);
                        }];
                    }
                }];
            }
        }];
    }
    
}

// 此方法是 用户点击了通知，应用在前台 或者开启后台并且应用在后台 时调起
- (void)application:(UIApplication *)application
    didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(nonnull void (^)(UIBackgroundFetchResult))completionHandler{
    
    completionHandler(UIBackgroundFetchResultNewData);
    XBLog(@"********** iOS7.0之后 background **********");
    // 应用在前台 或者后台开启状态下，不跳转页面，让用户选择。
    if (application.applicationState == UIApplicationStateActive || application.applicationState == UIApplicationStateBackground) {
        XBLog(@"acitve or background");
        UIAlertView *alertView =[[UIAlertView alloc]initWithTitle:@"收到一条消息" message:userInfo[@"aps"][@"alert"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }
    else//杀死状态下，直接跳转到跳转页面。
    {
        [self openReceiveVc];
    }
}

// 在 iOS8 系统中，还需要添加这个方法。通过新的 API 注册推送服务
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application
    didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
  XBLog(@"DeviceToken 获取失败，原因：%@",error);
}

#pragma mark - UIAlerViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self openReceiveVc];
    }
}

- (void)openReceiveVc{
    for (HSTabBarButton *button in _tabBarVc.customTabBar.subviews) {
        if (button.tag == 1) {
            [_tabBarVc.customTabBar tabBarBtnDidSelected:button];
        }
    }
    self.window.rootViewController = _tabBarVc;
}
@end
