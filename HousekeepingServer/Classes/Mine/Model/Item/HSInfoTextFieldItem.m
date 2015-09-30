//
//  HSInfoTextFieldItem.m
//  HousekeepingServer
//
//  Created by Jacob on 15/9/26.
//  Copyright (c) 2015年 com.jacob. All rights reserved.
//

#import "HSInfoTextFieldItem.h"

@implementation HSInfoTextFieldItem
+ (instancetype)itemWithTitle:(NSAttributedString*)attrTitle placeholder:(NSAttributedString *)attrPlaceholder{
    HSInfoTextFieldItem *item = [[HSInfoTextFieldItem alloc]init];
    item.attrTitle = attrTitle;
    item.attrPlaceholder = attrPlaceholder;
    return item;
}

+ (instancetype)itemWithTitle:(NSAttributedString*)attrTitle placeholder:(NSAttributedString *)attrPlaceholder text:(NSString *)text{
    HSInfoTextFieldItem *item = [[HSInfoTextFieldItem alloc]init];
    item.attrTitle = attrTitle;
    item.attrPlaceholder = attrPlaceholder;
    item.text = text;
    return item;
}

+ (instancetype)itemWithIcon:(NSString *)icon placeholder:(NSAttributedString *)attrPlaceHolder{
    HSInfoTextFieldItem *item = [[HSInfoTextFieldItem alloc]init];
    item.icon = icon;
    item.attrPlaceholder = attrPlaceHolder;
    return item;
}
- (void)setKey:(NSString *)key
{
    [super setKey:key];
    
    _text = [HSMineTool objectForKey:key];
}

- (void)setText:(NSString *)text{
    _text = text;
    
//    [HSMineTool setObject:text forKey:self.key];
}
@end
