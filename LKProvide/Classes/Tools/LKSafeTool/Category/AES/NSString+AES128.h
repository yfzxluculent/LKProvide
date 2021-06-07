//
//  NSString+AES128.h
//  LiemsMobileEnterprise
//
//  Created by 王郑 on 2018/11/9.
//  Copyright © 2018 luculent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSData+AES128.h"
@interface NSString (AES128)

- (NSString *)AES128EncryptedWithKey:(NSString *)key; /**<加密*/

- (NSString *)AES128DecryptedWithKey:(NSString *)key; /**<解密*/

@end
