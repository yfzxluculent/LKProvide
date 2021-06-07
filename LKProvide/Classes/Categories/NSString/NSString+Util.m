//
//  NSString+Util.m
//  LiemsMobileEnterprise
//
//  Created by hillyoung on 2018/3/19.
//  Copyright © 2018年 luculent. All rights reserved.
//

#import "NSString+Util.h"
#import <CommonCrypto/CommonDigest.h> // MD5加密
#import <CommonCrypto/CommonKeyDerivation.h>

@implementation NSString (LKUtil)

- (NSString*)md5OfString {
    const char *ptr = [self UTF8String];
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(ptr, (CC_LONG)strlen(ptr), md5Buffer);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x",md5Buffer[i]];
    
    return output;
}

- (NSString*)PBKDF2:(NSString *)salt
              MDPwd:(NSString *)pwd{
    
    NSData* myPassData = [pwd dataUsingEncoding:NSUTF8StringEncoding];
    NSData* saltData = [salt dataUsingEncoding:NSUTF8StringEncoding];
    // How many rounds to use so that it takes 0.1s ?
    int rounds = 1000;
    // CCCalibratePBKDF(kCCPBKDF2, myPassData.length, saltData.length, kCCPRFHmacAlgSHA256, 256, 1000);
    // Open CommonKeyDerivation.h for help
    unsigned char key[32];
    CCKeyDerivationPBKDF(kCCPBKDF2, myPassData.bytes, myPassData.length, saltData.bytes, salt.length, kCCPRFHmacAlgSHA1, rounds, key, 32);
    
    NSString *hexStr = [self hexStringFromString:key size:32];
    
    return hexStr;
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

- (BOOL)lk_isPureInt {
    NSScanner* scan = [NSScanner scannerWithString:self];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

- (BOOL)isPureFloat {
    NSScanner* scan = [NSScanner scannerWithString:self];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}

- (NSDate *)dateFromFormat:(NSString *)format {
    
    NSDate *date = nil;
    NSString *lastFormat = singletonDateFormatter.dateFormat;   //缓存默认日期格式字符串
    singletonDateFormatter.dateFormat = format; //设置日期格式字符串
    date = [singletonDateFormatter dateFromString:self];
    singletonDateFormatter.dateFormat = lastFormat; //重置日期格式字符串
    
    return date;
}

- (NSString *)clipString:(NSUInteger)length {
    
    if (self.length > length) {
        return [self substringToIndex:length];
    }
    
    return self;
}

/**
 *  URLEncode
 */
- (NSString *)URLEncodedString
{
    // CharactersToBeEscaped = @":/?&=;+!@#$()~',*";
    // CharactersToLeaveUnescaped = @"[].";

    NSString *unencodedString = self;
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)unencodedString,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));

    return encodedString;
}

/**
 *  URLDecode
 */
-(NSString *)URLDecodedString
{
    //NSString *decodedString = [encodedString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding ];

    NSString *encodedString = self;
    NSString *decodedString  = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                                                                                     (__bridge CFStringRef)encodedString,
                                                                                                                     CFSTR(""),
                                                                                                                     CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    return decodedString;
}

@end
