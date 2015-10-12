//
//  HSCollectionView.m
//  HousekeepingServer
//
//  Created by Jacob on 15/10/8.
//  Copyright © 2015年 com.jacob. All rights reserved.
//

#import "HSCollectionView.h"
#import "XBConst.h"

@implementation HSCollectionView
+ (HSCollectionView *)collectionView{
    
    // 初始化layout
    UICollectionViewFlowLayout *layout =
    [[UICollectionViewFlowLayout alloc] init];
    
    // 设置itemSize
    CGFloat itemSizeW = XBScreenWidth / 3;
    CGFloat itemSizeH = 43;
    layout.itemSize = CGSizeMake(itemSizeW, itemSizeH);
    
    // 设置collection滚动方向,竖直
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    // 四周间距
    layout.sectionInset = UIEdgeInsetsMake(20, 0, 0, 0);

    
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    HSCollectionView *collectionView = [[HSCollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    
    collectionView.backgroundColor = [UIColor whiteColor];
    
    return collectionView;
}
@end
