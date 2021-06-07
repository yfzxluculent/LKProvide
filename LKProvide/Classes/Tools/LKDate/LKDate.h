//
//  LKDate.h
//  LiemsMobile7
//
//  Created by luculent on 17/2/22.
//  Copyright © 2017年 朗坤智慧. All rights reserved.
//

#import <Foundation/Foundation.h>
// 等待拓展
typedef NS_ENUM(NSInteger, LKDateStringStyle){
    LKDateStringStyleDefault = 0,  // 默认的时间格式 2017-02-22 10:11:30
    LKDateStringStyleNormal, // 2017年02月22日 10时11分30秒 星期三
    LKDateStringStyleShort,  // 日期格式 2017-02-22
};

typedef NS_ENUM(NSInteger, LKDateCalculateType){
    // 年月周天
    LKDateCalculateTypeYear = 0,
    LKDateCalculateTypeMonth,
    LKDateCalculateTypeWeek,
    LKDateCalculateTypeDay,
    
    // 时分秒
    LKDateCalculateTypeHour,
    LKDateCalculateTypeMinute,
    LKDateCalculateTypeSecond,
};

@interface LKDate : NSObject
/* ------ 相互兼容的代码 ------ */
/**
 使用指定的时间初始化(注意,内部不会做任何时差的处理)

 @param date 指定的时间
 @return 封装的对象
 */
+ (instancetype)initWithDate:(NSDate *)date;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, assign) LKDateStringStyle style;
@property (nonatomic, copy) NSString *dateString;
@property (nonatomic, copy) NSString *format;/**<设置自定义的时间格式*/

/* --- 创建时间(失败返回nil) --- */
// 当前的时间
+ (instancetype)currentDate;
// 通过字符串自定义时间 (用户需要制定类型,两个不匹配的时候 返回nil)
+ (instancetype)dateWithString:(NSString *)timeStr format:(NSString *)format;
// 自定义时间 (默认是 00:00:00)
+ (instancetype)dateWithYear:(NSUInteger)year month:(NSUInteger)month day:(NSUInteger)day;
// 完整的自定义时间
+ (instancetype)dateWithYear:(NSUInteger)year month:(NSUInteger)month day:(NSUInteger)day hour:(NSUInteger)hour minute:(NSUInteger)minute second:(NSUInteger)second;

/* ------ 常用的属性(可以直接用于比较) ------ */
@property (nonatomic, assign) NSUInteger year;
@property (nonatomic, assign) NSUInteger month;
@property (nonatomic, assign) NSUInteger day;
@property (nonatomic, assign) NSUInteger hour;
@property (nonatomic, assign) NSUInteger minute;
@property (nonatomic, assign) NSUInteger second;
// week相关 (按照西方日历传统 周日是一周的第一天)
@property (nonatomic, assign) NSUInteger weekday;/**<0:星期天,1:星期一,...6:星期六*/
@property (nonatomic, assign) NSUInteger weekOfMonth;
@property (nonatomic, assign) NSUInteger weekOfYear;

@property (nonatomic, assign) NSUInteger monthdays;/**<这个月的天数*/
@property (nonatomic, assign) BOOL isLeapYear;/**<是否是闰年*/

/* ------ 方法 ------ */
// 计算两个日期兼的时间差 (精确到秒,用户自行换算时间)
- (NSTimeInterval)timeIntervalFrom:(LKDate *)lkdate;
// 计算两个日期的天数差 (忽略后面的时分秒 按照日期计算)
- (NSInteger)daysFrom:(LKDate *)lkdate;

//  时间进行操作 number > 0 表示增加 < 0 表示减少 = 0  表示不变
- (instancetype)dateCalculateType:(LKDateCalculateType)type number:(NSInteger)number;

@end
/*
 说明:
 对NSDate的封装,更加便于工程中的使用
 自行封装类目 减少第三方的依赖性 更适合自己使用
 
 功能:
 1. 不用考虑时差 使用便捷
 2. 对原来工程中的NSDate完全兼容 提供和NSDate相互转换的方法(或者属性)
 3. 便捷的属性和方法
 */
