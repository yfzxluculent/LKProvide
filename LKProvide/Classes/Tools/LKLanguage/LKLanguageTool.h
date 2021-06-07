//
//  LKLanguageTool.h
//  LiemsMobileEnterprise
//
//  Created by wangzheng on 2018/7/31.
//  Copyright © 2018年 luculent. All rights reserved.
//

/**不足:
 1.系统级的提示语 以及 App名称 . 不过一般它只在应用第一次安装后就会进行提示 , 而我们的App多语言设置肯定是在应用内部设置的, 故应该不会存在功能上的冲突
 2.第三方 比如常用的 MJRefersh 它目前只是根据系统的语言来进行 多语言的控制 . App内部多语言设置无法影响到它, 解决方法 : 修改源码.
 3.Storyboard/xib 上的语言 , App内部多语言设置 暂时也无法影响到 , 它是由系统语言控制的. 解决方法 : 通过代码设置
 */
#import <Foundation/Foundation.h>

#define LKStringFromBundle(key, bundleName) \
[[LKLanguageTool sharedInstance] lk_localizedStringForKey:key bundle:bundleName]

#define LKStringFromMoudle(key, moudleName) \
[[LKLanguageTool sharedInstance] lk_localizedStringForKey:key moudle:moudleName]

#define LKString(key) \
[[LKLanguageTool sharedInstance] lk_localizedStringForKey:key]

#define LKLanguageToolNotify @"LKLanguageToolNotify"

FOUNDATION_EXTERN NSString *const LK_LANGUAGE_SET;


// 构造的目的是进行App内部的多语言设置
typedef NS_ENUM(NSInteger, LKLanguageTyp) {
    LKLanguageTypEn = 0,    // 英文
    LKLanguageTypHans,      // 简体中文
};


@interface LKLanguageTool : NSObject

+ (instancetype)sharedInstance;

/**
 App应用内切换语言
 
 @param language 语种
 */
- (void)lk_setNewLanguage:(LKLanguageTyp)language;

/**
 获取当前版本语言:默认系统当前语言
 
 @return LKLanguageTyp
 */
- (LKLanguageTyp)lk_getCurrentLanguageTyp;

/**
 获取 Bundle下国际化
 
 @param key key
 @param bundleName Bundle 名称
 @return value值
 */
- (NSString *)lk_localizedStringForKey:(NSString *)key bundle:(NSString *)bundleName;


/**
 获取 Moudle下国际化
 
 @param key key
 @param moudleName 模块 名称
 @return value值
 */
- (NSString *)lk_localizedStringForKey:(NSString *)key moudle:(NSString *)moudleName;


/**
 获取系统 MainBundle 下 Localizable 中的常用词
 
 @param key key
 @return  value值
 */
- (NSString *)lk_localizedStringForKey:(NSString *)key;

@end
