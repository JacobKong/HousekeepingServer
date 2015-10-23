//
//  HSGrabButton.h
//  HousekeepingServer
//
//  Created by Jacob on 15/10/17.
//  Copyright © 2015年 com.jacob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSServiceDeclare.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>

@interface HSGrabButton : UIButton
@property (strong, nonatomic) HSServiceDeclare *serviceDeclare;
+ (instancetype)grabButton;
@end
