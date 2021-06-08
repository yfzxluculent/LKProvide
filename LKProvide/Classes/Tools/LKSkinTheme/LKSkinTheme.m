//
//  LKSkinTheme.m
//  LiemsMobile70
//
//  Created by WZheng on 2019/5/17.
//  Copyright © 2019 Luculent. All rights reserved.
//

#import "LKSkinTheme.h"

NSString *const LK_SKINTHEME = @"LK_SKINTHEME";

#define SK_UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define SK_COLOR(R, G, B, A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]

@implementation LKSkinThemeModel
    
    @end


@interface LKSkinTheme ()
    
    @property (nonatomic, copy) NSArray <LKSkinThemeModel*>* themes;
    @property (nonatomic, copy) NSString *currentThemeNo;
    @property (nonatomic, strong) UIColor *currentThemeColor;
    
    @end

@implementation LKSkinTheme
    
+ (instancetype)sharedInstance{
    
    static LKSkinTheme *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[LKSkinTheme alloc] init];
        manager.themes = [manager makeThemeList];
    });
    return manager;
    
}
    
    
- (void)lk_selectThemeAtIndex:(NSInteger)index
                   completion:(dispatch_block_t)complet{
    
    if (index > self.themes.count - 1) {
#if DEBUG
        NSAssert(index < self.themes.count, @"数组越界");
#endif
        return;
    }
    
    NSString *old = [[NSUserDefaults standardUserDefaults] objectForKey:LK_SKINTHEME];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"themeno == %@", old];
    NSArray *filteredArray = [self.themes filteredArrayUsingPredicate:predicate];
    LKSkinThemeModel *oldtheme = [filteredArray firstObject];
    if (oldtheme) {
        oldtheme.selected = NO;
    }
    LKSkinThemeModel *theme = self.themes[index];
    theme.selected = YES;
    [[NSUserDefaults standardUserDefaults]setObject:theme.themeno forKey:LK_SKINTHEME];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    !complet ? : complet();
}
    
- (void)lk_postNotification:(NSNotificationName)aName
                     object:(nullable id)anObject
                   userInfo:(nullable NSDictionary *)aUserInfo{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:aName object:anObject userInfo:aUserInfo];
}
    
- (void)resetFactory{
    return;
    [self lk_selectThemeAtIndex:0 completion:nil];
}
    
    
#pragma mark -
- (NSString *)currentThemeNo{
    
    NSString *themeNo = [[NSUserDefaults standardUserDefaults] objectForKey:LK_SKINTHEME];
    return themeNo;
}
    
- (UIColor *)currentThemeColor{
    
    NSString *themeNo = [self currentThemeNo];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"themeno == %@", themeNo];
    NSArray *filteredArray = [self.themes filteredArrayUsingPredicate:predicate];
    LKSkinThemeModel *theme = [filteredArray firstObject];
    UIColor *currentThemeColor = theme.themeColor;
    return currentThemeColor;
}
    
    
- (UIColor *)navBGColor{
    
    NSString *themeNo = [self currentThemeNo];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"themeno == %@", themeNo];
    NSArray *filteredArray = [self.themes filteredArrayUsingPredicate:predicate];
    LKSkinThemeModel *theme = [filteredArray firstObject];
    UIColor *navBGColor = theme.navBGColor;
    return navBGColor;
}
    
- (UIColor *)navTextColor{
    
    NSString *themeNo = [self currentThemeNo];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"themeno == %@", themeNo];
    NSArray *filteredArray = [self.themes filteredArrayUsingPredicate:predicate];
    LKSkinThemeModel *theme = [filteredArray firstObject];
    UIColor *navTextColor = theme.navTextColor;
    return navTextColor;
}
    
- (UIColor *)navItemColor{
    
    NSString *themeNo = [self currentThemeNo];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"themeno == %@", themeNo];
    NSArray *filteredArray = [self.themes filteredArrayUsingPredicate:predicate];
    LKSkinThemeModel *theme = [filteredArray firstObject];
    UIColor *navItemColor = theme.navItemColor;
    return navItemColor;
}
    
- (BOOL)isSystemTheme{
    NSString *themeNo = [self currentThemeNo];
    return [themeNo isEqualToString:@"00"];
}
    
#pragma mark - data
- (NSArray <LKSkinThemeModel *>*)makeThemeList{
    
    NSString *themeNo = [[NSUserDefaults standardUserDefaults] objectForKey:LK_SKINTHEME];
    LKSkinThemeModel *model = [LKSkinThemeModel new];
    model.themeno = @"00";
    model.title = @"系统默认";
    model.themeColor = SK_UIColorFromRGB(0x4880FF);
    model.navBGColor = SK_UIColorFromRGB(0xFFFFFF);
    model.navTextColor = SK_UIColorFromRGB(0x000000);
    model.navItemColor = SK_UIColorFromRGB(0x4880FF);
    
    model.preview = @"001";
    model.previews = @[@"001",@"002",@"003"];
    model.selected = !themeNo || [themeNo isEqualToString:@"00"];
    if(!themeNo){
        themeNo = @"00";
        [[NSUserDefaults standardUserDefaults]setObject:themeNo forKey:LK_SKINTHEME];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    
    LKSkinThemeModel *model1 = [LKSkinThemeModel new];
    model1.themeno = @"01";
    model1.title = @"活力橙";
    model1.themeColor = SK_COLOR(255, 188, 71, 1);
    model1.navBGColor = SK_COLOR(255, 188, 71, 1);
    model1.navTextColor = SK_UIColorFromRGB(0xFFFFFF);
    model1.navItemColor = SK_UIColorFromRGB(0xFFFFFF);
    model1.preview = @"001";;
    model1.previews = @[@"001",@"002",@"003"];
    model1.selected = [themeNo isEqualToString:@"01"];
    
    
    
    LKSkinThemeModel *model2 = [LKSkinThemeModel new];
    model2.themeno = @"02";
    model2.title = @"森林绿";
    model2.themeColor = SK_COLOR(40, 153, 64, 1);
    model2.navBGColor = SK_COLOR(40, 153, 64, 1);
    model2.navTextColor = SK_UIColorFromRGB(0xFFFFFF);
    model2.navItemColor = SK_UIColorFromRGB(0xFFFFFF);
    model2.preview = @"001";;
    model2.previews = @[@"001",@"002",@"003"];
    model2.selected = [themeNo isEqualToString:@"02"];
    
    LKSkinThemeModel *model3 = [LKSkinThemeModel new];
    model3.themeno = @"03";
    model3.title = @"热烈红";
    model3.themeColor = SK_COLOR(238, 64, 19, 1);
    model3.navBGColor = SK_COLOR(238, 64, 19, 1);
    model3.navTextColor = SK_UIColorFromRGB(0xFFFFFF);
    model3.navItemColor = SK_UIColorFromRGB(0xFFFFFF);
    model3.preview = @"001";
    model3.previews = @[@"001",@"002",@"003"];
    model3.selected = [themeNo isEqualToString:@"03"];
    
    NSArray *lists = [NSArray arrayWithObjects:model,model1,model2,model3, nil];
    return lists;
}
    
    @end
