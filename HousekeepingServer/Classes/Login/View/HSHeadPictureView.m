//
//  HSHeadPictureView.m
//  HousekeepingServer
//
//  Created by Jacob on 15/10/7.
//  Copyright © 2015年 com.jacob. All rights reserved.
//

#import "HSHeadPictureView.h"
#import "XBConst.h"

@interface HSHeadPictureView ()
@property (strong, nonatomic) UIButton *uploadBtn;
@end

@implementation HSHeadPictureView
- (UIImageView *)iconImg{
    if (!_iconImg) {
        _iconImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon"]];
        _iconImg.userInteractionEnabled = YES;
        _iconImg.bounds = CGRectMake(0, 0, 100, 100);
        UITapGestureRecognizer *iconTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(uploadBtnClicked)];
        [_iconImg addGestureRecognizer:iconTap];
    }
    return _iconImg;
}

- (UIButton *)uploadBtn{
    if (!_uploadBtn) {
        _uploadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_uploadBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_uploadBtn setTitle:@"上传头像" forState:UIControlStateNormal];
        _uploadBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_uploadBtn addTarget:self action:@selector(uploadBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _uploadBtn;
}

- (void)uploadBtnClicked{
    if ([self.delegate respondsToSelector:@selector(uploadButtonDidClicked)]) {
        [self.delegate uploadButtonDidClicked];
    }
}

+ (instancetype)headPictureView{
    return [[self alloc]init];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        CGFloat iconViewW = XBScreenWidth;
        CGFloat iconViewH = XBScreenHeight * 0.3;
        self.frame = CGRectMake(0, 0, iconViewW, iconViewH);
        
        [self addSubview:self.iconImg];
        [self addSubview:self.uploadBtn];

    }
    return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    self.iconImg.center = self.center;
    
    CGFloat uploadBtnY = self.iconImg.frame.origin.y + self.iconImg.frame.size.height + 10;
    CGFloat uploadBtnW = 100;
    CGFloat uploadBtnX = self.frame.size.width * 0.5 - 0.5 * uploadBtnW;
    CGFloat uploadBtnH = 20;
    self.uploadBtn.frame = CGRectMake(uploadBtnX, uploadBtnY, uploadBtnW, uploadBtnH);
}
@end
