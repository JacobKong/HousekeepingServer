//
//  HSPopoverView.m
//  HousekeepingServer
//
//  Created by Jacob on 15/11/12.
//  Copyright © 2015年 com.jacob. All rights reserved.
//

#import "HSPopoverView.h"
#import "XBConst.h"
#import "UIImage+HSResizingImage.h"
@implementation HSPopoverView
@synthesize innerTableView = _innerTableView;

+ (instancetype)popoverView{
    return [[self alloc]init];
}
- (instancetype)initPopoverViewWithBgImage:(NSString *)bgImage position:(CGPoint) position{
    UIImageView *tempImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:bgImage]];
    [tempImgView sizeToFit];
    CGFloat viewW = tempImgView.frame.size.width;
    CGFloat viewH = 110;
    CGFloat viewY = position.y;
    CGFloat viewX = position.x;
    CGRect satusFrame = CGRectMake(viewX, viewY, viewW, viewH);
    
    self = (HSPopoverView *)[[UIImageView alloc]
                  initWithImage:[UIImage resizeableImage:bgImage]];
    self.frame = satusFrame;
    

    return self;

}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.userInteractionEnabled = YES;
    }
    return self;
}
@end
