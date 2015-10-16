//
//  HSBaseViewController.h
//  HousekeepingServer
//
//  Created by Jacob on 15/9/26.
//  Copyright (c) 2015年 com.jacob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSMineKeys.h"
#import "XBConst.h"


@class HSInfoTableViewCell;
@interface HSBaseViewController : UITableViewController
@property (strong, nonatomic) NSMutableArray *data;
@property (strong, nonatomic) HSInfoTableViewCell *cell;
@end
