//
//  NSString+LKSafe.m
//  LiemsMobile70
//
//  Created by WZheng on 2019/11/18.
//  Copyright © 2019 Luculent. All rights reserved.
//

#import "NSString+LKSafe.h"
#import <CommonCrypto/CommonDigest.h> // MD5加密
#import <CommonCrypto/CommonKeyDerivation.h>


@implementation NSString (LKSafe)

- (NSString*)LKSafeMD5 {
    const char *ptr = [self UTF8String];
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(ptr, (CC_LONG)strlen(ptr), md5Buffer);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x",md5Buffer[i]];
    
    return output;
}

- (NSString*)LKSafePBKDF2:(NSString *)salt
                    MDPwd:(NSString *)pwd
                   Rounds:(int)round{
    
    NSData* myPassData = [pwd dataUsingEncoding:NSUTF8StringEncoding];
    NSData* saltData = [salt dataUsingEncoding:NSUTF8StringEncoding];
    // How many rounds to use so that it takes 0.1s ?
    int rounds = round;
    // CCCalibratePBKDF(kCCPBKDF2, myPassData.length, saltData.length, kCCPRFHmacAlgSHA256, 256, 1000);
    // Open CommonKeyDerivation.h for help
    unsigned char key[32];
    CCKeyDerivationPBKDF(kCCPBKDF2, myPassData.bytes, myPassData.length, saltData.bytes, salt.length, kCCPRFHmacAlgSHA1, rounds, key, 32);
    
    NSString *hexStr = [self hexStringFromString:key size:32];
    
    return hexStr;
}

- (NSString*)LKSafePBKDF2:(NSString *)salt
              MDPwd:(NSString *)pwd{
    return [self LKSafePBKDF2:salt MDPwd:pwd Rounds:1000];
}

//普通字符串转换为十六进制的。
- (NSString *)hexStringFromString:(unsigned char *)string
                             size:(int)size{
    NSString *hexStr=@"";
    for(int i=0;i<size;i++){
        
        NSString *newHexStr = [NSString stringWithFormat:@"%x",string[i]&0xff];///16进制数
        if([newHexStr length]==1)
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        else
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    }
    return hexStr;
}



@end
