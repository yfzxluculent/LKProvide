//
//  LKSignaTureViewController.h
//  LKSignatureDome
//
//  Created by 张军 on 2021/4/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LKSignaTureViewController : UIViewController
//返回image
@property(copy, nonatomic) void (^saveImage)(UIImage *image);
//签名线的粗细
@property (nonatomic,assign)CGFloat panWidth;
//签名的颜色
@property (nonatomic,strong)UIColor* panColor;

@end

NS_ASSUME_NONNULL_END
