//
//  HSOrderCommentViewController.h
//  HousekeepingServer
//
//  Created by Jacob on 15/10/14.
//  Copyright © 2015年 com.jacob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSServiceOrder.h"

@interface HSOrderCommentViewController : UITableViewController
@property (strong, nonatomic) HSServiceOrder *serviceOrder;
@end
