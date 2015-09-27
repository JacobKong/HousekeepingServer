//
//  HSInfoTableViewCell.h
//  HousekeepingServer
//
//  Created by Jacob on 15/9/26.
//  Copyright (c) 2015年 com.jacob. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HSInfoItem;
@class HSNoBorderTextField;
@interface HSInfoTableViewCell : UITableViewCell
@property (strong, nonatomic) HSInfoItem *item;
@property (strong, nonatomic) HSNoBorderTextField *textField;


+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
