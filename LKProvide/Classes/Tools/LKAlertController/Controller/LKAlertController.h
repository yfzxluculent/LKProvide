//
//  LKAlertController.h
//  LKAlertController-Demo
//
//  Created by Luculent on 2021/5/10.
//  Copyright © 2021 Luculent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LKAlertModel.h"
#import "LKAlertMultiChooseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface LKAlertController : NSObject


/**
 单选
 
 @param title title
 @param message message
 @param arr 数组
 @param sender 当前视图控制器
 @param block 回调
 
 */
+ (void)showAlertSingleChooseWithTitle:(NSString *)title
                               message:(NSString *)message
                          referenceArr:(NSArray<LKAlertModel *> *)arr
                                sender:(UIViewController *)sender
                            completion:(void (^)(LKAlertModel *model,NSString *label,NSString *value))block;


/**
 多选
 
 @param title 标题
 @param arr 数组
 @param sarr 已选中的数组
 @param block 回调
 
 */
+ (void)showAlertMutiChooseWithTitle:(NSString *)title
                          referenceArr:(NSArray<LKAlertModel *> *)arr
                         selectedArr:(NSArray<LKAlertModel *> *)sarr
                            completion:(void (^)(NSArray<LKAlertModel *> *selectedArr,NSArray *labelsArr,NSArray *valuesArr))block;

@end

NS_ASSUME_NONNULL_END
