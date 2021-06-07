//
//  NSData+AES128.h
//  AESDemo
//
//  Created by zyx on 2018/1/24.
//  Copyright © 2018年 zyx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (AES128)
- (NSData *)AES128EncryptedDataWithKey:(NSString *)key;

- (NSData *)AES128DecryptedDataWithKey:(NSString *)key;

- (NSData *)AES128EncryptedDataWithKey:(NSString *)key iv:(NSString *)iv;

- (NSData *)AES128DecryptedDataWithKey:(NSString *)key iv:(NSString *)iv;

@end

