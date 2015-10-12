//
//  HSCollectionViewCell.m
//  HousekeepingServer
//
//  Created by Jacob on 15/10/8.
//  Copyright © 2015年 com.jacob. All rights reserved.
//

#import "HSCollectionViewCell.h"

@implementation HSCollectionViewCell
- (UIButton *)cellBtn{
    if (!_cellBtn) {
        _cellBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cellBtn setBackgroundImage:[UIImage imageNamed:@"navigation_bg_dropdown_left"] forState:UIControlStateNormal];
        [_cellBtn setBackgroundImage:[UIImage imageNamed:@"navigation_bg_dropdown_left_selected"] forState:UIControlStateSelected];
        [_cellBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_cellBtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        [_cellBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        
        _cellBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _cellBtn;
}
/**
 *  初始化cell
 */
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.cellBtn];
    }
    return self;
}


- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat cellBtnW = self.cellBtn.currentBackgroundImage.size.width;
    CGFloat cellBtnH = self.cellBtn.currentBackgroundImage.size.height;
    self.cellBtn.center = self.contentView.center;
    self.cellBtn.bounds = CGRectMake(0, 0, cellBtnW, cellBtnH);
}

@end
