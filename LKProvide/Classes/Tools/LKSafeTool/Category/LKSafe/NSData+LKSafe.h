//
//  NSData+LKSafe.h
//  LiemsMobile70
//
//  Created by WZheng on 2019/11/18.
//  Copyright © 2019 Luculent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import "zlib.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSData (LKSafe)

+ (NSData *)LKSafeDataWithBase64EncodedString:(NSString *)base64EncodedString; // Base64加密
- (NSData *)gzipPack; // gzip压缩
- (NSData *)gzipUnpack; // gzip解压

@end
NS_ASSUME_NONNULL_END
