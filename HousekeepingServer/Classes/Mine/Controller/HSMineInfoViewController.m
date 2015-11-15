//
//  HSMineInfoViewController.m
//  HousekeepingServer
//
//  Created by Jacob on 15/10/15.
//  Copyright © 2015年 com.jacob. All rights reserved.
//

#import "HSMineInfoViewController.h"
#import "BPush.h"
#import "HSLoginViewController.h"
#import "HSServant.h"
#import "HSServantTool.h"
#import "HSProfileView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImage+SquareImage.h"
#import "UIImage+CircleCilp.h"
#import "HSAccount.h"
#import "HSAccountTool.h"
#import "HSOrderCommentViewController.h"
#import "HSNavigationViewController.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "HSHTTPRequestOperationManager.h"
#import "MJExtension.h"
#import "HSProfileInfoViewController.h"

#define BPushBoolKey @"BPush"
@interface HSMineInfoViewController ()<UIActionSheetDelegate,UIAlertViewDelegate,
UIPickerViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (strong, nonatomic) HSServant *servant;

@property (strong, nonatomic) RETableViewSection *section1;
@property (strong, nonatomic) RETableViewSection *section2;
@property (strong, nonatomic) HSProfileView *profileHeaderView;
@property (weak, nonatomic) UIButton *editButton;
@property (weak, nonatomic) UIButton *checkProfileButton;
@property (weak, nonatomic) UIButton *checkCommentButton;
@property (weak, nonatomic) UIImageView *headerPictureView;
@property (copy, nonatomic) NSString *fullPath;
@property (copy, nonatomic) NSString *headPicture;
@property (strong, nonatomic) NSURL *iconImageFilePath;
@property(assign, nonatomic) int isSuccess; // 上传图片是否成功

@property(strong, nonatomic) NSArray *servantArray;
@end

@implementation HSMineInfoViewController
#pragma mark - getter
- (HSServant *)servant {
    if (!_servant) {
        _servant = [HSServantTool servant];
    }
    return _servant;
}

#pragma mark - view加载
- (void)viewDidLoad{
    [super viewDidLoad];
    // 创建表头
    [self setupProfileHeaderView];
    // 第一组
    self.section1 = [self addSection1];
    // 第二组
    self.section2 = [self addSection2];
    // 创建footer
    [self setupFooterView];
    // 创建按钮信号
    [self setupButtonClickSignal];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.profileHeaderView.servant = self.servant;
    // 加载头像
    [self setupHeadPictureWithServant:self.servant];
    self.tableView.backgroundColor = XBMakeColorWithRGB(234, 234, 234, 1);
}
#pragma mark - 初始化
/**
 *  表头
 */
- (void)setupProfileHeaderView{
    self.profileHeaderView = [HSProfileView profileView];
    self.profileHeaderView.servant = self.servant;
    self.editButton = self.profileHeaderView.editProfileButton;
    self.checkProfileButton = self.profileHeaderView.checkProfileButton;
    self.checkCommentButton = self.profileHeaderView.checkCommentButton;
    self.headerPictureView = self.profileHeaderView.headPictureView;
    // 添加点击时间
    UITapGestureRecognizer *iconTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(whenClickHeadImage)];
    [self.headerPictureView addGestureRecognizer:iconTap];

    self.tableView.tableHeaderView = self.profileHeaderView;
}
/**
 *  第一组
 */
- (RETableViewSection *)addSection1{
    RETableViewSection *section =
    [RETableViewSection sectionWithHeaderTitle:@" "];
    [self.manager addSection:section];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *BPushSwitchValue = [userDefaults objectForKey:BPushBoolKey];
    BOOL switchValue;
    if (!BPushSwitchValue) {
        switchValue = YES;
    }else{
        switchValue = [BPushSwitchValue boolValue];
    }
    REBoolItem *pushItem = [REBoolItem itemWithTitle:@"是否推送" value:switchValue switchValueChangeHandler:^(REBoolItem *item) {
        // 存储value
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:[NSString stringWithFormat:@"%d", item.value] forKey:BPushBoolKey];
        [defaults synchronize];
        
        if (item.value) {
            // 打开推送
            [self registBPush];
        }else{
            // 关闭推送
            [self closeBPush];
        }
    }];
    
    RETableViewItem *logoutItem = [RETableViewItem itemWithTitle:@"注销登录" accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item) {
        [item deselectRowAnimated:YES];
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"您确定退出吗？"
                              message:@"退" @"出" @"后"
                              @"您可能无法收到订单消息及推送，您确定退"
                              @"出吗？"
                              delegate:self
                              cancelButtonTitle:@"取消"
                              otherButtonTitles:@"确定退出", nil];
        alert.delegate = self;
        [alert show];
    }];
    
    [section addItem:pushItem];
    [section addItem:logoutItem];
    return section;
}
/**
 *  第二组
 */
