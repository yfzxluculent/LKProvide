//
//  LKDate.m
//  LiemsMobile7
//
//  Created by luculent on 17/2/22.
//  Copyright © 2017年 朗坤智慧. All rights reserved.
//

#import "LKDate.h"


static NSCalendar *implicitCalendar = nil;
static const unsigned int allCalendarUnitFlags = NSCalendarUnitYear | NSCalendarUnitQuarter | NSCalendarUnitMonth | NSCalendarUnitWeekOfYear | NSCalendarUnitWeekOfMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitEra | NSCalendarUnitWeekday | NSCalendarUnitWeekdayOrdinal | NSCalendarUnitWeekOfYear;

@interface LKDate ()
@property (nonatomic, strong) NSDateComponents *dateComponents;
@end

@implementation LKDate
+ (void)load {
    // 默认是欧洲日历
    implicitCalendar =  [[NSCalendar alloc] initWithCalendarIdentifier: NSCalendarIdentifierGregorian];
    [implicitCalendar setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
}

// 核心的初始化方法
+ (instancetype)initWithDate:(NSDate *)date{
    LKDate *lkDate = [[LKDate alloc]init];
    lkDate.date = date;
    lkDate.style = LKDateStringStyleDefault;
    return lkDate;
}

+ (instancetype)currentDate{
    NSDate *localeDate = [[NSDate date]  dateByAddingTimeInterval:[[NSTimeZone systemTimeZone] secondsFromGMT]];
    return [self initWithDate:localeDate];
}

+ (instancetype)dateWithString:(NSString *)timeStr format:(NSString *)format{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    if (!format || format.length == 0) {
        format = @"yyyy-MM-dd HH:mm:ss";
    }
    if (timeStr.length > 19) {
        timeStr = [timeStr substringToIndex:19];
    }
    // 注意输入字符串的规范
    format = [format substringToIndex:timeStr.length];
    
    [formatter setDateFormat:format];
    NSDate *date = [formatter dateFromString:timeStr];
    if (!date) {
        return nil;
    }
    return [self initWithDate:date];
}

+ (instancetype)dateWithYear:(NSUInteger)year month:(NSUInteger)month day:(NSUInteger)day{
    NSDate *date = [self commonDateWithYear:year month:month day:day hour:0 minute:0 second:0];
    return [self initWithDate:date];
}

+ (instancetype)dateWithYear:(NSUInteger)year month:(NSUInteger)month day:(NSUInteger)day hour:(NSUInteger)hour minute:(NSUInteger)minute second:(NSUInteger)second{
    NSDate *date = [self commonDateWithYear:year month:month day:day hour:hour minute:minute second:second];
    return [self initWithDate:date];
}


+ (NSDate *)commonDateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second {
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    components.day    = day;
    components.year   = year;
    components.month  = month;
    
    components.hour   = hour;
    components.minute = minute;
    components.second = second;
    
    NSDate *nsDate = nil;
    nsDate = [implicitCalendar dateFromComponents:components];
    return nsDate;
}

/* ------ 对象方法 ------ */

- (NSString *)dateString{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    [formatter setDateFormat:self.format];
    return [formatter stringFromDate:self.date];
}

- (void)setStyle:(LKDateStringStyle)style{
    _style = style;
    switch (style) {
        case LKDateStringStyleDefault:
            self.format = @"yyyy-MM-dd HH:mm:ss";
            break;
        case LKDateStringStyleNormal:
            self.format = @"yyyy年MM月dd日 HH时mm分ss秒 eeee";
            break;
        case LKDateStringStyleShort:
            self.format = @"yyyy-MM-dd";
            break;
        default:
            break;
    }
}

- (void)setYear:(NSUInteger)year{
    NSDate *date = [LKDate commonDateWithYear:year month:self.month day:self.day hour:self.hour minute:self.minute second:self.second];
    self.date = date;
}
- (void)setMonth:(NSUInteger)month{
    NSDate *date = [LKDate commonDateWithYear:self.year month:month day:self.day hour:self.hour minute:self.minute second:self.second];
    self.date = date;
}
- (void)setDay:(NSUInteger)day{
    NSDate *date = [LKDate commonDateWithYear:self.year month:self.month day:day hour:self.hour minute:self.minute second:self.second];
    self.date = date;
}
- (void)setHour:(NSUInteger)hour{
    NSDate *date = [LKDate commonDateWithYear:self.year month:self.month day:self.day hour:hour minute:self.minute second:self.second];
    self.date = date;
}
- (void)setMinute:(NSUInteger)minute{
    NSDate *date = [LKDate commonDateWithYear:self.year month:self.month day:self.day hour:self.hour minute:minute second:self.second];
    self.date = date;
}
- (void)setSecond:(NSUInteger)second{
    NSDate *date = [LKDate commonDateWithYear:self.year month:self.month day:self.day hour:self.hour minute:self.minute second:second];
    self.date = date;
}

- (NSUInteger)year{
    return self.dateComponents.year;
}
- (NSUInteger)month{
    return self.dateComponents.month;
}
- (NSUInteger)day{
    return self.dateComponents.day;
}
- (NSUInteger)hour{
    return self.dateComponents.hour;
}
- (NSUInteger)minute{
    return self.dateComponents.minute;
}
- (NSUInteger)second{
    return self.dateComponents.second;
}
- (NSUInteger)weekday{
    NSUInteger index = self.dateComponents.weekday;
    return index - 1;
}
- (NSUInteger)weekOfMonth{
    return self.dateComponents.weekOfMonth;
}
- (NSUInteger)weekOfYear{
    return self.dateComponents.weekOfYear;
}

- (NSUInteger)monthdays{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSRange days = [calendar rangeOfUnit:NSCalendarUnitDay
                                  inUnit:NSCalendarUnitMonth
                                 forDate:self.date];
    return days.length;
}


- (void)setDate:(NSDate *)date{
    _date = date;
    self.dateComponents = [implicitCalendar components:allCalendarUnitFlags fromDate:date];
    self.dateComponents.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
}
- (BOOL)isLeapYear{
    if (self.year % 400 == 0 || (self.year % 100 != 0 && self.year % 4 == 0)) {
        return YES;
    }
    return NO;
}

- (NSTimeInterval)timeIntervalFrom:(LKDate *)lkdate{
    
    return [self.date timeIntervalSinceDate:lkdate.date];
}

- (NSInteger)daysFrom:(LKDate *)lkdate{
    NSDate *earliest = [self.date earlierDate:lkdate.date];
    NSDate *latest = (earliest == self.date) ? lkdate.date : self.date;
    NSInteger multiplier = (earliest == self.date) ? -1 : 1;
    NSDateComponents *components = [implicitCalendar components:NSCalendarUnitDay fromDate:earliest toDate:latest options:0];
    components.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    return multiplier*components.day;
}

- (NSString *)description{
    return self.dateString;
}


- (instancetype)dateCalculateType:(LKDateCalculateType)type number:(NSInteger)number{
    if (number == 0) {
        return [LKDate initWithDate:self.date];
    }
    NSDateComponents *components = [[NSDateComponents alloc] init];
    switch (type) {
        case LKDateCalculateTypeYear:
            [components setYear:number];
            break;
        case LKDateCalculateTypeMonth:
            [components setMonth:number];
            break;
        case LKDateCalculateTypeWeek:
            [components setWeekOfYear:number];
            break;
        case LKDateCalculateTypeDay:
            [components setDay:number];
            break;
        case LKDateCalculateTypeHour:
            [components setHour:number];
            break;
        case LKDateCalculateTypeMinute:
            [components setMinute:number];
            break;
        case LKDateCalculateTypeSecond:
            [components setSecond:number];
            break;
    }
    NSDate *date = [implicitCalendar dateByAddingComponents:components toDate:self.date options:0];
    return [LKDate initWithDate:date];
}


@end
