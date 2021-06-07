//
//  NSString+AES128.m
//  LiemsMobileEnterprise
//
//  Created by 王郑 on 2018/11/9.
//  Copyright © 2018 luculent. All rights reserved.
//

#import "NSString+AES128.h"
@implementation NSString (AES128)

- (NSString *)AES128EncryptedWithKey:(NSString *)key{
    
    NSData *secretData = [[self dataUsingEncoding:NSUTF8StringEncoding] AES128EncryptedDataWithKey:key];
    NSString *result = [secretData base64EncodedStringWithOptions:0];
    return result;
    
}

- (NSString *)AES128DecryptedWithKey:(NSString *)key{
    
    NSData *secretData = [[NSData alloc] initWithBase64EncodedString:self options:0];
    secretData = [secretData AES128DecryptedDataWithKey:key];
    NSString *result = [[NSString alloc] initWithData:secretData encoding:NSUTF8StringEncoding];
    return result;
    
}

@end