- (RETableViewSection *)addSection2{
    RETableViewSection *section =
    [RETableViewSection sectionWithHeaderTitle:@" "];
    [self.manager addSection:section];
    
    RETableViewItem *updateVersionItem = [RETableViewItem itemWithTitle:@"检查更新" accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item) {
        [item deselectRowAnimated:YES];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"正在检查更新";
        [hud hide:YES afterDelay:1.0];
        hud.completionBlock = ^{
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"目前已是最新版本" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        };
    }];
    
    RETableViewItem *versionItem = [RETableViewItem itemWithTitle:@"版本信息" accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
        [item deselectRowAnimated:YES];
    }];
    
    [section addItem:updateVersionItem];
    [section addItem:versionItem];
    return section;
}
- (void)setupFooterView{
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, XBScreenWidth, 100)];
    self.tableView.tableFooterView = footerView;
}
/**
 *  创建按钮点击信号
 */
- (void)setupButtonClickSignal{
    __typeof(&*self) __weak weakSelf = self;
    [[self.editButton rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         [weakSelf editProfile];
     }];
    
    [[self.checkProfileButton rac_signalForControlEvents:UIControlEventTouchUpInside]
    subscribeNext:^(id x) {
        [weakSelf checkProfile];
    }];
    
    [[self.checkCommentButton rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         [weakSelf checkComment];
     }];

}

/**
 *  创建头像
 */
- (void)setupHeadPictureWithServant:(HSServant *)servant {
    __weak __typeof(self) weakSelf = self;
    NSString *headPicture = servant.headPicture;
    NSString *pictureURLStr =
    [NSString stringWithFormat:@"%@/%@", kHSBaseURL, headPicture];
    NSURL *pictureURL = [NSURL URLWithString:pictureURLStr];
    
    [self.profileHeaderView.headPictureView
     sd_setImageWithURL:pictureURL
     placeholderImage:[UIImage imageNamed:@"icon"]
     options:SDWebImageRetryFailed
     completed:^(UIImage *image, NSError *error,
                 SDImageCacheType cacheType, NSURL *imageURL) {
         NSString *picName = @"headPicture.png";
         [weakSelf saveImage:image
                    withName:picName
                  completion:^{
                      [weakSelf.tableView reloadData];
                  }];
         _headPicture = picName;
     }];
}

#pragma mark - 按钮点击
- (void)checkProfile {
    HSProfileInfoViewController *profileVc = [[HSProfileInfoViewController alloc]init];
    HSNavigationViewController *nav = [[HSNavigationViewController alloc]initWithRootViewController:profileVc];
    [self presentViewController:nav animated:YES completion:^{
        profileVc.iconImageFilePath = self.iconImageFilePath;
    }];
}

- (void)checkComment {
    HSOrderCommentViewController *orderCommentVc = [[HSOrderCommentViewController alloc]init];
    orderCommentVc.servantID = self.servant.servantID;
    HSNavigationViewController *nav = [[HSNavigationViewController alloc]initWithRootViewController:orderCommentVc];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)editProfile {
    [self checkProfile];
}

/**
 *  头像点击
 */
- (void)whenClickHeadImage {
    
    UIActionSheet *sheet;
    sheet = [[UIActionSheet alloc] initWithTitle:@"选择头像上传"
                                        delegate:self
                               cancelButtonTitle:@"取消"
                          destructiveButtonTitle:@"从相册选择"
                               otherButtonTitles:@"从相机中选择", nil];
    sheet.tag = 255;
    sheet.actionSheetStyle = UIBarStyleBlackOpaque;
    [sheet showInView:self.view];
}

