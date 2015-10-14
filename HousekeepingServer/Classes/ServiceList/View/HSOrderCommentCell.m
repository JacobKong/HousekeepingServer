//
//  HSOrderCommentCell.m
//  HousekeepingServer
//
//  Created by Jacob on 15/10/14.
//  Copyright © 2015年 com.jacob. All rights reserved.
//

#import "HSOrderCommentCell.h"
#import "UIImage+HSResizingImage.h"

@interface HSOrderCommentCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@property (weak, nonatomic) IBOutlet UITextView *commentTextView;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;


- (IBAction)confirm:(id)sender;

@end

@implementation HSOrderCommentCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    NSString *ID = @"cell";
    HSOrderCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    // 如果缓存池中没有该ID的cell，则创建一个新的cell
    if (cell == nil) {
        // 创建一个新的cell
        cell = [[[NSBundle mainBundle]loadNibNamed:@"HSOrderCommentCell" owner:nil options:nil]lastObject];
    }
    return cell;
}

- (void)awakeFromNib {
    self.layer.cornerRadius = 10;
    self.layer.masksToBounds = YES;
    [self.leftBtn setBackgroundImage:[UIImage resizeableImage:@"common_button_blue"] forState:UIControlStateNormal];
    [self.leftBtn setBackgroundImage:[UIImage resizeableImage:@"common_button_blue_highlighted"] forState:UIControlStateHighlighted];
    // 保持滚动帧率在55以上
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;

    // Initialization code
}

- (IBAction)confirm:(id)sender {
    
}
@end
