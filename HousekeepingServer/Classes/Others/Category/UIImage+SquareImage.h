//
//  UIImage+SquareImage.h
//  HousekeepingServer
//
//  Created by Jacob on 15/10/8.
//  Copyright © 2015年 com.jacob. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (SquareImage)
+ (UIImage *)squareImageFromImage:(UIImage *)image scaledToSize:(CGSize)asize;
+ (UIImage *)scaleFromImage:(UIImage *)image toSize:(CGSize)size;
@end
