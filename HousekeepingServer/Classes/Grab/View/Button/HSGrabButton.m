//
//  HSGrabButton.m
//  HousekeepingServer
//
//  Created by Jacob on 15/10/17.
//  Copyright © 2015年 com.jacob. All rights reserved.
//

#import "HSGrabButton.h"
#import "UIImage+HSResizingImage.h"

@implementation HSGrabButton
+ (instancetype)grabButton{
    // 设置详情按钮
    HSGrabButton *grabBtn = [HSGrabButton buttonWithType:UIButtonTypeCustom];
    [grabBtn setBackgroundImage:[UIImage resizeableImage:@"bg_detail_red"] forState:UIControlStateNormal];
    grabBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    grabBtn.bounds = CGRectMake(0, 0, 30, 30);
    [grabBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [grabBtn setTitle:@"抢" forState:UIControlStateNormal];
    return grabBtn;
}
@end
