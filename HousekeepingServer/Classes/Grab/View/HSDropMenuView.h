//
//  HSDropMenuView.h
//  HousekeepingServer
//
//  Created by Jacob on 15/9/22.
//  Copyright (c) 2015年 com.jacob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSTabBarButton.h"
#define HSNoFound (-1)

@interface HSIndexPath : NSObject


@property (nonatomic,assign) NSInteger column;//区分  0 为左边的   1 是 右边的
@property (nonatomic,assign) NSInteger row;

+ (instancetype)twIndexPathWithColumn:(NSInteger )column row:(NSInteger )row;
@end

@class HSDropMenuView;
@protocol HSDropMenuViewDatasource<NSObject>

- (NSInteger )dropMenuView:(HSDropMenuView *)dropMenuView numberWithIndexPath:(HSIndexPath *)indexPath;

- (NSString *)dropMenuView:(HSDropMenuView *)dropMenuView titleWithIndexPath:(HSIndexPath *)indexPath;


@end

@protocol HSDropMenuViewDelegate <NSObject>

- (void)dropMenuView:(HSDropMenuView *)dropMenuView didSelectWithIndexPath:(HSIndexPath *)indexPath;

@end

@interface HSDropMenuView : UIView
@property (nonatomic,weak) id<HSDropMenuViewDatasource> dataSource;
@property (nonatomic,weak) id<HSDropMenuViewDelegate> delegate;
@property (weak, nonatomic) HSTabBarButton *leftBtn;
@property (weak, nonatomic) HSTabBarButton *rightBtn;
- (void)reloadLeftTableView;

- (void)reloadRightTableView;

@end
