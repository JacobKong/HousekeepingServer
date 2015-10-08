//
//  HSRegistViewController.h
//  HousekeepingServer
//
//  Created by Jacob on 15/9/30.
//  Copyright (c) 2015年 com.jacob. All rights reserved.
//

#import "HSBaseViewController.h"
@class HSRegistViewController;
@protocol HSRegistViewContrllerDelegate <NSObject>

@optional
- (void)registViewController:(HSRegistViewController *)registVc passTextFieldValues:(NSArray *)basicInfoText;
@end
@interface HSRegistViewController : HSBaseViewController
@property (weak, nonatomic) id<HSRegistViewContrllerDelegate> delegate;

@end
