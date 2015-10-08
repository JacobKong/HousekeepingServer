//
//  HSHeadPictureView.h
//  HousekeepingServer
//
//  Created by Jacob on 15/10/7.
//  Copyright © 2015年 com.jacob. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HSHeadPictureViewDelegate <NSObject>

@optional
- (void)uploadButtonDidClicked;
@end
@interface HSHeadPictureView : UIView
+ (instancetype)headPictureView;
@property (weak, nonatomic) id<HSHeadPictureViewDelegate> delegate;
@property (strong, nonatomic) UIImageView *iconImg;
@end
