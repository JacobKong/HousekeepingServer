//
//  HSBaseViewController.h
//  HousekeepingServer
//
//  Created by Jacob on 15/9/26.
//  Copyright (c) 2015年 com.jacob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSMineKeys.h"
#import "XBConst.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <RETableViewManager/RETableViewManager.h>
#import "RETableViewOptionsController.h"
#import "LxDBAnything.h"

@class HSInfoTableViewCell;
@interface HSBaseViewController : UITableViewController<RETableViewManagerDelegate>

//@property (strong, nonatomic) NSMutableArray *data;
//@property (strong, nonatomic) HSInfoTableViewCell *cell;
@property (strong, nonatomic) RETableViewManager *manager;

// textfield长度是否正确
- (BOOL)isValidTextlength:(NSString *)text;
- (BOOL)isVaildPickerValue:(NSString *)text;
@end
