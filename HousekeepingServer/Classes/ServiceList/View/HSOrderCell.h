//
//  HSOrderCell.h
//  HousekeepingServer
//
//  Created by Jacob on 15/10/13.
//  Copyright © 2015年 com.jacob. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HSServiceOrder;
@class HSOrderCell;
@protocol HSOrderCellDelegate <NSObject>

@optional
- (void)orderCell:(HSOrderCell *)orderCell leftButtonDidClickedAtIndexPath:(NSIndexPath *)indexPath;

@end
@interface HSOrderCell : UITableViewCell

@property (strong, nonatomic) HSServiceOrder *serviceOrder;
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) id<HSOrderCellDelegate> delegate;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
