//
//  HSInfoLableItem.m
//  HousekeepingServer
//
//  Created by Jacob on 15/9/29.
//  Copyright (c) 2015年 com.jacob. All rights reserved.
//

#import "HSInfoLableItem.h"

@implementation HSInfoLableItem
- (void)setKey:(NSString *)key
{
    [super setKey:key];
    
    _text = [HSMineTool objectForKey:key];
}

- (void)setText:(NSString *)text
{
    _text = text;
    
    [HSMineTool setObject:text forKey:self.key];
}
@end
