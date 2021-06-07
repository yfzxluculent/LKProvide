//
//  NSDictionary+Utils.m
//  LiemsMobileEnterprise
//
//  Created by young on 2018/3/13.
//  Copyright © 2018年 Jasper. All rights reserved.
//

#import "NSDictionary+Utils.h"

@implementation NSDictionary (Utils)

- (NSString *)urlQuery {
    NSMutableArray *params = [NSMutableArray arrayWithCapacity:self.allKeys.count];
    for (NSString *key in self.allKeys) {

        NSString *value = [self valueForKey:key];
        [params addObject:[NSString stringWithFormat:@"%@=%@", key, value]];
    }
    
    return [params componentsJoinedByString:@"&"];
}

@end
