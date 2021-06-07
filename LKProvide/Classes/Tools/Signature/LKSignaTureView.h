//
//  LKSignaTureView.h
//  LKSignatureDome
//
//  Created by 张军 on 2021/4/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LKSignaTureView : UIView
//按步撤销
-(void)revoke;
//清空
-(void)clear;
//签名线的粗细
@property (nonatomic,assign)CGFloat panWidth;
//签名的颜色
@property (nonatomic,strong)UIColor* panColor;

// 生成图片的缩放比例 默认1不缩放 范围0.1~1.0
@property (nonatomic, assign) CGFloat imageScale;
// 生成的图片
@property (nonatomic, strong) UIImage *signImage;
// 保存成图片
- (UIImage *)saveDraw;


@end

NS_ASSUME_NONNULL_END
