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
@property (weak, nonatomic) IBOutlet UILabel *commentDateLab;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;


- (IBAction)confirm:(id)sender;
- (IBAction)reloadComment:(id)sender;

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
    [self.rightBtn setBackgroundImage:[UIImage resizeableImage:@"common_button_blue"] forState:UIControlStateNormal];
    [self.rightBtn setBackgroundImage:[UIImage resizeableImage:@"common_button_blue_highlighted"] forState:UIControlStateHighlighted];
    // 保持滚动帧率在55以上
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;

    // Initialization code
}

- (void)setOrderComment:(HSOrderComment *)orderComment{
    _orderComment = orderComment;
    
    // 设置数据
    [self setupData];
}

- (void)setupData{
    NSString *titleStr = [NSString stringWithFormat:@"客户%@对您的服务评价为：", self.orderComment.customerName];
    self.titleLab.text = titleStr;
    
    NSString *commentString = [NSString string];
    if ([self.orderComment.commentContent isEqualToString:@""]) {
        commentString = @"当前无该客户的对您的服务评价";
    }else{
        commentString = self.orderComment.commentContent;
    }
    self.commentTextView.text = commentString;
    
    NSString *commentDateStr = [NSString string];
    if ([self.orderComment.commentDate isEqualToString:@""]) {
        commentDateStr = @"暂无评价时间";
    }else{
        commentDateStr = [NSString stringWithFormat:@"评价时间：%@", self.orderComment.commentDate];
    }
    self.commentDateLab.text =commentDateStr;
}

- (IBAction)confirm:(id)sender {
    if ([self.delegate respondsToSelector:@selector(confirmButtonDidClicked)]) {
        [self.delegate confirmButtonDidClicked];
    }
}

- (IBAction)reloadComment:(id)sender {
    if ([self.delegate respondsToSelector:@selector(reloadCommentButtonDidClicked)]) {
        [self.delegate reloadCommentButtonDidClicked];
    }

}
@end
