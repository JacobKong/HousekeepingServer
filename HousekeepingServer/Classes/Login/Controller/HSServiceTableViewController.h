//
//  HSServiceTableViewController.h
//  HousekeepingServer
//
//  Created by Jacob on 15/11/10.
//  Copyright © 2015年 com.jacob. All rights reserved.
//

#import "HSBaseViewController.h"
@class HSFinalRegistViewController;
@interface HSServiceTableViewController : HSBaseViewController
@property (strong, nonatomic) HSFinalRegistViewController *parentVc;
@property (strong, nonatomic) REMultipleChoiceItem *item;
@end
