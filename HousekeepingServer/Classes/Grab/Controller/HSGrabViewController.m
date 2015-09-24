//
//  HSGrabViewController.m
//  HousekeepingService
//
//  Created by Jacob on 15/9/19.
//  Copyright (c) 2015年 com.jacob. All rights reserved.
//

#import "HSGrabViewController.h"
#import "HSNavBarBtn.h"
#import "HSDropListViewController.h"
#import "HSRegionCollectionViewCell.h"
#import "HSRegion.h"
#import "MJExtension.h"


@interface HSGrabViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout, HSRegionColletionViewCellDelegate>{
    UICollectionView *mainCollectionView;
}
@property (strong, nonatomic) NSArray *regions;
@property (weak, nonatomic) UIButton *bgBtn;
@property (weak, nonatomic) HSNavBarBtn *leftNavBtn;
@property (weak, nonatomic) HSNavBarBtn *rightNavBtn;
@property (weak, nonatomic) UIButton *selectedRegionBtn;
@end

@implementation HSGrabViewController
- (NSArray *)regions{
    if (!_regions) {
        NSString *file = [[NSBundle mainBundle]pathForResource:@"citydata.plist" ofType:nil];
        NSArray *dictArray = [NSArray arrayWithContentsOfFile:file];
        _regions = [HSRegion objectArrayWithKeyValuesArray:dictArray];
    }
    return _regions;
}


- (void)viewDidLoad {
    [self setupNavBarBtn];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/**
 *  设置navBar的左右按钮
 */
- (void)setupNavBarBtn{
    // 左边选区的按钮
    HSNavBarBtn *leftNavBtn = [HSNavBarBtn navBarBtnWithTitle:@"选择地区" image:@"navigation_city_fold" highlightedImage:@"navigation_city_fold_highlighted" selectedImage:@"navigation_city_unfold"];
    leftNavBtn.frame = CGRectMake(0, 0, 70, 20);
    self.leftNavBtn = leftNavBtn;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.leftNavBtn];
    [leftNavBtn addTarget:self action:@selector(chooseRegion:) forControlEvents:UIControlEventTouchUpInside];
    
    // 右边选区的按钮
    HSNavBarBtn *rightNavBtn = [HSNavBarBtn navBarBtnWithTitle:@"选择服务" image:@"navigation_city_fold" highlightedImage:@"navigation_city_fold_highlighted" selectedImage:@"navigation_city_unfold"];
    rightNavBtn.frame = CGRectMake(0, 0, 70, 20);
    self.rightNavBtn = rightNavBtn;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.rightNavBtn];
    [rightNavBtn addTarget:self action:@selector(chooseService:) forControlEvents:UIControlEventTouchUpInside];


    
}
- (void)chooseRegion:(HSNavBarBtn *)button{
    button.selected = !button.selected;
    
    if (button.selected) {
        self.tableView.scrollEnabled = NO;
        [self setupBgButton];
        [self setupRegionCollectionView];
    }else{
        self.tableView.scrollEnabled = YES;
        [self.bgBtn removeFromSuperview];
        [mainCollectionView removeFromSuperview];
    }
}

- (void)chooseService:(HSNavBarBtn *)button{
    button.selected = !button.selected;
}
/**
 *  设置背景按钮
 */
- (void)setupBgButton{
    UIButton *bgBtn = [UIButton  buttonWithType:UIButtonTypeCustom];
    bgBtn.frame = self.view.bounds;
    [bgBtn setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
    [self.tableView addSubview:bgBtn];
    self.bgBtn = bgBtn;
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
    [self.tableView addSubview:mainCollectionView];
    mainCollectionView.backgroundColor = [UIColor whiteColor];
    
    // 四周间距
    layout.sectionInset = UIEdgeInsetsMake(20, 0, 0, 0);
    
    // 注册collectionViewCell
    [mainCollectionView registerClass:[HSRegionCollectionViewCell class] forCellWithReuseIdentifier:@"Region"];
    
    //4.设置代理
    mainCollectionView.delegate = self;
    mainCollectionView.dataSource = self;
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *ID = @"grab";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    // 如果缓存池中没有该ID的cell，则创建一个新的cell
    if (cell == nil) {
        // 创建一个新的cell
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:ID];
        cell.textLabel.text = @"test";
    }
    return cell;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIViewController *vc = [[UIViewController alloc]init];
    vc.view.backgroundColor = [UIColor blueColor];
    [self.navigationController pushViewController:vc animated:YES];
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
    cell.delegate = self;
    HSRegion *region = self.regions[indexPath.item];
    NSString *regionTitle = [NSString stringWithFormat:@"%@", region.areaName];
    [cell.regionBtn setTitle:regionTitle forState:UIControlStateNormal];
    [cell.regionBtn addTarget:self action:@selector(regionBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

/**
 *  cell按钮点击
*/
- (void)regionBtnClicked:(UIButton *)regionBtn{
    self.selectedRegionBtn.selected = NO;
    regionBtn.selected = YES;
    self.selectedRegionBtn = regionBtn;
    [self.leftNavBtn setTitle:regionBtn.titleLabel.text forState:UIControlStateNormal];
    
    [mainCollectionView removeFromSuperview];
    [self.bgBtn removeFromSuperview];
    self.leftNavBtn.selected = NO;
}
// 设置每个item的垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 20;
}

// 设置每个item的水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}


#pragma mark HSRegionColletionViewCellDelegate
- (void)didClickedTheCell:(HSRegionCollectionViewCell *)regionCell{
    regionCell.regionBtn.selected = YES;
}
@end
