//
//  AuthorizationCenter.m
//  YUIOP
//
//  Created by Jasper on 17/5/22.
//  Copyright © 2017年 朗坤智慧. All rights reserved.
//

#import "AuthorizationCenter.h"

@import CallKit;
@import CoreTelephony;
@import Photos;
@import AssetsLibrary;
@import AVFoundation;
@import CoreLocation;
@import AddressBook;
@import Contacts;

#define Au_SafeString(A)  (A)?A:@""

@interface AuthorizationCenter ()<CLLocationManagerDelegate>

@property (nonatomic, strong) CTCellularData *cellularData;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, copy) NSString *bundleName;

@property (nonatomic, copy) void(^block)(NSInteger);
@property (nonatomic, assign) BOOL isAlwaysUsed;
@end

@implementation AuthorizationCenter


static AuthorizationCenter *instance;
+ (instancetype)sharedCenter{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[AuthorizationCenter alloc]init];
        instance.cofigDic = [NSMutableDictionary dictionary];
        // 此处不默认申请任何权限 留待合适的时间自行调用
        [instance getAUZAddressBook:nil];
        [instance getAUZLocation:nil isAlwaysUsed:NO];
        [instance getAUZAudio:nil];
        [instance getAUZVideo:nil];
        [instance getAUZPhotos:nil];
        [instance getAUZNetwork:nil];
        [instance getAUZNotification:nil];
        
        [instance getNetworkInfo];
        NSLog(@"config info: %@",instance.cofigDic);
    });
    return instance;
}
- (NSString *)bundleName{
    if (!_bundleName) {
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        _bundleName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    }
    return _bundleName;
}
- (CTCellularData *)cellularData{
    if (!_cellularData) {
        _cellularData = [[CTCellularData alloc]init];
    }
    return _cellularData;
}

- (CLLocationManager *)locationManager{
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
    }
    return _locationManager;
}



/**
 获取网络权限
 */
- (void)getAUZNetwork:(void(^)(NSInteger))block{
    // CTCellularData  只能检测蜂窝权限，不能检测WiFi权限。
    // iOS10 国行机第一次安装App时会有一个权限弹框弹出，在允许之前是没有网络
    // 现阶段 暂时没有申请联网权限的方法 所以是被动式的监测
    __weak typeof(self) wself = self;;
    self.cellularData.cellularDataRestrictionDidUpdateNotifier = ^(CTCellularDataRestrictedState state)
    {    //获取联网状态
        switch (state){
            case kCTCellularDataRestricted: {
                // 关闭
                [wself.cofigDic setObject:@"关闭" forKey:@"联网权限"];
            }break;
            case kCTCellularDataNotRestricted:{
                // 无线局域网  或者  无线局域网&蜂窝
                [wself.cofigDic setObject:@"开通" forKey:@"联网权限"];
            }break;
            case kCTCellularDataRestrictedStateUnknown:{
                // 程序第一次打开 锁屏
                [wself.cofigDic setObject:@"未知" forKey:@"联网权限"];
            }break;
            default: break;
        };
        if (block) {
            // 权限发生变化的时候 也会进行处理的
            block(state);
        }
    };
    
    // 立即返回一个网络权限
    if (block) {
        if (self.cellularData.restrictedState == kCTCellularDataRestricted) {
            // 关闭 强行请求
            [self alertTitle:@"应用无线数据获取权限暂未开始,是否现在开启?" msg:@"无线数据"];
        }
        block(self.cellularData.restrictedState);
    }
}


/**
 获取相册的权限
 
 @param block 授权后的权限
 */
- (void)getAUZPhotos:(void(^)(NSInteger))block{
    // 使用新版本的框架 来获取权限
    PHAuthorizationStatus currentStatus = [PHPhotoLibrary authorizationStatus];
    switch (currentStatus) {
        case PHAuthorizationStatusNotDetermined:{
            // 用户尚未做出选择这个应用程序的问候
            [self.cofigDic setObject:@"未知" forKey:@"相册权限"];
        }break;
        case PHAuthorizationStatusRestricted:
        case PHAuthorizationStatusDenied:{
            //  Restricted 此应用程序没有被授权访问的照片数据。可能是家长控制权限
            // Denied 用户已经明确否认了权限的访问
            [self.cofigDic setObject:@"关闭" forKey:@"相册权限"];
        }break;
        case PHAuthorizationStatusAuthorized:{
            // 已经被授权
            [self.cofigDic setObject:@"开通" forKey:@"相册权限"];
        }break;
        default:
            break;
    }
    if (currentStatus != PHAuthorizationStatusAuthorized && block) {
        
        if (currentStatus == PHAuthorizationStatusRestricted || currentStatus == PHAuthorizationStatusDenied) {
            [self alertTitle:@"应用暂未获取相册访问权限,是否现在开启?" msg:@"照片"];
        }else{
            __weak typeof(self) wself = self;
            // 非授权状态下 请求授权
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                [wself getAUZPhotos:nil];
            }];
        }
    }else{
        if (block) {
            block(currentStatus);
        }
    }
}


