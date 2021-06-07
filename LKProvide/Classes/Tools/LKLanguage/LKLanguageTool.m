//
//  LKLanguageTool.m
//  LiemsMobileEnterprise
//
//  Created by wangzheng on 2018/7/31.
//  Copyright © 2018年 luculent. All rights reserved.
//

#import "LKLanguageTool.h"

NSString *const LK_LANGUAGE_SET = @"LKLangeuageSet";

@interface LKLanguageTool()
@property(nonatomic, assign) LKLanguageTyp currentLanguage;
@end

@implementation LKLanguageTool

+ (instancetype)sharedInstance{
    
    static LKLanguageTool *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[LKLanguageTool alloc] init];
        
        // 取出本地存储的
        NSString *language = [[NSUserDefaults standardUserDefaults] objectForKey:LK_LANGUAGE_SET];
        
        if (!language) {
            // 不存在 , 默认取出系统的
            NSString *preferredLanguage = [manager lk_GetPreferredLanguage];
            if ([preferredLanguage rangeOfString:@"zh-Hans"].location != NSNotFound) {
                manager.currentLanguage = LKLanguageTypHans;
            }else {
                manager.currentLanguage = LKLanguageTypEn;
            }
        }else{
            // 存在
            manager.currentLanguage = [language integerValue];
        }
    });
    return manager;
}

/**
 恢复出厂设置
 */
- (void)resetFactory{
    
    return;
    
    LKLanguageTyp language;
    NSString *preferredLanguage = [self lk_GetPreferredLanguage];
    if ([preferredLanguage rangeOfString:@"zh-Hans"].location != NSNotFound) {
        language = LKLanguageTypHans;
    }else {
        language = LKLanguageTypEn;
    }
    self.currentLanguage = language;
    [[NSUserDefaults standardUserDefaults]setObject:@(language).description forKey:LK_LANGUAGE_SET];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:LKLanguageToolNotify object:self userInfo:@{}];
}

#pragma mark ------------------ Language ------------------
- (NSString *)lk_localizedStringForKey:(NSString *)key bundle:(NSString *)bundleName{
    
    // 获取lproj文件夹的名称
    NSString *preferredLanguage = [self lk_getLanguageFolder:self.currentLanguage];
    // 获取自定义bundle
    NSBundle *_languageBundle = [NSBundle bundleWithPath:[[[LKLanguageTool sharedInstance] lk_SpecificBundle:bundleName] pathForResource:preferredLanguage ofType:@"lproj"]];
    return NSLocalizedStringFromTableInBundle(key, nil, _languageBundle, nil);
}

- (NSString *)lk_localizedStringForKey:(NSString *)key moudle:(NSString *)moudleName{
    // 获取lproj文件夹的名称
    NSString *preferredLanguage = [self lk_getLanguageFolder:self.currentLanguage];
    NSString *tbl = [NSString stringWithFormat:@"%@_%@",moudleName,preferredLanguage];
    return NSLocalizedStringFromTable(key, tbl, nil);
}

- (NSString *)lk_localizedStringForKey:(NSString *)key{
    
    // 获取lproj文件夹的名称
    NSString *preferredLanguage = [self lk_getLanguageFolder:self.currentLanguage];
    NSBundle *_languageBundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:preferredLanguage ofType:@"lproj"]];
    return NSLocalizedStringFromTableInBundle(key, nil, _languageBundle, nil);
    // tbl 国际化文件 传 nil , 默认就是 @"Localizable"
}

- (void)lk_setNewLanguage:(LKLanguageTyp)language{
    
    if (language == self.currentLanguage){
        return;
    }
    self.currentLanguage = language;
    [[NSUserDefaults standardUserDefaults]setObject:@(language).description forKey:LK_LANGUAGE_SET];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:LKLanguageToolNotify object:self userInfo:@{}];
}

- (LKLanguageTyp)lk_getCurrentLanguageTyp{
    return self.currentLanguage;
}


#pragma mark - Assit Action
/**
 *得到本机现在用的语言  * 包含: en:英文 zh-Hans:简体中文 zh-Hant:繁体中文 ja:日本 ...
 */
- (NSString*)lk_GetPreferredLanguage{
    // 取出系统当前语种:
    NSString *preferredLang = [NSLocale preferredLanguages].firstObject;
    return preferredLang;
}

- (NSBundle *)lk_SpecificBundle:(NSString *)bundleName {
    NSBundle *bundle = [NSBundle bundleForClass:NSClassFromString(bundleName)];
    NSURL *url = [bundle URLForResource:bundleName withExtension:@"bundle"];
    bundle = [NSBundle bundleWithURL:url];
    return bundle;
}

- (NSString *)lk_getLanguageFolder:(LKLanguageTyp)languageTyp{
    
    NSString *lproj_folder = @"";
    if (self.currentLanguage == LKLanguageTypHans) {
        lproj_folder = @"zh-Hans";
    }else{
        lproj_folder = @"en";
    }
    return lproj_folder;
}
@end
