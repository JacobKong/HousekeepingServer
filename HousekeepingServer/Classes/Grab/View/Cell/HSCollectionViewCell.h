//
//  HSCollectionViewCell.h
//  HousekeepingServer
//
//  Created by Jacob on 15/10/8.
//  Copyright © 2015年 com.jacob. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HSCollectionViewCell;
@protocol HSCollectionViewCellDelegate <NSObject>

@optional

- (void)didClickedTheCell:(HSCollectionViewCell *)cellBtn;

@end

@interface HSCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) UIButton *cellBtn;
@property (weak, nonatomic) id<HSCollectionViewCellDelegate> delegate;
@end
