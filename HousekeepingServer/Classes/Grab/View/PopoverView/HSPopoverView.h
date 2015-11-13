//
//  HSPopoverView.h
//  HousekeepingServer
//
//  Created by Jacob on 15/11/12.
//  Copyright © 2015年 com.jacob. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSPopoverView : UIImageView

@property (strong, nonatomic) UITableView *innerTableView;

+ (instancetype)popoverView;
@end
