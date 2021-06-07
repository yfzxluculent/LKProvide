//
//  UIImage+Util.h
//  LiemsMobileEnterprise
//
//  Created by hillyoung on 2018/3/19.
//  Copyright © 2018年 luculent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Util)

/**
 根据高度比例重新绘制图片

 @param flex_height 固定高度
 @return 新图
 */
- (UIImage *)resizeImageWithFlexHeight:(CGFloat)flex_height;


- (UIImage *)resizeImageByScalingProportionallyToSize:(CGSize)targetSize;

/**
 *  imageOrientation调整至UIImageOrientationUp，
 *  从而避免在其他平台上打开时，需要旋转才能正常显示
 */
- (UIImage *)normalImage;

/**
 *  截取指定图片的区域，生成指定缩放比率的图片
 */
- (UIImage *)imageForCropRect:(CGRect)cropRect scale:(CGFloat)scale;

/**
 *  任意形状裁剪一个比较典型的例子就是photo中通过磁性套索进行抠图
 *  @param pointArr 套索所有的点
 */
- (UIImage*)imageForCropPaths:(NSArray *)paths ;

/**
 指定rgb值，生成图片
 @param red 红色
 @param green 绿色
 @param blue 蓝色
 @return 生成的图片
 */
+ (UIImage *)colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue;

/**
 指定color，生成图片
 @param tintColor 颜色
 @return 生成的图片
 */
- (UIImage *)imageWithColor:(UIColor *)tintColor;

/**
 获取指定大小、圆角的图片
 @param size 大小
 @param radius 圆角弧度
 @return 生成的图片
 */
- (UIImage *)roundImageSize:(CGSize)size radius: (float) radius;

/**
 根据旋转角度，生成图片
 @param degrees 旋转角度
 */
- (UIImage*)imageRotatedByDegrees:(CGFloat)degrees ;



/**
 压缩图片 UIImageJPEGRepresentation

 @param quality 压缩比例
 @return 图片
 */
- (UIImage*)compressImageWithQuality:(CGFloat)quality;

/**
 生成水印图片 (红色右下角)

 @param text 水印文字,为空默认当前时间戳
 @return 图片
 */
- (UIImage *)imageWithWaterText:(NSString *)text;

@end
