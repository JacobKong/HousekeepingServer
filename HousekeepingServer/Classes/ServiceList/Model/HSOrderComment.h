//
//  HSOrderComment.h
//  HousekeepingServer
//
//  Created by Jacob on 15/10/15.
//  Copyright © 2015年 com.jacob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSOrderComment : NSObject
@property (assign, nonatomic)  int ID;
@property (copy, nonatomic) NSString *servantID;
@property (copy, nonatomic) NSString *servantName;
@property (copy, nonatomic) NSString *customerID;
@property (copy, nonatomic) NSString *customerName;
@property (copy, nonatomic) NSString *commentContent;
@property (copy, nonatomic) NSString *commentDate;
@end
