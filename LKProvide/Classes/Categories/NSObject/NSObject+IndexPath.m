//
//  NSObject+IndexPath.m
//  LiemsMobileEnterprise
//
//  Created by net on 16/9/14.
//  Copyright © 2016年 Jasper. All rights reserved.
//

#import "NSObject+IndexPath.h"
#import <objc/runtime.h>

@implementation NSObject (IndexPath)

static char parmButtonIndexPath;

-(void)setHt_indexPath:(NSIndexPath *)ht_indexPath{
    
    [self willChangeValueForKey:@"ht_indexPath"];
    objc_setAssociatedObject(self, &parmButtonIndexPath, ht_indexPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"ht_indexPath"];
}

- (NSIndexPath *)ht_indexPath{    
    id object = objc_getAssociatedObject(self,&parmButtonIndexPath);
    return object;
}

@end
