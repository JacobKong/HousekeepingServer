//
//  HSRefreshButton.m
//  HousekeepingServer
//
//  Created by Jacob on 15/10/9.
//  Copyright © 2015年 com.jacob. All rights reserved.
//

#import "HSRefreshButton.h"
#import "XBConst.h"
#import "UIImage+HSResizingImage.h"

@implementation HSRefreshButton
+ (instancetype)refreshButton{
    HSRefreshButton *button = [HSRefreshButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"重新加载" forState:UIControlStateNormal];
    [button setTitleColor:XBMakeColorWithRGB(234, 103, 7, 1) forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    [button setBackgroundImage:[UIImage resizeableImage:@"show_map_btn"] forState:UIControlStateNormal];
    
    [button setBackgroundImage:[UIImage resizeableImage:@"show_map_btn_highlighted"] forState:UIControlStateHighlighted];

    return button;
}
@end
