//
//  LKAlertController.m
//  LKAlertController-Demo
//
//  Created by Luculent on 2021/5/10.
//  Copyright © 2021 Luculent. All rights reserved.
//

#import "LKAlertController.h"


@implementation LKAlertController

+ (void)showAlertSingleChooseWithTitle:(NSString *)title
                               message:(NSString *)message
                          referenceArr:(NSArray<LKAlertModel *> *)arr
                                sender:(UIViewController *)sender
                            completion:(void (^)(LKAlertModel *model,NSString *label,NSString *value))block{
    
    UIAlertController *alert;
    if([[UIDevice currentDevice].model isEqualToString:@"iPad"]){
        alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    }else{
        alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
    }
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action1];
    
    for(LKAlertModel *keyValue in arr){
        UIAlertAction *action = [UIAlertAction actionWithTitle:keyValue.label style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
            !block ? : block(keyValue,keyValue.label,keyValue.value);
        }];
        [alert addAction:action];
    }
    [sender presentViewController:alert animated:YES completion:nil];
}


+ (void)showAlertMutiChooseWithTitle:(NSString *)title
                        referenceArr:(NSArray<LKAlertModel *> *)arr
                         selectedArr:(NSArray<LKAlertModel *> *)sarr
                          completion:(void (^)(NSArray<LKAlertModel *> *selectedArr,NSArray *labelsArr,NSArray *valuesArr))block{
    
    
    LKAlertMultiChooseView *view = [[LKAlertMultiChooseView alloc] initWithTitle:title referenceArr:arr selectedArr:sarr];
    
    view.LKSubmitBlock = ^(NSArray<LKAlertModel *> *selectedArr, NSArray *labelsArr, NSArray *valuesArr) {
        !block ? : block(selectedArr,labelsArr,valuesArr);
    };
    [view show];    
}

@end
