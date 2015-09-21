//
//  HSTabBarButton.m
//  HousekeepingServer
//
//  Created by Jacob on 15/9/21.
//  Copyright (c) 2015年 com.jacob. All rights reserved.
//

#import "HSTabBarButton.h"
#define HSColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
@implementation HSTabBarButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView.contentMode = UIViewContentModeCenter;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:11];
        [self setTitleColor:HSColor(234, 103, 7) forState:UIControlStateSelected];
        [self setTitleColor:HSColor(117, 117, 117) forState:UIControlStateNormal];

    }
    
    return self;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    CGFloat imgW = self.frame.size.width;
    CGFloat imgH = self.frame.size.height * 0.6;
    CGFloat imgX = 0;
    CGFloat imgY = 0;
    return CGRectMake(imgX, imgY, imgW, imgH);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    CGFloat titleW = self.frame.size.width;
    CGFloat titleH = self.frame.size.height * 0.4;
    CGFloat titleX = 0;
    CGFloat titleY = self.imageView.frame.size.height;
    return CGRectMake(titleX, titleY, titleW, titleH);
}

- (void)setItem:(UITabBarItem *)item{
    _item = item;
    
    // KVO
    [item addObserver:self forKeyPath:@"title" options:0 context:nil];
    [item addObserver:self forKeyPath:@"image" options:0 context:nil];
    [item addObserver:self forKeyPath:@"selectedImage" options:0 context:nil];
    
    [self observeValueForKeyPath:nil ofObject:nil change:nil context:nil];
    
}

- (void)dealloc{
    [self.item removeObserver:self forKeyPath:@"title"];
    [self.item removeObserver:self forKeyPath:@"image"];
    [self.item removeObserver:self forKeyPath:@"selectedImage"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    // 设置文字
    [self setTitle:self.item.title forState:UIControlStateNormal];
    [self setTitle:self.item.title forState:UIControlStateSelected];
    
    // 设置图片
    [self setImage:self.item.image forState:UIControlStateNormal];
    [self setImage:self.item.selectedImage forState:UIControlStateSelected];
    
}


@end
