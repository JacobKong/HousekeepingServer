//
//  HSDropListViewController.m
//  HousekeepingServer
//
//  Created by Jacob on 15/9/24.
//  Copyright (c) 2015年 com.jacob. All rights reserved.
//

#import "HSDropListViewController.h"
#import "HSRegionCollectionViewCell.h"
#import "MJExtension.h"
#import "HSRegion.h"

@interface HSDropListViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>{
    UICollectionView *mainCollectionView;
}
@property (strong, nonatomic) NSArray *regions;
@end


@implementation HSDropListViewController
- (NSArray *)regions{
    if (!_regions) {
        NSString *file = [[NSBundle mainBundle]pathForResource:@"citydata.plist" ofType:nil];
        NSArray *dictArray = [NSArray arrayWithContentsOfFile:file];
        _regions = [HSRegion objectArrayWithKeyValuesArray:dictArray];
    }
    return _regions;
}
- (void)viewDidLoad{
//    self.view.backgroundColor = [UIColor whiteColor];
//    UIView *alphaView = [[UIView alloc] initWithFrame:self.view.frame];
//    UIView *baseView = [[UIView alloc] initWithFrame:self.view.frame];
//    alphaView.backgroundColor = [UIColor clearColor];
//    baseView.backgroundColor = [UIColor blackColor];
//    baseView.alpha = 0.7;
//    [self.view addSubview:baseView];
//    [self.view addSubview:alphaView];
    // 创建背景按钮
//    [self setupBgButton];
    
    // 设置collectionView
    [self setupRegionCollectionView];
    
    [super viewDidLoad];
    
}

/**
 *  设置背景按钮
 */
- (void)setupBgButton{
    UIButton *bgBtn = [UIButton  buttonWithType:UIButtonTypeCustom];
    bgBtn.frame = self.view.bounds;
    [bgBtn setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
    [self.view addSubview:bgBtn];
    [bgBtn addTarget:self action:@selector(dismissVc) forControlEvents:UIControlEventTouchUpInside];
}

- (void)dismissVc{
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 *  设置collectionView
 */
- (void)setupRegionCollectionView{
    // 初始化layout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    
    // 设置itemSize
    CGFloat itemSizeW = self.view.frame.size.width / 3;
    CGFloat itemSizeH = 43;
    layout.itemSize = CGSizeMake(itemSizeW, itemSizeH);
    
    // 设置collection滚动方向,竖直
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    CGFloat collectionViewW = self.view.frame.size.width;
    CGFloat collectionViewH = self.view.frame.size.height * 0.5;
    CGRect collectionViewF = CGRectMake(0, 0, collectionViewW, collectionViewH);
    mainCollectionView = [[UICollectionView alloc] initWithFrame:collectionViewF collectionViewLayout:layout];
    [self.view addSubview:mainCollectionView];
    mainCollectionView.backgroundColor = [UIColor whiteColor];
    
    // 四周间距
    layout.sectionInset = UIEdgeInsetsMake(20, 0, 0, 0);
    
    // 注册collectionViewCell
    [mainCollectionView registerClass:[HSRegionCollectionViewCell class] forCellWithReuseIdentifier:@"Region"];
    
    //4.设置代理
    mainCollectionView.delegate = self;
    mainCollectionView.dataSource = self;
}

#pragma mark CollectionView代理方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.regions.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HSRegionCollectionViewCell *cell = (HSRegionCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"Region" forIndexPath:indexPath];
    HSRegion *region = self.regions[indexPath.item];
    NSString *regionTitle = [NSString stringWithFormat:@"%@", region.areaName];
    [cell.regionBtn setTitle:regionTitle forState:UIControlStateNormal];
    
    return cell;
}

// 设置每个item的垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 20;
}

// 设置每个item的水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

@end
