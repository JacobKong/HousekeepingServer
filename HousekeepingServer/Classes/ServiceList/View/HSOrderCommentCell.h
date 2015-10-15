//
//  HSOrderCommentCell.h
//  HousekeepingServer
//
//  Created by Jacob on 15/10/14.
//  Copyright © 2015年 com.jacob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSOrderComment.h"

@protocol HSOrderCommentCellDelegate <NSObject>

@optional
- (void)confirmButtonDidClicked;
- (void)reloadCommentButtonDidClicked;

@end
@interface HSOrderCommentCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (strong, nonatomic) HSOrderComment *orderComment;
@property (weak, nonatomic) id<HSOrderCommentCellDelegate> delegate;
@end
