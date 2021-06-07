//
//  LKCodeScanningViewController.h
//  LiemsMobile70
//
//  Created by WZheng on 2021/5/7.
//  Copyright © 2021 Luculent. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LKCodeScanningViewController : UIViewController

/// 是否展示本地相册按钮
@property (nonatomic,assign,getter=isShowAlbum) BOOL showAlbum;
/// 扫码结果
@property (copy, nonatomic) void(^didScanBlock)(NSString *content,LKCodeScanningViewController *sender);
/// 页面 Dismiss
- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
