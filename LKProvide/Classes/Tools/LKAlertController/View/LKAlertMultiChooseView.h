//
//  LKAlertMultiChooseView.h
//  LiemsMobileEnterprise
//
//  Created by zhanghaitao on 2018/4/9.
//  Copyright © 2018年 Jasper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKAlertModel.h"

@interface LKAlertMultiChooseView : UIView

@property (copy, nonatomic) void(^LKSubmitBlock)(NSArray<LKAlertModel *> *selectedArr,NSArray *labelsArr,NSArray *valuesArr);
@property (copy, nonatomic) void(^LKCancelBlock)();


/**
 初始化（LKAlertModel：label和value）

 @param name 字端名称
 @param arr 参照值数组
 @param sarr 选中的数组
 @return id
 */
- (instancetype)initWithTitle:(NSString *)name referenceArr:(NSArray<LKAlertModel *> *)arr selectedArr:(NSArray<LKAlertModel *> *)sarr;

-(void)show;

@end
