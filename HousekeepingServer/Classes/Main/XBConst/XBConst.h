//
//  XBConst.h
//  XBScrollPageController
//
//  Created by Scarecrow on 15/9/6.
//  Copyright (c) 2015年 xiu8. All rights reserved.
//

#import <UIKit/UIKit.h>

//获取屏幕尺寸
#define XBScreenWidth [UIScreen mainScreen].bounds.size.width
#define XBScreenHeight [UIScreen mainScreen].bounds.size.height
#define XBScreenBounds  [UIScreen mainScreen].bounds
#define iOS7x ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) && ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0f)

#ifdef DEBUG
#define XBLog(...) NSLog(__VA_ARGS__)
#else
#define XBLog(...) 
#endif

//随机色
#define XBRandomColor [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1]

#define XBMakeColorWithRGB(R,G,B,A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]
#define HSColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

// BasePath
//#define kHSBaseURL @"http://192.168.23.6:8080/NationalService"
#define kHSBaseURL @"http://219.216.65.182:8080/NationalService"
#define kServiceResponse responseObject[@"serverResponse"]
#define kDataResponse responseObject[@"data"]
#define kServerResponse data[@"serverResponse"]
#define kServerDataResponse data[@"data"]
// HUD View
#define kKeyWindow [UIApplication sharedApplication].keyWindow
#define MBProgressHUDSuccessView [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"success"]]
#define MBProgressHUDErrorView [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"error"]]

// key
#define RegionStrKey @"region"
#define ServiceStrKey @"service"
#define StatusStrKey @"status"
#define GrabBadgeValueKey @"grab"
#define ReceiveBadgeValueKey @"receive"
extern NSString *const kTagCollectionViewCellIdentifier;
extern NSString *const kPageCollectionViewCellIdentifier;
extern NSString *const kCachedTime;
extern NSString *const kCachedVCName;
extern CGFloat const kSelectionIndicatorHeight;