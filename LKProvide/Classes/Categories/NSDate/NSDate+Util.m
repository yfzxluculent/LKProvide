//
//  NSDate+Util.m
//  LiemsMobileEnterprise
//
//  Created by hillyoung on 2018/3/19.
//  Copyright © 2018年 luculent. All rights reserved.
//

#import "NSDate+Util.h"

NSDateFormatter *singletonDateFormatter = nil;

@implementation NSDate (LKUtil)

+ (void)load {
    singletonDateFormatter = [[NSDateFormatter alloc] init];
    singletonDateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
}

- (BOOL)isSameMonthTo:(NSDate *)date {
    if (date == nil) return NO;
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    
    NSCalendarUnit unit = NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth;
    
    NSDateComponents *components = [cal components:unit fromDate:self];
    NSDate *current = [cal dateFromComponents:components];
    
    components = [cal components:unit fromDate:date];
    NSDate *otherDate = [cal dateFromComponents:components];
    if([current isEqualToDate:otherDate])
        return YES;
    
    return NO;
}

- (BOOL)isSameYeartTo:(NSDate *)date {
    if (date == nil) return NO;
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    
    NSCalendarUnit unit = NSCalendarUnitEra | NSCalendarUnitYear ;
    
    NSDateComponents *components = [cal components:unit fromDate:self];
    NSDate *current = [cal dateFromComponents:components];
    
    components = [cal components:unit fromDate:date];
    NSDate *otherDate = [cal dateFromComponents:components];
    if([current isEqualToDate:otherDate])
        return YES;
    
    return NO;
}

/**
 *  获取指定时间的月份最后一天
 */
- (NSDate *)monthEndDateForDate {
    
    NSCalendar * calendar = [NSCalendar currentCalendar];
    NSDateComponents * currentDateComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth fromDate:self];
    NSDate * startOfMonth = [calendar dateFromComponents: currentDateComponents];
    NSDateComponents * months = [[NSDateComponents alloc] init];
    [months setMonth:1];
    [months setDay:-1];
    NSDate *endDate = [calendar dateByAddingComponents: months toDate:startOfMonth options: 0];
    
    return endDate;
}

- (NSDate *)yearEndDateForDate {
    
    NSCalendar * calendar = [NSCalendar currentCalendar];
    NSDateComponents * currentDateComponents = [calendar components:NSCalendarUnitYear fromDate:self];
    NSDate * startOfMonth = [calendar dateFromComponents: currentDateComponents];
    NSDateComponents * months = [[NSDateComponents alloc] init];
    [months setYear:1];
    [months setDay:-1];
    NSDate *endDate = [calendar dateByAddingComponents: months toDate:startOfMonth options: 0];
    
    return endDate;
}

- (NSDate*)locationDate {

    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    
    NSInteger interval = [zone secondsFromGMTForDate: self];
    
    NSDate *localeDate = [self  dateByAddingTimeInterval: interval];
    
    return localeDate;
}

- (NSString *)stringFromFormat:(NSString *)format {
    
    NSString *dateStr = nil;
    NSString *lastFormat = singletonDateFormatter.dateFormat;   //缓存默认日期格式字符串
    singletonDateFormatter.dateFormat = format; //设置日期格式字符串
    dateStr = [singletonDateFormatter stringFromDate:self];
    singletonDateFormatter.dateFormat = lastFormat; //重置日期格式字符串

    return dateStr;
}

@end
