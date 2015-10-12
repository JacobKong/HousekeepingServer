//
//  HSSubServiceViewController.m
//  HousekeepingServer
//
//  Created by Jacob on 15/10/9.
//  Copyright © 2015年 com.jacob. All rights reserved.
//

#import "HSSubServiceViewController.h"
#import "HSSubService.h"

@interface HSSubServiceViewController ()

@end

@implementation HSSubServiceViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    // 设置标题
    self.title = self.titleStr;
    // 设置行高
    self.tableView.rowHeight = 50;
    // 设置导航栏按钮
    [self setupNavBarBtn];
}

- (void)setupNavBarBtn{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"navigation_common_icon_close_white"] style:UIBarButtonItemStylePlain target:self action:@selector(cancelBtnClicked)];
}

- (void)cancelBtnClicked{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.subservice.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *ID = @"subService";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    // 如果缓存池中没有该ID的cell，则创建一个新的cell
    if (cell == nil) {
        // 创建一个新的cell
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:ID];
        HSSubService *subService = self.subservice[indexPath.row];
        cell.textLabel.text = subService.typeName;
//        cell.imageView.image = [UIImage imageNamed:subService.typeLogo];
        cell.detailTextLabel.text = subService.typeIntro;
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.delegate respondsToSelector:@selector(tableView:didClickedRowAtIndexPath:)]) {
        [self.delegate tableView:tableView didClickedRowAtIndexPath:indexPath];
    }
}
@end
