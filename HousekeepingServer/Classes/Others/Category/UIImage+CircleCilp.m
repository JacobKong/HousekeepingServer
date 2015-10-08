//
//  UIImage+CircleCilp.m
//  HousekeepingServer
//
//  Created by Jacob on 15/10/7.
//  Copyright © 2015年 com.jacob. All rights reserved.
//

#import "UIImage+CircleCilp.h"

@implementation UIImage (CircleCilp)
+ (instancetype)clipImageWithName:(NSString *)name borderWidth:(CGFloat) borderWidth borderColor:(UIColor *)borderColor{
    UIImage *oldImage = [UIImage imageNamed:name];
    
    // 画外层边框
    CGFloat borderW = borderWidth;  // 圆环宽度
    CGFloat imageW = oldImage.size.width + 2 * borderW;
    CGFloat imageH = oldImage.size.height + 2 * borderW;
    CGSize imageSize = CGSizeMake(imageW, imageH);
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
    
    // 获取当前上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 画外层大圆
    [borderColor set];
    CGFloat bigRadius = imageW * 0.5;  // 大圆半径
    CGFloat centerX = bigRadius;       // 圆心
    CGFloat centerY = bigRadius;
    CGContextAddArc(ctx, centerX, centerY, bigRadius, 0, M_PI * 2, 0);
    CGContextFillPath(ctx);
    
    // 画内层小圆
    CGFloat smallRadius = bigRadius - borderW;
    CGContextAddArc(ctx, centerX, centerY, smallRadius, 0, M_PI * 2, 0);
    // 裁剪(后面画的东西才会受裁剪的影响)
    CGContextClip(ctx);
    
    // 画图
    [oldImage drawInRect:CGRectMake(borderW, borderW, 2 * smallRadius,
                                    2 * smallRadius)];
    // 获取新图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    // 结束上下文
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (instancetype)clipImageWithData:(NSData *)data borderWidth:(CGFloat) borderWidth borderColor:(UIColor *)borderColor{
    UIImage *oldImage = [UIImage imageWithData:data];
    
    // 画外层边框
    CGFloat borderW = borderWidth;  // 圆环宽度
    CGFloat imageW = oldImage.size.width + 2 * borderW;
    CGFloat imageH = oldImage.size.height + 2 * borderW;
    CGSize imageSize = CGSizeMake(imageW, imageH);
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
    
    // 获取当前上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 画外层大圆
    [borderColor set];
    CGFloat bigRadius = imageW * 0.5;  // 大圆半径
    CGFloat centerX = bigRadius;       // 圆心
    CGFloat centerY = bigRadius;
    CGContextAddArc(ctx, centerX, centerY, bigRadius, 0, M_PI * 2, 0);
    CGContextFillPath(ctx);
    
    // 画内层小圆
    CGFloat smallRadius = bigRadius - borderW;
    CGContextAddArc(ctx, centerX, centerY, smallRadius, 0, M_PI * 2, 0);
    // 裁剪(后面画的东西才会受裁剪的影响)
    CGContextClip(ctx);
    
    // 画图
    [oldImage drawInRect:CGRectMake(borderW, borderW, 2 * smallRadius,
                                    2 * smallRadius)];
    // 获取新图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    // 结束上下文
    UIGraphicsEndImageContext();
    
    return newImage;

}

+ (instancetype)clipImageWithImage:(UIImage *)image borderWidth:(CGFloat) borderWidth borderColor:(UIColor *)borderColor{
    UIImage *oldImage = image;
    
    // 画外层边框
    CGFloat borderW = borderWidth;  // 圆环宽度
    CGFloat imageW = oldImage.size.width + 2 * borderW;
    CGFloat imageH = oldImage.size.height + 2 * borderW;
    CGSize imageSize = CGSizeMake(imageW, imageH);
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
    
    // 获取当前上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 画外层大圆
    [borderColor set];
    CGFloat bigRadius = imageW * 0.5;  // 大圆半径
    CGFloat centerX = bigRadius;       // 圆心
    CGFloat centerY = bigRadius;
    CGContextAddArc(ctx, centerX, centerY, bigRadius, 0, M_PI * 2, 0);
    CGContextFillPath(ctx);
    
    // 画内层小圆
    CGFloat smallRadius = bigRadius - borderW;
    CGContextAddArc(ctx, centerX, centerY, smallRadius, 0, M_PI * 2, 0);
    // 裁剪(后面画的东西才会受裁剪的影响)
    CGContextClip(ctx);
    
    // 画图
    [oldImage drawInRect:CGRectMake(borderW, borderW, 2 * smallRadius,
                                    2 * smallRadius)];
    // 获取新图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    // 结束上下文
    UIGraphicsEndImageContext();
    
    return newImage;

}

@end
