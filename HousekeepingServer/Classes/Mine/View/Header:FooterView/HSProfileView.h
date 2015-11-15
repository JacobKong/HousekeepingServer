//
//  HSProfileView.h
//  HousekeepingServer
//
//  Created by Jacob on 15/11/14.
//  Copyright © 2015年 com.jacob. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HSServant;

@interface HSProfileView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *headPictureView;
@property (strong, nonatomic) HSServant *servant;
@property (weak, nonatomic) IBOutlet UIButton *editProfileButton;
@property (weak, nonatomic) IBOutlet UIButton *checkProfileButton;
@property (weak, nonatomic) IBOutlet UIButton *checkCommentButton;

+ (instancetype)profileView;
@end
