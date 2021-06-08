//
//  UIFont+LKScale.m
//  LiemsMobile70
//
//  Created by WZheng on 2021/3/10.
//  Copyright © 2021 Luculent. All rights reserved.
//

#import "UIFont+LKScale.h"
#import <objc/runtime.h>

@implementation UIFont (LKScale)

+(void)load {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //获取替换后的类方法
        Method newMethod = class_getClassMethod([self class], @selector(adjustSystemFont:));
        //获取替换前的类方法
        Method method = class_getClassMethod([self class], @selector(systemFontOfSize:));
        //然后交换类方法
        method_exchangeImplementations(newMethod, method);
    });
}

+(UIFont *)adjustSystemFont:(CGFloat)fontSize{
    CGFloat sacle_FontSize = [[LKScaleLevel sharedInstance] lk_getActualValue:fontSize];
    UIFont *newFont = [UIFont adjustSystemFont:sacle_FontSize];
    return newFont;
}

@end
