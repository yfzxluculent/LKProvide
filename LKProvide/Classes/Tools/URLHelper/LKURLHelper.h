//
//  LKURLHelper.h
//  LiemsMobile70
//
//  Created by WZheng on 2019/12/23.
//  Copyright © 2019 Luculent. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LKURLHelper : NSObject

@property (strong, nonatomic, readonly) NSString *scheme;
@property (strong, nonatomic, readonly) NSString *host;
@property (strong, nonatomic, readonly) NSString *path;
@property (strong, nonatomic, readonly) NSDictionary *params;
@property (strong, nonatomic, readonly) NSString *absoluteString;

+ (instancetype)URLWithString:(NSString *)urlString;

@end


