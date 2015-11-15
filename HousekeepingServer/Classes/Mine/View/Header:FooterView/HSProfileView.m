//
//  HSProfileView.m
//  HousekeepingServer
//
//  Created by Jacob on 15/11/14.
//  Copyright © 2015年 com.jacob. All rights reserved.
//

#import "HSProfileView.h"
#import "HSServant.h"

@interface HSProfileView ()
@property (weak, nonatomic) IBOutlet UILabel *servantIDLabel;
@property (weak, nonatomic) IBOutlet UILabel *serviceItemLabel;
@property (weak, nonatomic) IBOutlet UILabel *workYearsLabel;
@property (weak, nonatomic) IBOutlet UITextView *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *registerDateLabel;
- (IBAction)checkProfile:(id)sender;
- (IBAction)checkComment:(id)sender;
- (IBAction)editProfile:(id)sender;


@end

@implementation HSProfileView
+ (instancetype)profileView{
    HSProfileView *profileView = [[[NSBundle mainBundle]loadNibNamed:@"HSProfileView" owner:nil options:nil]lastObject];
    return profileView;
}
- (void)setServant:(HSServant *)servant{
    _servant = servant;
    [self setupData];
}

/**
 *  加载数据
 */
- (void)setupData{
    self.servantIDLabel.text = self.servant.servantID;
    self.serviceItemLabel.text = self.servant.serviceItems;
    self.workYearsLabel.text = [NSString stringWithFormat:@"工作年限：%d年",self.servant.workYears];
    self.locationLabel.text = [NSString stringWithFormat:@"%@%@%@%@", self.servant.servantProvince, self.servant.servantCity, self.servant.servantCounty, self.servant.contactAddress];
    self.registerDateLabel.text = [NSString stringWithFormat:@"注册时间:%@", self.servant.registerDate];
}
- (IBAction)checkProfile:(id)sender {
}

- (IBAction)checkComment:(id)sender {
}

- (IBAction)editProfile:(id)sender {
}
@end
