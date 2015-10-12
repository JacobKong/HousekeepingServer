//
//  HSSubServiceViewController.h
//  HousekeepingServer
//
//  Created by Jacob on 15/10/9.
//  Copyright © 2015年 com.jacob. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HSSubService;
@protocol HSSubServiceViewDelegate <NSObject>

@optional
- (void)tableView:(UITableView *)tableView didClickedRowAtIndexPath:(NSIndexPath *)indexPath;
@end
@interface HSSubServiceViewController : UITableViewController
@property (weak, nonatomic) id<HSSubServiceViewDelegate> delegate;
@property (copy, nonatomic) NSString *titleStr;
@property (strong, nonatomic) NSArray *subservice;
@end