#pragma mark - 数据上传
- (int)updateInfo {
    _isSuccess = 0;
    MBProgressHUD *hud =
    [MBProgressHUD showHUDAddedTo:self.tableView
                         animated:YES];
    // 访问服务器
    AFHTTPRequestOperationManager *manager =
    (AFHTTPRequestOperationManager *)[HSHTTPRequestOperationManager manager];
    // 数据体
    NSMutableDictionary *attrDict = [NSMutableDictionary dictionary];
    attrDict[@"id"] = [NSString stringWithFormat:@"%d", self.servant.ID];
    attrDict[@"servantName"] = self.servant.servantName;
    attrDict[@"loginPassword"] = self.servant.loginPassword;
    attrDict[@"phoneNo"] = [NSString stringWithFormat:@"%ld",self.servant.phoneNo];
    attrDict[@"servantMobil"] = [NSString stringWithFormat:@"%ld",self.servant.servantMobil];
    attrDict[@"servantProvince"] = self.servant.servantProvince;
    attrDict[@"servantCity"] = self.servant.servantCity;
    attrDict[@"servantCounty"] = self.servant.servantCounty;
    attrDict[@"contactAddress"] = self.servant.contactAddress;
    attrDict[@"qqNumber"] = [NSString stringWithFormat:@"%ld", self.servant.qqNumber];
    attrDict[@"emailAddress"] = self.servant.emailAddress;
    attrDict[@"realLongitude"] = [NSString stringWithFormat:@"%f", self.servant.realLongitude];
    attrDict[@"realLatitude"] = [NSString stringWithFormat:@"%f", self.servant.realLatitude];
    
    NSString *urlStr = [NSString
                        stringWithFormat:@"%@/MoblieServantRegisteAction?operation=_update",
                        kHSBaseURL];
    
    [manager POST:urlStr
       parameters:attrDict
constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
    XBLog(@"%@", _iconImageFilePath);
    [formData appendPartWithFileURL:_iconImageFilePath
                               name:@"headPicture"
                              error:nil];
}
          success:^(AFHTTPRequestOperation *_Nonnull operation,
                    id _Nonnull responseObject) {
              NSString *serverResponse = responseObject[@"serverResponse"];
              if ([serverResponse isEqualToString:@"Success"]) {
                  hud.mode = MBProgressHUDModeCustomView;
                  hud.labelText = @"保存并上传成功";
                  hud.customView = MBProgressHUDSuccessView;
                  [hud hide:YES afterDelay:1.0];
                  // 存档
                  hud.completionBlock = ^{
                      _servantArray =
                      [HSServant objectArrayWithKeyValuesArray:kDataResponse];
                      
                      // 创建模型
                      HSServant *servant = _servantArray.lastObject;
                      // 存档
                      [HSServantTool saveServant:servant];
                  };
                  _isSuccess = 1;
              } else {
                  hud.mode = MBProgressHUDModeCustomView;
                  hud.labelText = @"保存上传失败";
                  hud.customView = MBProgressHUDErrorView;
                  [hud hide:YES afterDelay:1.0];
                  _isSuccess = 0;
              }
          }
          failure:^(AFHTTPRequestOperation *_Nonnull operation,
                    NSError *_Nonnull error) {
              hud.mode = MBProgressHUDModeCustomView;
              hud.labelText = @"网络错误，请重新操作";
              hud.customView = MBProgressHUDErrorView;
              [hud hide:YES afterDelay:1.0];
              XBLog(@"error%@", error);
              _isSuccess = -1;
          }];
    return _isSuccess;
}

#pragma mark - 推送
#pragma mark - 注册推送服务
- (void)registBPush {
    UIApplication *application = [UIApplication sharedApplication];
    //  // 推送设置
    //-- Set Notification
    if ([application
         respondsToSelector:@selector(isRegisteredForRemoteNotifications)]) {
        // iOS 8 Notifications
        [application registerUserNotificationSettings:
         [UIUserNotificationSettings
          settingsForTypes:(UIUserNotificationTypeBadge |
                            UIUserNotificationTypeAlert |
                            UIRemoteNotificationTypeSound)
          categories:nil]];
        
        [application registerForRemoteNotifications];
    } else {
        // iOS < 8 Notifications
        [application
         registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                             UIRemoteNotificationTypeAlert |
                                             UIRemoteNotificationTypeSound)];
    }
}

/**
 *  关闭推送
 */
- (void)closeBPush{
    [[UIApplication sharedApplication] unregisterForRemoteNotifications];
    [BPush unbindChannelWithCompleteHandler:^(id result, NSError *error) {
        if (result) {
            XBLog(@"unbindChannelWithCompleteHandler--%@", result);
        }
        if (error) {
            XBLog(@"unbindChannelWithCompleteHandlerError--%@", error);
        }
    }];
}

