//
//  HSDeclareCell.h
//  HousekeepingServer
//
//  Created by Jacob on 15/10/10.
//  Copyright © 2015年 com.jacob. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HSServiceDeclare;
@class HSDeclareCell;
@protocol HSDeclareCellDelegate <NSObject>

@optional
- (void)declareCell:(HSDeclareCell *)declareCell leftButtonDidClickedAtIndexPath:(NSIndexPath *)indexPath;

- (void)declareCell:(HSDeclareCell *)declareCell rightButtonDidClickedAtIndexPath:(NSIndexPath *)indexPath;

@end
@interface HSDeclareCell : UITableViewCell

@property (weak, nonatomic) id<HSDeclareCellDelegate> delegate;
@property (strong, nonatomic) HSServiceDeclare *serviceDeclare;
@property (strong, nonatomic) NSIndexPath *indexPath;

@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *locationBtn;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

+ (instancetype)serviceDeclareCell;
@end
