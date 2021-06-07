//
//  UIAlertController+fitIPadIphone.m
//  LiemsMobileEnterprise
//
//  Created by luculent on 16/8/3.
//  Copyright © 2016年 Jasper. All rights reserved.
//

#import "UIAlertController+fitIPadIphone.h"

@implementation UIAlertController (fitIPadIphone)
+ (instancetype)LK_AlertControllerWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(UIAlertControllerStyle)preferredStyle
{
     if([[UIDevice currentDevice].model isEqualToString:@"iPad"]&&preferredStyle == UIAlertControllerStyleActionSheet)
     {
         preferredStyle = UIAlertControllerStyleAlert;
     }
     return [UIAlertController alertControllerWithTitle:title message:message preferredStyle:preferredStyle];
}

@end