/**
 相机权限
 
 @param block 授权回调
 */
- (void)getAUZVideo:(void(^)(NSInteger))block{
    AVAuthorizationStatus currentStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];//相机权限
    switch (currentStatus) {
        case AVAuthorizationStatusNotDetermined:{
            // 用户尚未做出选择这个应用程序的问候
            [self.cofigDic setObject:@"未知" forKey:@"相机权限"];
        }break;
        case AVAuthorizationStatusRestricted:
        case AVAuthorizationStatusDenied:{
            //  Restricted 此应用程序没有被授权访问的相机数据。可能是家长控制权限
            // Denied 用户已经明确否认了权限的访问
            [self.cofigDic setObject:@"关闭" forKey:@"相机权限"];
        }break;
        case AVAuthorizationStatusAuthorized:{
            // 已经被授权
            [self.cofigDic setObject:@"开通" forKey:@"相机权限"];
        }break;
        default:
            break;
    }
    if (currentStatus != AVAuthorizationStatusAuthorized && block) {
        
        if (currentStatus == AVAuthorizationStatusDenied || currentStatus == AVAuthorizationStatusRestricted) {
            [self alertTitle:@"应用暂未获取相机访问权限,是否现在开启?" msg:@"相机"];
        }else{
            __weak typeof(self) wself = self;
            //相机权限
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted){
                    // 被授权了
                    [wself getAUZVideo:nil];
                }else{
                    block(AVAuthorizationStatusDenied);
                }
            }];
        }
        
    }else{
        if (block) {
            block(currentStatus);
        }
    }
}


/**
 麦克风权限
 
 @param block 获取权限后的回调
 */
- (void)getAUZAudio:(void(^)(NSInteger))block{
    AVAuthorizationStatus currentStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];//麦克风权限
    switch (currentStatus) {
        case AVAuthorizationStatusNotDetermined:{
            // 用户尚未做出选择这个应用程序的问候
            [self.cofigDic setObject:@"未知" forKey:@"麦克风权限"];
        }break;
        case AVAuthorizationStatusRestricted:
        case AVAuthorizationStatusDenied:{
            //  Restricted 此应用程序没有被授权访问的相机数据。可能是家长控制权限
            // Denied 用户已经明确否认了权限的访问
            [self.cofigDic setObject:@"关闭" forKey:@"麦克风权限"];
        }break;
        case AVAuthorizationStatusAuthorized:{
            // 已经被授权
            [self.cofigDic setObject:@"开通" forKey:@"麦克风权限"];
        }break;
        default:
            break;
    }
    if (currentStatus != AVAuthorizationStatusAuthorized && block) {
        if (currentStatus == AVAuthorizationStatusDenied || currentStatus == AVAuthorizationStatusRestricted) {
            [self alertTitle:@"应用暂未获取麦克风访问权限,是否现在开启?" msg:@"麦克风"];
        }else{
            __weak typeof(self) wself = self;;
            //麦克风权限
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
                if (granted){
                    // 被授权了
                    [wself getAUZAudio:nil];
                }else{
                    block(AVAuthorizationStatusDenied);
                }
            }];
        }
        
    }else{
        if (block) {
            block(currentStatus);
        }
    }
}



/**
 定位的权限
 
 @param block 获取权限后的回调
 @param usage 是否是长期使用  (NO 表示在使用期间可以定位)
 */
