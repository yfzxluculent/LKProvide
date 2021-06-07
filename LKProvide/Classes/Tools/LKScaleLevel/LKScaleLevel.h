//
//  LKScaleLevel.h
//  LiemsMobile70
//
//  Created by WZheng on 2019/5/17.
//  Copyright © 2019 Luculent. All rights reserved.
//

/*
 
 大小级别:  1 到 6 , 2 为默认标准
 比例系数 (0.925 ~ 1.30)
 
 
 */

#import <Foundation/Foundation.h>


FOUNDATION_EXTERN NSString *const LK_SCALE_SET;

#define LKScaleLevelNotify @"LKScaleLevelNotify"




@interface LKScaleLevel : NSObject

@property (nonatomic,strong) NSMutableDictionary *attributedStringCache;

+ (instancetype)sharedInstance;

@property (nonatomic, copy) NSString *currentUser;

/**
 设置 大小级别 :

 @param level 级别:  1 到 6 , 2 为默认标准
 @param complet 保存成功后的回调
 */
- (void)lk_setScaleLevel:(NSInteger )level completion:(dispatch_block_t)complet;

/**
 读取 当前 大小级别 :
 
 @return level 级别:  1 到 6 , 2 为默认标准
 */
- (NSInteger)lk_getScaleLevel;


/**
 读取 对应大小级别的 比例系数
 
 @return (0.925~1.30)
 */
- (CGFloat)lk_getScaleCoefficient;

- (CGFloat)lk_getScaleCoefficientWithLevel:(NSInteger)level;

/**
 读取 实际值
 
 @param original 初值
 @return 返回 初值 * 比例系数
 */
- (CGFloat)lk_getActualValue:(CGFloat)original;


- (void)lk_postNotification:(NSNotificationName)aName
                     object:(nullable id)anObject
                   userInfo:(nullable NSDictionary *)aUserInfo;

@end


