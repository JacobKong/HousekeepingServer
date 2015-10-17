//
//  HSRegionCollectionViewCell.h
//  HousekeepingServer
//
//  Created by Jacob on 15/9/24.
//  Copyright (c) 2015年 com.jacob. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HSRegionCollectionViewCell;
@protocol HSRegionColletionViewCellDelegate <NSObject>

@optional

- (void)didClickedTheCell:(HSRegionCollectionViewCell *)regionCell;

@end

@interface HSRegionCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) id<HSRegionColletionViewCellDelegate> delegate;
@property (strong, nonatomic) UIButton *regionBtn;
@end
