//
//  LKScaleLevel.m
//  LiemsMobile70
//
//  Created by WZheng on 2019/5/17.
//  Copyright © 2019 Luculent. All rights reserved.
//

#import "LKScaleLevel.h"

NSString *const LK_SCALE_SET = @"LKScaleSet";
NSInteger const STANDARDLEVEL = 2; // 标准 大小 级别

@interface LKScaleLevel()

@property(nonatomic, assign) NSInteger currentScaleLevel;

@property (nonatomic, strong) NSMutableDictionary <NSString*,NSNumber*>*cacaheScaleDic;

@end

@implementation LKScaleLevel


- (NSString *)documentPath{
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [documentPath stringByAppendingPathComponent:@"/LKScaleLevel"];
    return filePath;
}

- (NSMutableDictionary *)cacaheScaleDic{
    if (!_cacaheScaleDic) {
        NSString *filePath = [self documentPath];
        _cacaheScaleDic = [NSMutableDictionary dictionaryWithContentsOfFile:filePath] ? : @{}.mutableCopy;
        [_cacaheScaleDic setObject:@(STANDARDLEVEL) forKey:@"default"];
    }
    return _cacaheScaleDic;
}

- (void)saveAction{
    NSString *filePath = [self documentPath];
    BOOL result = [self.cacaheScaleDic writeToFile:filePath atomically:YES];
#ifdef DEBUG
    NSLog(@"BOOL--b-->%@",result?@"YES":@"NO");
#endif
    
}



+ (instancetype)sharedInstance{
    
    static LKScaleLevel *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[LKScaleLevel alloc] init];
        manager.currentUser = @"default";
        manager.currentScaleLevel = STANDARDLEVEL;
    });
    return manager;
}

- (void)setCurrentUser:(NSString *)currentUser{
    
    if (!currentUser.length) {
        _currentUser = @"default";
    }
    _currentUser = currentUser;
    self.currentScaleLevel = [([self.cacaheScaleDic objectForKey:currentUser] ? : @(2)) integerValue];
}

- (void)lk_setScaleLevel:(NSInteger )level completion:(dispatch_block_t)complet{
    self.currentScaleLevel = level;
    [self.cacaheScaleDic setObject:@(self.currentScaleLevel) forKey:self.currentUser];
    [self saveAction];
    !complet ? : complet();
}

/**
 读取 大小级别 :
 
 @return level 级别:  1 到 6 , 2 为默认标准
 */
- (NSInteger)lk_getScaleLevel{
    return self.currentScaleLevel;
}

/**
 读取 对应大小级别的 比例系数
 
 @return (0.925~1.30)
 */
- (CGFloat)lk_getScaleCoefficient{

    return [self lk_getScaleCoefficientWithLevel:self.currentScaleLevel];
}

- (CGFloat)lk_getScaleCoefficientWithLevel:(NSInteger)level{
    return 0.075 * (level - 2 ) + 1;
}

- (CGFloat)lk_getActualValue:(CGFloat)original{
    return original * [self lk_getScaleCoefficient];
}

- (void)resetFactory{
    return;
    
    self.currentScaleLevel = STANDARDLEVEL;
    [self.cacaheScaleDic setObject:@(self.currentScaleLevel) forKey:self.currentUser];
    [self saveAction];
    [self postNotification:@{}];
    
}

- (void)lk_postNotification:(NSNotificationName)aName
                     object:(nullable id)anObject
                   userInfo:(nullable NSDictionary *)aUserInfo{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:aName object:anObject userInfo:aUserInfo];
}


- (void)postNotification:(NSDictionary *)userInfo{
    [[NSNotificationCenter defaultCenter] postNotificationName:LKScaleLevelNotify object:self userInfo:@{}];
}
@end
