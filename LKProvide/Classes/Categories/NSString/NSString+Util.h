//
//  NSString+Util.h
//  LiemsMobileEnterprise
//
//  Created by hillyoung on 2018/3/19.
//  Copyright © 2018年 luculent. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSDateFormatter *singletonDateFormatter ;

@interface NSString (LKUtil)

/**
 MD5加密
 */
- (NSString*)md5OfString ;

/**
 PBKDF2 加密
 
 @param salt 后台返回的 盐
 @param pwd 加密密码
 @return 秘钥 secret
 */
- (NSString*)PBKDF2:(NSString *)salt
              MDPwd:(NSString *)pwd;

/**
 是否是整型
 */
- (BOOL)lk_isPureInt ;

/**
 是否是浮点型
 */
- (BOOL)isPureFloat ;

/**
 根据指定的“日期格式字符串”，生成时间
 @param format 日期格式字符串
 */
- (NSDate *)dateFromFormat:(NSString *)format ;

/**
 截取字符串
 @param length 截取长度
 */
- (NSString *)clipString:(NSUInteger)length ;

- (NSString *)URLEncodedString;

-(NSString *)URLDecodedString ;

@end
