//
//  AuthorizationCenter.h
//  YUIOP
//
//  Created by Jasper on 17/5/22.
//  Copyright © 2017年 朗坤智慧. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// 授权中心 用于快速获取和请求各种授权
@interface AuthorizationCenter : NSObject

+ (instancetype)sharedCenter;
@property (nonatomic, strong) UIViewController *controller;/**<如果需要弹窗*/

@property (nonatomic, strong) NSMutableDictionary *cofigDic;

/**
 获取网络权限
 */
- (void)getAUZNetwork:(void(^)(NSInteger))block;

/**
 获取相册的权限
 
 @param block 授权后的权限
 */
- (void)getAUZPhotos:(void(^)(NSInteger))block;

/**
 相机权限
 
 @param block 授权回调
 */
- (void)getAUZVideo:(void(^)(NSInteger))block;


/**
 麦克风权限
 
 @param block 获取权限后的回调
 */
- (void)getAUZAudio:(void(^)(NSInteger))block;


/**
 定位的权限
 
 @param block 获取权限后的回调
 @param usage 是否是长期使用  (NO 表示在使用期间可以定位)
 */
- (void)getAUZLocation:(void(^)(NSInteger))block isAlwaysUsed:(BOOL)usage;


/**
 通知的权限
 
 @param block 获取权限后的回调
 */
- (void)getAUZNotification:(void(^)(NSInteger))block;

/**
 通讯录的权限
 
 @param block 获取权限之后的回调
 */
- (void)getAUZAddressBook:(void(^)(NSInteger))block;


/**
 获取网络的相关信息
 */
- (void)getNetworkInfo;

@end
