//
//  LKEncryptionTool.h
//  LiemsMobile70
//
//  Created by WZheng on 2019/10/14.
//  Copyright © 2019 Luculent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+LKSafe.h"
#import "NSString+AES128.h"
#import "NSData+LKSafe.h"
#import "NSData+AES256.h"
#import "JWT.h"

@interface LKEncryptionTool : NSObject


/**
 获取登陆所需的 HmacSecret

 @param salt 盐
 @param pwd 密码
 @return HmacSecret
 */
+ (NSString *)getOffLineHmacSecretWithSalt:(NSString *)salt password:(NSString *)pwd;


/**
 获取 登陆之后,请求所需 HmacSecret

 @param loginHmacSecret 登陆所需的 HmacSecret
 @param key 秘钥
 @return HmacSecret
 */
+ (NSString *)getOnLineHmacSecretWithLoginHmacSecret:(NSString *)loginHmacSecret key:(NSString *)key;


/**
 获取 Jwt

 @param userid 用户id
 @param orgno 用户公司号
 @param hmacSecret HmacSecret
 @param sessionId sessionId
 @return Jwt
 */
+ (NSString *)getJwtWithUserid:(NSString *)userid
                         orgNo:(NSString *)orgno
                    hmacSecret:(NSString *)hmacSecret
                     sessionId:(NSString *)sessionId;



/**
 简单AES加密Key

 @return key
 */
+ (NSString *)aesSimpleKey;

/**
 简单AES加密

 @param userid id
 @param sessionId session_id
 @return aes加密
 */
+ (NSString *)aesSimpleEncrypt:(NSString *)userid
                       session:(NSString *)sessionId;


@end