- (void)getAUZLocation:(void(^)(NSInteger))block isAlwaysUsed:(BOOL)usage{
    // 是否可以定位 如果不可以请求定位权限 可以的话 查看同意的类型
    BOOL isLocation = [CLLocationManager locationServicesEnabled];
    if (!isLocation || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        if (block) {
            self.block = block;
            self.isAlwaysUsed = usage;
            // 开始发出定位请求
            if (usage) {
                // 长期使用
                [self.locationManager requestAlwaysAuthorization];//一直获取定位信息
            }else{
                // 使用期间使用
                [self.locationManager requestWhenInUseAuthorization];//使用的时候获取定位信息
            }
        }
    }else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted){
        [self alertTitle:@"您尚未开启定位服务，现在要去开启吗？" msg:@"位置"];
    }else {
        CLAuthorizationStatus currentStatus = [CLLocationManager authorizationStatus];
        switch (currentStatus) {
            case kCLAuthorizationStatusAuthorizedAlways:{
                // 允许访问位置信息  始终
                [self.cofigDic setObject:@"始终" forKey:@"位置权限"];
            }break;
            case kCLAuthorizationStatusAuthorizedWhenInUse:{
                // 允许访问位置信息  使用应用期间
                [self.cofigDic setObject:@"使用应用期间" forKey:@"位置权限"];
            }break;
            case kCLAuthorizationStatusDenied:
            case kCLAuthorizationStatusRestricted:{
                // 允许访问位置信息  永不
                [self.cofigDic setObject:@"关闭" forKey:@"位置权限"];
            }break;
            case kCLAuthorizationStatusNotDetermined:{
                // 允许访问位置信息  用户尚未作出决定
                [self.cofigDic setObject:@"未知" forKey:@"位置权限"];
            }break;
                
            default:
                break;
        }
        if (block) {
            block(currentStatus);
        }
    }
}


/**
 通知的权限
 
 @param block 获取权限后的回调
 */
- (void)getAUZNotification:(void(^)(NSInteger))block{
    NSUInteger currentType = [[UIApplication sharedApplication]currentUserNotificationSettings].types;
    
    if (currentType == 0 && block) {
        UIUserNotificationSettings *setting = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:setting];
        [self alertTitle:@"应用暂未获取通知权限,是否现在开启" msg:@"通知"];
    }
    if (currentType == 0) {
        [self.cofigDic setObject:@"关闭" forKey:@"通知权限"];
    } else if (currentType == 1){
        [self.cofigDic setObject:@"图标角标" forKey:@"通知权限"];
    } else if (currentType == 2){
        [self.cofigDic setObject:@"声音" forKey:@"通知权限"];
    } else if (currentType == 3){
        [self.cofigDic setObject:@"图标角标,声音" forKey:@"通知权限"];
    } else if (currentType == 4){
        [self.cofigDic setObject:@"横幅" forKey:@"通知权限"];
    } else if (currentType == 5){
        [self.cofigDic setObject:@"图标角标,横幅" forKey:@"通知权限"];
    } else if (currentType == 6){
        [self.cofigDic setObject:@"声音,横幅" forKey:@"通知权限"];
    } else if (currentType == 7){
        [self.cofigDic setObject:@"图标角标,声音,横幅" forKey:@"通知权限"];
    }
    if (block) {
        block(currentType);
    }
}


/**
 通讯录的权限
 
 @param block 获取权限之后的回调
 */
- (void)getAUZAddressBook:(void(^)(NSInteger))block{
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_9_0
    // 高于9.0版本的申请
    CNAuthorizationStatus currentStatus = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    switch (currentStatus) {
        case kABAuthorizationStatusAuthorized:{
            // 允许访问通讯录
            [self.cofigDic setObject:@"开通" forKey:@"通讯录权限"];
        }break;
        case kABAuthorizationStatusDenied:
        case kABAuthorizationStatusRestricted:{
            // 通讯录权限无法使用
            [self.cofigDic setObject:@"关闭" forKey:@"通讯录权限"];
        }break;
        case kABAuthorizationStatusNotDetermined:{
            // 用户尚未决定是否使用通讯录
            [self.cofigDic setObject:@"未知" forKey:@"通讯录权限"];
        }break;
            
        default:
            break;
    }
    if (currentStatus != kABAuthorizationStatusAuthorized && block) {
        
        if (currentStatus == kABAuthorizationStatusDenied || currentStatus == kABAuthorizationStatusRestricted) {
            [self alertTitle:@"应用暂未获取通讯录访问权限,是否现在开启?" msg:@"通讯录"];
        }else{
            __weak typeof(self) wself = self;
            // 非授权状态下 请求授权
            CNContactStore *contactStore = [[CNContactStore alloc] init];
            [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
                if (granted){
                    // 被授权了
                    [wself getAUZAddressBook:nil];
                }else{
                    block(kABAuthorizationStatusDenied);
                }
            }];
        }
    }else{
        if (block) {
            block(currentStatus);
        }
    }
    
