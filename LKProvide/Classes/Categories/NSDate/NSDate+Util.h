//
//  NSDate+Util.h
//  LiemsMobileEnterprise
//
//  Created by hillyoung on 2018/3/19.
//  Copyright © 2018年 luculent. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSDateFormatter *singletonDateFormatter ;

@interface NSDate (LKUtil)


/**
 是否同一月

 @param date <#date description#>
 @return <#return value description#>
 */
- (BOOL)isSameMonthTo:(NSDate *)date ;

/**
 是否同一年
 
 @param date <#date description#>
 @return <#return value description#>
 */
- (BOOL)isSameYeartTo:(NSDate *)date ;

/**
 *  月底最后一天
 */
- (NSDate *)monthEndDateForDate ;

/**
 *  年底最后一天
 */
- (NSDate *)yearEndDateForDate ;

/**
 本地时间
 */
- (NSDate*)locationDate ;

/**
 获取格式化后日期字符串
 @param format 日期格式字符串
 */
- (NSString *)stringFromFormat:(NSString *)format;

@end
