//
//  LJGesturePwdLockItem.m
//  LJRuntime_Prictise
//
//  Created by Apple on 2016/12/13.
//  Copyright © 2016年 LJ. All rights reserved.
//

#import "LJGesturePwdLockItem.h"
#import "LJGesturePwdLockHeader.h"
#import "CALayer+LJAnimation.h"
#define LJItemInnerLayerPercent 0.35
#define LJItemTriangleLayerPercent 0.1
@interface LJGesturePwdLockItem()

/** item外部轮廓 */
@property (nonatomic, strong) CAShapeLayer *outterLayer;
/** 内部圆 */
@property (nonatomic, strong) CAShapeLayer *innerLayer;
/** 三角 */
@property (nonatomic, strong) CAShapeLayer *triangleLayer;
@end

@implementation LJGesturePwdLockItem

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        [self initItem];
    }
    return self;
}
/** 初始化item */
- (void)initItem {
    UIBezierPath *outPath = [UIBezierPath bezierPathWithOvalInRect:self.bounds];
    _outterLayer = [CAShapeLayer layer];
    _outterLayer.lineWidth = 2.5;
    _outterLayer.path = outPath.CGPath;
    _outterLayer.strokeColor = LJGesturePwdLockItemColorNormal.CGColor;
    _outterLayer.fillColor = [UIColor clearColor].CGColor;
    [self.layer addSublayer:_outterLayer];
    
    UIBezierPath *innerPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(self.bounds.size.width * (1 - LJItemInnerLayerPercent) * 0.5, self.bounds.size.width * (1 - LJItemInnerLayerPercent) * 0.5, self.bounds.size.width * LJItemInnerLayerPercent, self.bounds.size.width * LJItemInnerLayerPercent)];
    _innerLayer = [CAShapeLayer layer];
    _innerLayer.path = innerPath.CGPath;
    _innerLayer.fillColor = LJGesturePwdLockItemColorNormal.CGColor;
    [self.layer addSublayer:_innerLayer];
    
    UIBezierPath *trianglePath = [UIBezierPath bezierPath];
    [trianglePath moveToPoint:CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.1)];
    [trianglePath addLineToPoint:CGPointMake(self.bounds.size.width * 0.4,self.bounds.size.height * 0.5 - self.bounds.size.height * (LJItemInnerLayerPercent * 0.5 ) - 3)];
    [trianglePath addLineToPoint:CGPointMake(self.bounds.size.width * 0.6, self.bounds.size.height * 0.5 - self.bounds.size.height * (LJItemInnerLayerPercent * 0.5) - 3)];
    
    _triangleLayer = [CAShapeLayer layer];
//    _triangleLayer.anchorPoint = CGPointMake(0.5, 0.5);
    _triangleLayer.path = trianglePath.CGPath;
    _triangleLayer.hidden = YES;
    _triangleLayer.fillColor = LJGesturePwdLockItemColorSelected.CGColor;
    [self.layer addSublayer:_triangleLayer];
}
/** 设置状态 */
- (void)setGestureLockType:(LJGesturePwdLockItemType)gestureLockType{
    _gestureLockType = gestureLockType;
    
    switch (gestureLockType) {
        case LJGesturePwdLockItemNormal:
            _innerLayer.fillColor = LJGesturePwdLockItemColorNormal.CGColor;
            _outterLayer.strokeColor = LJGesturePwdLockItemColorNormal.CGColor;
            _triangleLayer.hidden = YES;
            break;
        case LJGesturePwdLockItemSeleected:
            _innerLayer.fillColor = LJGesturePwdLockItemColorSelected.CGColor;
            _outterLayer.strokeColor = LJGesturePwdLockItemColorSelected.CGColor;
            break;
        case LJGesturePwdLockItemWorry:
            _innerLayer.fillColor = LJGesturePwdLockColorWorry.CGColor;
            _outterLayer.strokeColor = LJGesturePwdLockColorWorry.CGColor;
            _triangleLayer.hidden = YES;
            break;
        default:
            break;
    }
    
}

/** 调整箭头方向 */
- (void)lj_adjustmentTriangleDirectionFromP:(CGPoint)fromeP toP:(CGPoint)toP{
    _triangleLayer.hidden = NO;
    CGFloat h = toP.y - fromeP.y;
    CGFloat w = toP.x - fromeP.x;
    // 当 w < 0 时需要增加一个 M_PI 的弧度
    CGFloat angle = atan(h / w)  + M_PI_2 + ((w < 0 ) ? M_PI : 0) ;
    self.transform = CGAffineTransformMakeRotation(angle);
}
@end
