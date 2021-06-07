//
//  LKSignaTureView.m
//  LKSignatureDome
//
//  Created by 张军 on 2021/4/28.
//

#import "LKSignaTureView.h"
#import "Masonry.h"


@interface LKSignaTureView ()
@property (nonatomic,strong)NSMutableArray <CAShapeLayer*>*pathArr;

@property (nonatomic,strong)CAShapeLayer *shapeLayer;


@end

@implementation LKSignaTureView{

    CGMutablePathRef _path;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        self.imageScale = 1.0;
  
     
    }
    return self;
}

-(NSMutableArray<CAShapeLayer *> *)pathArr{
    if (!_pathArr) {
        _pathArr = [[NSMutableArray alloc]init];
    }
    return _pathArr;
}

//-(void)layoutSubviews{
//    [super layoutSubviews];
//
//}



- (void)drawRect:(CGRect)rect {

}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    CGPoint p = [[touches anyObject]locationInView:self];
    _path = CGPathCreateMutable();
    CGPathMoveToPoint(_path, NULL,p.x, p.y);
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.strokeColor = self.panColor.CGColor;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.lineWidth = 3;
    layer.path = _path;
    [self.layer addSublayer:layer];
    self.shapeLayer = layer;
   [self.pathArr addObject:layer];
    
   
    
    
}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGPoint point = [[touches anyObject]locationInView:self];
    CGPathAddLineToPoint(_path, NULL, point.x, point.y);
    self.shapeLayer.path = _path;
    
    
}
-(void)clear{
    
   NSInteger count  =self.pathArr.count;
    for (int i = 0; i<count; i++) {
        [self.pathArr.lastObject removeFromSuperlayer];
        [self.pathArr removeLastObject];
    }

}
-(void)revoke{
    [self.pathArr.lastObject removeFromSuperlayer];
    [self.pathArr removeLastObject];

}


#pragma mark 保存成图片
- (UIImage *)saveDraw
{
    self.signImage = [self captureWithView:self];
    if (!_imageScale) {
        return [UIImage new];
    }
    // 这里控制范围，范围可以自己定
    if (_imageScale < 0.1) {
        _imageScale = 0.1;
    }
    if (_imageScale > 1) {
        _imageScale = 1;
    }
    return [self scaleImage];

    
}

#pragma mark 缩放图片
- (UIImage *)scaleImage
{
    // 判断机型
    if([[UIScreen mainScreen] scale] == 2.0){      // @2x
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(_signImage.size.width * _imageScale, _signImage.size.height * _imageScale), NO, 2.0);
    }else if([[UIScreen mainScreen] scale] == 3.0){ // @3x ( iPhone 6plus 、iPhone 6s plus)
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(_signImage.size.width * _imageScale, _signImage.size.height * _imageScale), NO, 3.0);
    }else{
        UIGraphicsBeginImageContext(CGSizeMake(_signImage.size.width * _imageScale, _signImage.size.height * _imageScale));
    }
    // 绘制改变大小的图片
    [_signImage drawInRect:CGRectMake(0, 0, _signImage.size.width * _imageScale, _signImage.size.height * _imageScale)];
    // 从当前context中创建一个改变大小后的图片
    _signImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return self.signImage;
}

#pragma mark 截屏
- (UIImage *)captureWithView:(UIView *)view
{
    CGRect screenRect = [view bounds];
    UIGraphicsBeginImageContext(screenRect.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:ctx];
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}




@end
