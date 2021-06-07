//
//  LKBBBCheck
//  LiemsMobileEnterprise
//
//  Created by Luculent on 2021/3/19.
//  Copyright © 2021 luculent. All rights reserved.
//

#import "LKBBBCheck.h"
#import <sys/stat.h>
#import <dlfcn.h>
#import <mach-o/dyld.h>
#include <sys/types.h>
#include <sys/sysctl.h>
#import <ifaddrs.h>
#import <arpa/inet.h>
#import <net/if.h>


@implementation LKBBBCheck

+ (void)load{

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(defaultAction:)
                                                 name:UIApplicationDidFinishLaunchingNotification
                                               object:nil];
    
}

+ (void)defaultAction:(NSNotification *)notification{
    
    [self isOK0];
    [self isOK2];
    [self isOK3];
    [self isOK4];
    
}

+ (void)isOK0 {
    NSString *cydiaPath = @"/Applications/Cydia.app";
    NSString *aptPath = @"/private/var/lib/apt/";
    if ([[NSFileManager defaultManager] fileExistsAtPath:cydiaPath]) {
        exit(0);
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:aptPath]) {
        exit(0);
    }
}

+ (void)isOK2 {
    int ret;
    Dl_info dylib_info;
    int (*func_stat)(const char *,struct stat *) = stat;
    if ((ret = dladdr(&func_stat, &dylib_info))) {
        if (strcmp(dylib_info.dli_fname, "/usr/lib/system/libsystem_kernel.dylib")) {
            exit(0);
        }
    }
}

+ (void)isOK3 {
    uint32_t count = _dyld_image_count();
    for (uint32_t i = 0 ; i < count; ++i) {
        NSString *name = [[NSString alloc]initWithUTF8String:_dyld_get_image_name(i)];
        if ([name containsString:@"Library/MobileSubstrate/MobileSubstrate.dylib"]) {
            exit(0);
        }
    }
}

+ (void)isOK4 {
    char *env = getenv("DYLD_INSERT_LIBRARIES");
    if (env != NULL) {
        exit(0);
    }
}


@end
