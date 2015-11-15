//
//  HSOrderCommentViewController.h
//  HousekeepingServer
//
//  Created by Jacob on 15/10/14.
//  Copyright © 2015年 com.jacob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSServiceOrder.h"

@protocol HSOrderCommentViewControllerDelegate <NSObject>



@end
@interface HSOrderCommentViewController : UITableViewController
@property (strong, nonatomic) HSServiceOrder *serviceOrder;
@property (strong, nonatomic) NSString *servantID;
@end
