//
//  HSGrabViewController.m
//  HousekeepingService
//
//  Created by Jacob on 15/9/19.
//  Copyright (c) 2015年 com.jacob. All rights reserved.
//

#import "HSGrabViewController.h"
#import "HSNavBarBtn.h"

@interface HSGrabViewController ()
@end

@implementation HSGrabViewController

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
    HSNavBarBtn *leftNavBtn = [HSNavBarBtn navBarBtnWithTitle:@"选择城市" image:@"navigation_city_fold" highlightedImage:@"navigation_city_fold_highlighted" selectedImage:@"navigation_city_unfold"];
    leftNavBtn.frame = CGRectMake(0, 0, 70, 20);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftNavBtn];
    [leftNavBtn addTarget:self action:@selector(chooseRegion:) forControlEvents:UIControlEventTouchUpInside];
    
    // 右边选区的按钮
    HSNavBarBtn *rightBtn = [HSNavBarBtn navBarBtnWithTitle:@"选择服务" image:@"navigation_city_fold" highlightedImage:@"navigation_city_fold_highlighted" selectedImage:@"navigation_city_unfold"];
    rightBtn.frame = CGRectMake(0, 0, 70, 20);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    [rightBtn addTarget:self action:@selector(chooseService:) forControlEvents:UIControlEventTouchUpInside];


    
}
- (void)chooseRegion:(HSNavBarBtn *)button{
    button.selected = !button.selected;
}

- (void)chooseService:(HSNavBarBtn *)button{
    button.selected = !button.selected;
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

@end
