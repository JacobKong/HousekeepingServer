//
//  HSOrderDetailsViewController.h
//  HousekeepingServer
//
//  Created by Jacob on 15/10/14.
//  Copyright © 2015年 com.jacob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSBaseViewController.h"
#import "HSServiceOrder.h"

@interface HSOrderDetailsViewController : HSBaseViewController
@property (strong, nonatomic) HSServiceOrder *serviceOrder;
@end
