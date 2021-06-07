//
//  UIAlertController+fitIPadIphone.h
//  LiemsMobileEnterprise
//
//  Created by luculent on 16/8/3.
//  Copyright © 2016年 Jasper. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface UIAlertController (fitIPadIphone)
+ (instancetype)LK_AlertControllerWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(UIAlertControllerStyle)preferredStyle;
@end