#else
    // 低于9.0版本的申请
    CNAuthorizationStatus currentStatus = ABAddressBookGetAuthorizationStatus();
    switch (currentStatus) {
        case kABAuthorizationStatusAuthorized:{
            // 允许访问通讯录
            [self.cofigDic setObject:@"开通" forKey:@"通讯录权限"];
        }break;
        case kABAuthorizationStatusDenied:
        case kABAuthorizationStatusRestricted:{
            // 通讯录权限无法使用
            [self.cofigDic setObject:@"关闭" forKey:@"通讯录权限"];
        }break;
        case kABAuthorizationStatusNotDetermined:{
            // 用户尚未决定是否使用通讯录
            [self.cofigDic setObject:@"未知" forKey:@"通讯录权限"];
        }break;
            
        default:
            break;
    }
    if (currentStatus != kABAuthorizationStatusAuthorized && block) {
        if (currentStatus == kABAuthorizationStatusDenied || currentStatus == kABAuthorizationStatusRestricted) {
            [self alertTitle:@"应用暂未获取通讯录访问权限,是否现在开启?" msg:@"通讯录"];
        }else {
            __weak typeof(self) wself = self;;
            // 非授权状态下 请求授权
            ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
            ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
                if (granted){
                    // 被授权了
                    [wself getAUZAddressBook:nil];
                }else{
                    block(kABAuthorizationStatusDenied);
                }
                CFRelease(addressBook);
            });
        }
        
    }else{
        if (block) {
            block(currentStatus);
        }
    }
#endif
}

/**
 获取网络的相关信息
 */
- (void)getNetworkInfo{
    
    // 移动网络提供商（制式） 有移动联通电信三家 每一家下面又有很多网络模式
    
    // 获取用户网络信息
    CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc]init];
    CTCarrier *carrier = networkInfo.subscriberCellularProvider;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:Au_SafeString(networkInfo.currentRadioAccessTechnology) forKey:@"网络模式"];
    [dic setObject:Au_SafeString(carrier.carrierName) forKey:@"网络制式"];
    [dic setObject:Au_SafeString(carrier.mobileCountryCode) forKey:@"ISO国家代码"];
    [dic setObject:Au_SafeString(carrier.mobileNetworkCode) forKey:@"移动网络代码"];
    [dic setObject:carrier.allowsVOIP?@"YES":@"NO" forKey:@"是否允许网络电话"];
    [self.cofigDic setObject:dic?dic:@{} forKey:@"运行商信息"];
    
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    // 只有成功之后 触发匿名函数
    if ([CLLocationManager locationServicesEnabled] && self.block) {
        [self getAUZLocation:self.block isAlwaysUsed:self.isAlwaysUsed];
    }
}

- (void)alertTitle:(NSString*)title msg:(NSString *)msg{
    if (self.controller) {
        msg = [NSString stringWithFormat:@"或稍后去“设置->%@->%@”中开启",self.bundleName,msg];
        // 弹窗
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"稍后设置" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        }];
        UIAlertAction *set = [UIAlertAction actionWithTitle:@"现在设置" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
            }
        }];
        [cancel setValue:[UIColor grayColor] forKey:@"titleTextColor"];
        
        [alertVC addAction:cancel];
        [alertVC addAction:set];
        [self.controller presentViewController:alertVC animated:NO completion:nil];
    }
}

@end


/*
 
 NSBluetoothPeripheralUsageDescription          访问蓝牙
 NSCalendarsUsageDescription                    访问日历
 NSCameraUsageDescription                       相机
 NSPhotoLibraryUsageDescription                 相册
 NSContactsUsageDescription                     通讯录
 NSLocationAlwaysUsageDescription               始终访问位置
 NSLocationUsageDescription                     位置
 NSLocationWhenInUseUsageDescription            在使用期间访问位置
 NSMicrophoneUsageDescription                   麦克风
 NSAppleMusicUsageDescription                   访问媒体资料库
 NSHealthShareUsageDescription                  访问健康分享
 NSHealthUpdateUsageDescription                 访问健康更新
 NSMotionUsageDescription                       访问运动与健身
 NSRemindersUsageDescription                    访问提醒事项
 
 */

