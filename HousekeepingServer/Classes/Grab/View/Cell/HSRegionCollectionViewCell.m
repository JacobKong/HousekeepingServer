//
//  HSRegionCollectionViewCell.m
//  HousekeepingServer
//
//  Created by Jacob on 15/9/24.
//  Copyright (c) 2015年 com.jacob. All rights reserved.
//

#import "HSRegionCollectionViewCell.h"

@interface HSRegionCollectionViewCell ()

@end

@implementation HSRegionCollectionViewCell

- (UIButton *)regionBtn{
    if (!_regionBtn) {
        _regionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_regionBtn setBackgroundImage:[UIImage imageNamed:@"navigation_bg_dropdown_left"] forState:UIControlStateNormal];
        [_regionBtn setBackgroundImage:[UIImage imageNamed:@"navigation_bg_dropdown_left_selected"] forState:UIControlStateSelected];
        [_regionBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_regionBtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        [_regionBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        
        _regionBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _regionBtn;
}
/**
 *  初始化cell
 */
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.regionBtn];
    }
    return self;
}


- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat regionBtnW = self.regionBtn.currentBackgroundImage.size.width;
    CGFloat regionBtnH = self.regionBtn.currentBackgroundImage.size.height;
    self.regionBtn.center = self.contentView.center;
    self.regionBtn.bounds = CGRectMake(0, 0, regionBtnW, regionBtnH);
}
@end
