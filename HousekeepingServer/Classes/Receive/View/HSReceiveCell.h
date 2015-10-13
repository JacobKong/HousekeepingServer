//
//  HSReceiveCell.h
//  HousekeepingServer
//
//  Created by Jacob on 15/10/12.
//  Copyright © 2015年 com.jacob. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HSServiceReceive;
@class HSReceiveCell;
@protocol HSServiceCellDelegate <NSObject>

@optional
- (void)receiveCell:(HSReceiveCell *)receiveCell receiveButtonDidClickedAtIndexPath:(NSIndexPath *)indexPath;

- (void)receiveCell:(HSReceiveCell *)receiveCell refuseButtonDidClickedAtIndexPath:(NSIndexPath *)indexPath;

@end
@interface HSReceiveCell : UITableViewCell

@property (strong, nonatomic) HSServiceReceive *serviceReceive;
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (weak, nonatomic) id<HSServiceCellDelegate> delegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