/**
 *  清空所有偏好设置
 */
- (void)resetDefaults {
    
    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
    
    NSDictionary* dict = [defs dictionaryRepresentation];
    
    for(id key in dict) {
        
        [defs removeObjectForKey:key];
        
    }
    
    [defs synchronize];
    
}
#pragma mark - delegate
#pragma mark  UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        // 删除本地账户
        [HSAccountTool removeAccount];
        // 删除servant信息
        [HSServantTool removeServant];
        // 清楚用户偏好
        [self resetDefaults];
        // 跳到登录界面
        HSLoginViewController *loginVc = [[HSLoginViewController alloc] init];
        [self presentViewController:loginVc animated:YES completion:nil];
        [self closeBPush];
    }
}

#pragma mark  UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet
clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.tag == 255) {
        NSUInteger sourceType = 0;
        switch (buttonIndex) {
            case 0:
                // 相册  或者 UIImagePickerControllerSourceTypePhotoLibrary
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                XBLog(@"选择相册图片");
                break;
                //相机
            case 1: {
                sourceType = UIImagePickerControllerSourceTypeCamera;
                if (![UIImagePickerController
                      isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                    UIAlertView *alert =
                    [[UIAlertView alloc] initWithTitle:nil
                                               message:@"Test on real device, camera "
                     @"is not available in simulator"
                                              delegate:nil
                                     cancelButtonTitle:nil
                                     otherButtonTitles:@"OK", nil];
                    [alert show];
                    return;
                }
            } break;
            case 2:
                return;
        }
        // 跳转到相机或相册页面
        UIImagePickerController *imagePickerController =
        [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = sourceType;
        [self presentViewController:imagePickerController
                           animated:YES
                         completion:^{
                         }];
    }
}

#pragma mark - UIPickerViewDelegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES
                             completion:^{
                             }];
}

#pragma mark - UIImagePickerDelegte
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:picker.view animated:YES];
    hud.labelText = @"正在上传";
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    NSString *picName = @"headPicture.png";
    _headPicture = picName;
    [self saveImage:image
           withName:_headPicture
         completion:^{
             [self updateInfo];
             [hud hide:YES afterDelay:2];
             hud.completionBlock = ^{
                 [picker dismissViewControllerAnimated:
                  YES completion:^{
                      MBProgressHUD *hud =
                      [MBProgressHUD showHUDAddedTo:self.tableView
                                           animated:YES];
                      if (_isSuccess == 1) {
                          
                          hud.mode = MBProgressHUDModeCustomView;
                          hud.labelText = @"上传成功";
                          hud.customView = MBProgressHUDSuccessView;
                          [hud hide:YES afterDelay:1.0];
                      } else if (_isSuccess == 0) {
                          hud.mode = MBProgressHUDModeCustomView;
                          hud.labelText = @"上传失败";
                          hud.customView = MBProgressHUDErrorView;
                          [hud hide:YES afterDelay:1.0];
                      } else {
                          hud.mode = MBProgressHUDModeCustomView;
                          hud.labelText = @"网络错误，请重新操作";
                          hud.customView = MBProgressHUDErrorView;
                          [hud hide:YES afterDelay:1.0];
                      }
                  }];
                 
             };
         }];
}

#pragma mark - 保存图片至沙盒
- (void)saveImage:(UIImage *)currentImage
         withName:(NSString *)imageName
       completion:(void (^)(void))completion {
    UIImage *squareImage =
    [UIImage scaleFromImage:currentImage toSize:CGSizeMake(100, 100)];
    NSData *imageData = UIImagePNGRepresentation(squareImage);
    // 获取沙盒目录
    _fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]
                 stringByAppendingPathComponent:imageName];
    // 将图片写入文件
    [imageData writeToFile:_fullPath atomically:NO];
    NSURL *iconImageFilePath = [NSURL fileURLWithPath:_fullPath];
    
    UIImage *clipedImg =
    [UIImage clipImageWithData:imageData
                   borderWidth:0
                   borderColor:XBMakeColorWithRGB(234, 103, 7, 1)];
    
    self.profileHeaderView.headPictureView.image = clipedImg;
    self.iconImageFilePath = iconImageFilePath;
    completion();
}

@end
