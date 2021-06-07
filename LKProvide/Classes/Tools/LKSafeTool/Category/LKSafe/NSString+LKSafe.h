//
//  NSString+LKSafe.h
//  LiemsMobile70
//
//  Created by WZheng on 2019/11/18.
//  Copyright © 2019 Luculent. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (LKSafe)

/**
 MD5加密
 */
- (NSString*)LKSafeMD5;

/**
 PBKDF2 加密
 
 @param salt 后台返回的 盐
 @param pwd 加密密码
 @return 秘钥 secret
 */
- (NSString*)LKSafePBKDF2:(NSString *)salt
              MDPwd:(NSString *)pwd;


/**
 PBKDF2 加密

 @param salt 后台返回的 盐
 @param pwd 加密密码
 @param round 迭代次数
 @return 秘钥 secret
 */
- (NSString*)LKSafePBKDF2:(NSString *)salt
                    MDPwd:(NSString *)pwd
                   Rounds:(int)round;



@end


