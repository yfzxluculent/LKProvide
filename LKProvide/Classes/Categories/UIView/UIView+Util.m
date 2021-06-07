//
//  UIView+Util.m
//  LiemsMobileEnterprise
//
//  Created by hillyoung on 2018/3/19.
//  Copyright © 2018年 luculent. All rights reserved.
//

#import "UIView+Util.h"

@implementation UIView (Util)

- (CGFloat)lk_top{
    return self.frame.origin.y;
}
- (CGFloat)lk_bottom{
    return self.frame.origin.y + self.frame.size.height;
}
- (CGFloat)lk_left{
    return self.frame.origin.x;
}
- (CGFloat)lk_right{
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setLk_x:(CGFloat)lk_x{
    CGRect temp = self.frame;
    temp.origin.x = lk_x;
    self.frame = temp;
}

- (CGFloat)lk_x{
    return self.frame.origin.x;
}

- (void)setLk_y:(CGFloat)lk_y{
    CGRect temp = self.frame;
    temp.origin.y = lk_y;
    self.frame = temp;
}

- (CGFloat)lk_y{
    return self.frame.origin.y;
}

- (void)setLk_width:(CGFloat)lk_width{
    CGRect temp = self.frame;
    temp.size.width = lk_width;
    self.frame = temp;
}

- (CGFloat)lk_width{
    return self.frame.size.width;
}

- (void)setLk_height:(CGFloat)lk_height{
    CGRect temp = self.frame;
    temp.size.height = lk_height;
    self.frame = temp;
}

- (CGFloat)lk_height{
    return self.frame.size.height;
}

- (void)setLk_size:(CGSize)lk_size{
    CGFloat x = self.frame.origin.x;
    CGFloat y = self.frame.origin.y;
    self.frame = CGRectMake(x, y, lk_size.width, lk_size.height);
}

- (CGSize)lk_size{
    return self.frame.size;
}


- (CGFloat)lk_centerX {
    return self.frame.origin.x + self.frame.size.width * 0.5;
}

- (void)setLk_centerX:(CGFloat)lk_centerX {
    CGRect frame = self.frame;
    frame.origin.x = lk_centerX - frame.size.width * 0.5;
    self.frame = frame;
}

- (CGFloat)lk_centerY {
    return self.frame.origin.y + self.frame.size.height * 0.5;
}

- (void)setLk_centerY:(CGFloat)lk_centerY {
    CGRect frame = self.frame;
    frame.origin.y = lk_centerY - frame.size.height * 0.5;
    self.frame = frame;
}


@end


#define ANGLE_TO_RADIAN(angle) ((angle)/180.0  *M_PI)

@interface UIView () <CAAnimationDelegate>

@end

@implementation UIView (EffectAnimation)
EffectAnimationBlock _finishBlock;

- (void)drawRect:(CGRect)rect {
    
}

- (void)animationTransition:(UIViewAnimationTransition)transition {
    //获取当前画图的设备上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //开始准备动画
    [UIView beginAnimations:nil context:context];
    //设置动画曲线，翻译不准，见苹果官方文档
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    //设置动画持续时间
    [UIView setAnimationDuration:.3];
    
    //设置动画效果
    [UIView setAnimationTransition:transition forView:self cache:YES];  //从上向下
    
    //设置动画委托
    [UIView setAnimationDelegate:self];
    //当动画执行结束，执行animationFinished方法
    //    [UIView setAnimationDidStopSelector:@selector(animationFinished:)];
    //提交动画
    [UIView commitAnimations];
}

- (void)addReflectionOpacity:(CGFloat)opacity percent:(CGFloat)percent distance:(CGFloat)distance {
    
    [self.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    
    CALayer *reflectionLayer = [CALayer layer];
    reflectionLayer.contents = [self layer].contents;
    reflectionLayer.opacity = opacity;
    reflectionLayer.frame = CGRectMake(0.0f, 0.f, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)*percent);
    
    //倒影层框架设置，其中高度是原视图的百分比
    CATransform3D stransform = CATransform3DMakeScale(1.0f,-1.0f,1.0f);
    CATransform3D transform = CATransform3DTranslate(stransform,0.0f,-(distance + CGRectGetHeight(self.frame)),0.0f);
    reflectionLayer.transform = transform;
    reflectionLayer.sublayerTransform = reflectionLayer.transform;
    [[self layer] addSublayer:reflectionLayer];
}

- (void)shadowShadowColor:(UIColor*)color andSize:(CGSize)size andOpacity:(CGFloat)opacity {
    
    // 阴影
    self.layer.shadowColor=color.CGColor;
    self.layer.shadowOffset=size;
    self.layer.shadowOpacity=opacity;//默人是透明的
}

#pragma mark - shake

- (void)shakeAngel:(CGFloat)angel andDuration:(NSTimeInterval)time andRepeatCount:(NSInteger)repeatCount andSave:(BOOL)save {
    //    1.创建
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
    
    //    设置
    anim.duration = time;
    
    anim.repeatCount = repeatCount;
    
    anim.values = @[@(ANGLE_TO_RADIAN(-angel)), @(ANGLE_TO_RADIAN(angel)), @(ANGLE_TO_RADIAN(-angel))];
    
    if (save) {
        //        保留动画
        anim.removedOnCompletion=NO;
        anim.fillMode=kCAFillModeForwards;
    }
    
    //    2.添加
    [self.layer addAnimation:anim forKey:@"shake"];
}

- (void)shakeDistance:(CGFloat)distance andDuration:(NSTimeInterval)time andRepeateCount:(NSInteger)repeatCount andDirection:(UIViewEffectAnimationShakeDirection)direction {
    [self shakeDistance:distance andDuration:time andRepeateCount:repeatCount andDirection:direction block:nil];
}

- (void)shakeDistance:(CGFloat)distance andDuration:(NSTimeInterval)time andRepeateCount:(NSInteger)repeatCount andDirection:(UIViewEffectAnimationShakeDirection)direction block:(EffectAnimationBlock)block {
    
    _finishBlock = block;
    
    //    1.创建
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation"];
    
    //    设置
    anim.duration = time;
    anim.repeatCount = repeatCount;
    anim.delegate = self;
    //    计算值
    CGFloat Ay=0;
    CGFloat Ax=0;
    
    switch (direction) {
        case UIViewEffectAnimationShakeDirectionX: {
            NSValue *animation1=[NSValue valueWithCGPoint:CGPointMake(Ax-distance, Ay)];
            NSValue *animation2=[NSValue valueWithCGPoint:CGPointMake(Ax, Ay)];
            NSValue *animation3=[NSValue valueWithCGPoint:CGPointMake(Ax+distance, Ay)];
            
            anim.values=@[animation1,animation2, animation3, animation2];
            break;
        }
            
        case UIViewEffectAnimationShakeDirectionY: {
            
            NSValue *animation1 = [NSValue valueWithCGPoint:CGPointMake(Ax,Ay-distance)];
            NSValue *animation2 = [NSValue valueWithCGPoint:CGPointMake(Ax,Ay)];
            NSValue *animation3 = [NSValue valueWithCGPoint:CGPointMake(Ax,Ay+distance)];
            
            anim.values=@[animation1, animation2, animation3, animation2];
            break;
        }
            
        case UIViewEffectAnimationShakeDirectionUpperLeftCorner: {
            
            NSValue *animation1 = [NSValue valueWithCGPoint:CGPointMake(Ax-distance,Ay-distance)];
            NSValue *animation2 = [NSValue valueWithCGPoint:CGPointMake(Ax,Ay)];
            NSValue *animation3 = [NSValue valueWithCGPoint:CGPointMake(Ax+distance,Ay+distance)];
            
            anim.values=@[animation1, animation2, animation3, animation2];
            break;
        }
            
        case UIViewEffectAnimationShakeDirectionUpperRightCorner: {
            NSValue *animation1 = [NSValue valueWithCGPoint:CGPointMake(Ax+distance,Ay-distance)];
            NSValue *animation2 = [NSValue valueWithCGPoint:CGPointMake(Ax,Ay)];
            NSValue *animation3 = [NSValue valueWithCGPoint:CGPointMake(Ax-distance,Ay+distance)];
            
            anim.values=@[animation1, animation2, animation3, animation2];
            break;
        }
            
        default:
            break;
    }
    
    //    2.添加
    [self.layer addAnimation:anim forKey:nil];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (_finishBlock) {
        _finishBlock();
        _finishBlock = nil;
    }
}

- (void)addCornerAngel:(CGFloat)radius {
    [self addBorderAndCorner:radius borderWidth:0 borderColor:[UIColor clearColor]];
}

- (void)addBorderWidth:(CGFloat)borderWidth andBorderColor:(UIColor *)borderColor {
    [self addBorderAndCorner:0 borderWidth:borderWidth borderColor:borderColor];
}

- (void)addBorderAndCorner:(CGFloat)radius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor {
    self.layer.cornerRadius = radius;
    self.layer.masksToBounds = radius;
    self.layer.borderWidth = borderWidth;
    self.layer.borderColor = borderColor.CGColor;
}

@end


@implementation UIView (Circle)

- (void)setCircle:(BOOL)circle {
    objc_setAssociatedObject(self, @"circle", @(circle), OBJC_ASSOCIATION_COPY_NONATOMIC);
    if (!circle) {
        self.layer.masksToBounds = NO;
        self.layer.cornerRadius = 0;
        self.layer.borderWidth = 0;
        self.layer.borderColor = nil;
    } else {
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = self.cornerRadius;
        self.layer.borderWidth = self.borderWidth;
        self.layer.borderColor = self.borderColor.CGColor;
    }
}

- (BOOL)circle {
    BOOL circle = [objc_getAssociatedObject(self, @"circle") boolValue];
    return circle;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    objc_setAssociatedObject(self, @"cornerRadius", @(cornerRadius), OBJC_ASSOCIATION_COPY_NONATOMIC);
    if (self.circle) {
        self.layer.cornerRadius = cornerRadius;
    }
}

- (CGFloat)cornerRadius {
    CGFloat cornerRadius = [objc_getAssociatedObject(self, @"cornerRadius") floatValue];
    return cornerRadius;
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    objc_setAssociatedObject(self, @"borderWidth", @(borderWidth), OBJC_ASSOCIATION_COPY_NONATOMIC);
    if (self.circle) {
        self.layer.borderWidth = borderWidth;
    }
}

- (CGFloat)borderWidth {
    CGFloat borderWidth = [objc_getAssociatedObject(self, @"borderWidth") floatValue];
    return borderWidth;
}

- (void)setBorderColor:(UIColor *)borderColor {
    objc_setAssociatedObject(self, @"borderColor", borderColor, OBJC_ASSOCIATION_COPY_NONATOMIC);
    if (self.circle) {
        self.layer.borderColor = borderColor.CGColor;
    }
}

- (UIColor *)borderColor {
    UIColor *borderColor = objc_getAssociatedObject(self, @"borderColor");
    return borderColor;
}

@end
