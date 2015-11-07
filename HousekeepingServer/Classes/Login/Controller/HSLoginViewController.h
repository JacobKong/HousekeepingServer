//
//  HSLoginViewController.h
//  HousekeepingServer
//
//  Created by Jacob on 15/9/30.
//  Copyright (c) 2015年 com.jacob. All rights reserved.
//

#import "HSBaseViewController.h"
#import <RETableViewManager/RETableViewManager.h>
#import "RETableViewOptionsController.h"

@interface HSLoginViewController : UITableViewController<RETableViewManagerDelegate>
@property (strong, readonly, nonatomic) RETableViewManager *manager;
@property (strong, readonly, nonatomic) RETableViewSection *loginInfoSection;
@end
