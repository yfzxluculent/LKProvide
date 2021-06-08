//
//  LKSkinTheme.h
//  LiemsMobile70
//
//  Created by WZheng on 2019/5/17.
//  Copyright © 2019 Luculent. All rights reserved.
//

#import <Foundation/Foundation.h>

#define LKSKINTHEMENotify @"LKSKINTHEMENotify"

FOUNDATION_EXTERN NSString *const LK_SKINTHEME;

@interface LKSkinThemeModel : NSObject
    
    @property (nonatomic, copy) NSString *themeno;
    @property (nonatomic, copy) NSString *title;
    
    @property (nonatomic, strong) UIColor *themeColor; /**<主题:浅色主题,深色主题等等*/
    @property (nonatomic, strong) UIColor *navBGColor; /**<导航栏背景颜色*/
    @property (nonatomic, strong) UIColor *navTextColor; /**<导航栏字体颜色*/
    @property (nonatomic, strong) UIColor *navItemColor; /**<导航栏按钮Tint颜色*/
    
    
    @property (nonatomic, copy) NSString *preview; /**<列表预览图*/
    @property (nonatomic, strong) NSArray <NSString *>*previews; /**<全部的预览图*/
    @property (nonatomic, assign, getter=isSelected) BOOL selected;
    
    @end

@interface LKSkinTheme : NSObject
    
    @property (nonatomic, copy, readonly) NSArray <LKSkinThemeModel*>* themes;
    @property (nonatomic, copy, readonly) NSString *currentThemeNo;
    @property (nonatomic, assign) BOOL isSystemTheme; /**<是否为系统默认*/
    @property (nonatomic, strong, readonly) UIColor *currentThemeColor;
    @property (nonatomic, strong, readonly) UIColor *navBGColor; /**<导航栏背景颜色*/
    @property (nonatomic, strong, readonly) UIColor *navTextColor; /**<导航栏字体颜色*/
    @property (nonatomic, strong, readonly) UIColor *navItemColor; /**<导航栏按钮Tint颜色*/
    
    
+ (instancetype)sharedInstance;
    
- (void)lk_selectThemeAtIndex:(NSInteger)index
                   completion:(dispatch_block_t)complet;
    
- (void)lk_postNotification:(NSNotificationName)aName
                     object:(nullable id)anObject
                   userInfo:(nullable NSDictionary *)aUserInfo;
    
    @end

