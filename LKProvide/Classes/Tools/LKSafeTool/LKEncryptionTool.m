//
//  LKEncryptionTool.m
//  LiemsMobile70
//
//  Created by WZheng on 2019/10/14.
//  Copyright © 2019 Luculent. All rights reserved.
//

#import "LKEncryptionTool.h"


#define LKEnSafeString(A) A?A:@""

@implementation LKEncryptionTool

+ (NSString *)getOffLineHmacSecretWithSalt:(NSString *)salt password:(NSString *)pwd{
    NSString *secretToken = [self getOffLineHmacSecretWithSalt:salt password:pwd rounds:1000];
    return secretToken;
}

+ (NSString *)getOffLineHmacSecretWithSalt:(NSString *)salt password:(NSString *)pwd rounds:(int)round{
    NSString *secretToken = [[[NSString alloc] init] LKSafePBKDF2:salt MDPwd:[pwd LKSafeMD5] Rounds:round];
    return secretToken;
}

+ (NSString *)getOnLineHmacSecretWithLoginHmacSecret:(NSString *)loginHmacSecret key:(NSString *)key{
    
    NSString *aesKey = @"";
    // 取 secret 的 8 - 24
    if([loginHmacSecret LKSafeMD5].length > 24){
        aesKey = [[loginHmacSecret LKSafeMD5] substringWithRange:NSMakeRange(8, 16)];
    }
    
    NSData *HmacSecretData = [[NSData LKSafeDataWithBase64EncodedString:key] aes256_decrypt:aesKey];
    
    NSString *HmacSecret = [[NSString alloc] initWithData:HmacSecretData encoding:NSUTF8StringEncoding];
    
    return HmacSecret;
}


+ (NSString *)getJwtWithUserid:(NSString *)userid
                         orgNo:(NSString *)orgno
                    hmacSecret:(NSString *)hmacSecret
                     sessionId:(NSString *)sessionId{
    
    long jti = [[NSDate date] timeIntervalSince1970] * 1000;
    long iat = jti / 1000;
    long exp = jti + 5 * 60 * 1000;
    if (!sessionId || sessionId.length == 0) {
        sessionId = @(jti).description;
    }
        
    NSDictionary *playload = @{
                               @"sub": LKEnSafeString(userid),
                               @"exp": @(exp).description,
                               @"iat": @(iat).description,
                               @"iss": @"MB00001",
                               @"jti": @(jti + arc4random() % 1000).description, // 在原有基础上再加一个1000内的随机数
                               @"sessionId": sessionId,
                               @"langId": @"",
                               @"orgNo": orgno ? : @"",
                               @"skin": @"",
                               };
    
    NSString *jwt =  [JWT encodePayload:playload withSecret:hmacSecret algorithm:[JWTAlgorithmFactory algorithmByName:@"HS256"]];
    
    return jwt;
    
}


+ (NSString *)aesSimpleKey{
    NSString *sk = @"MUx1MmN1M2xlNG50NSFAIw==";
    NSData *data = [[NSData alloc] initWithBase64EncodedString:sk options:0];
    NSString *revkey = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return revkey;
}

+ (NSString *)aesSimpleEncrypt:(NSString *)userid
                       session:(NSString *)sessionId{
    
    NSString *revkey = [LKEncryptionTool aesSimpleKey];
    NSString *enc = [userid AES128EncryptedWithKey:revkey];
    long long int time = (long long int)(([[NSDate date] timeIntervalSince1970]*1000)) + 5*60*1000;
    NSString *ts = @(time).stringValue;
    
    NSString *session = sessionId ? : @"";
    
    NSString *str = [NSString stringWithFormat:@"%@_%@_%@",ts,enc,session];
    NSString *s = [str AES128EncryptedWithKey:revkey];
    return s;
}

@end
