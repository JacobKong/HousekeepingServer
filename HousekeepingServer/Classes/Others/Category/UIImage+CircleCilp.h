//
//  UIImage+CircleCilp.h
//  HousekeepingServer
//
//  Created by Jacob on 15/10/7.
//  Copyright © 2015年 com.jacob. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (CircleCilp)
+ (instancetype)clipImageWithName:(NSString *)name borderWidth:(CGFloat) borderWidth borderColor:(UIColor *)borderColor;

+ (instancetype)clipImageWithData:(NSData *)data borderWidth:(CGFloat) borderWidth borderColor:(UIColor *)borderColor;

+ (instancetype)clipImageWithImage:(UIImage *)image borderWidth:(CGFloat) borderWidth borderColor:(UIColor *)borderColor;

@end
