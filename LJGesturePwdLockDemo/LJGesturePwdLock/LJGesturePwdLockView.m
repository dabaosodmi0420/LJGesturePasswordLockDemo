//
//  LJGesturePwdLockView.m
//  LJRuntime_Prictise
//
//  Created by Apple on 2016/12/13.
//  Copyright © 2016年 LJ. All rights reserved.
//

#import "LJGesturePwdLockView.h"
#import "LJGesturePwdLockItem.h"
#import "LJGesturePwdLockHeader.h"
#import "CALayer+LJAnimation.h"

@interface LJGesturePwdLockView()

/** item数组 */
@property (nonatomic, strong) NSMutableArray <LJGesturePwdLockItem *>*itemsArrMu;
/** item选择数组 */
@property (nonatomic, strong) NSMutableArray <LJGesturePwdLockItem *>*itemSelectedArrMu;
/** 手势当前的点 */
@property (nonatomic, assign) CGPoint currentP;
/** 密码 */
@property (nonatomic, copy) NSString *pwd;
@end

@implementation LJGesturePwdLockView

#pragma mark - 初始化设置
- (instancetype)initWithFrame:(CGRect)frame{
    CGFloat WH = MIN(frame.size.width, frame.size.height);
    self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, WH, WH)];
    if (self) {
        [self initialize];
    }
    return self;
}
- (void)initialize{
    self.backgroundColor = [UIColor clearColor];
    self.clearsContextBeforeDrawing = YES;
    self.itemsArrMu = [NSMutableArray array];
    self.itemSelectedArrMu = [NSMutableArray array];
    [self initView];
}
/** 初始布局 */
- (void)initView{
    CGFloat space = self.frame.size.width / 34.0 * 16 / 4;
    CGFloat itemWH = (self.frame.size.width - 4 * space) / 3.0;
    
    for (NSUInteger i = 0; i < 9; i++) {
        NSUInteger row = i / 3;
        NSUInteger colum = i % 3;
        CGFloat pointX = space * (colum + 1) + itemWH * colum;
        CGFloat pointY = space * (row + 1) + itemWH * row;
        CGRect itemF = CGRectMake(pointX, pointY, itemWH, itemWH);
        LJGesturePwdLockItem *item = [[LJGesturePwdLockItem alloc]initWithFrame:itemF];
        [self addSubview:item];
        
        [self.itemsArrMu addObject:item];
    }
}

#pragma mark - 外部方法
/** 失败时的震动 */
- (void)lj_failShake{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        for (LJGesturePwdLockItem *item in self.itemsArrMu) {
            item.gestureLockType = LJGesturePwdLockItemWorry;
        }
        [self.layer lj_shakeComplete:^{
            for (LJGesturePwdLockItem *item in self.itemsArrMu) {
                item.gestureLockType = LJGesturePwdLockItemNormal;
            }
        }];
    });
}
#pragma mark - 内部使用方法
/** 获取手势当前点 */
- (CGPoint)lj_currentPosition:(NSSet<UITouch *> *)touches{
    UITouch *touch = [touches anyObject];
    self.currentP = [touch locationInView:self];
    return self.currentP;
}
/** 扫面手势当前点在哪个item上 */
- (void)lj_scanItemWithPoint:(CGPoint)point{
    
    for (LJGesturePwdLockItem *item in self.itemsArrMu) {
        if (CGRectContainsPoint(item.frame, point) && item.gestureLockType == LJGesturePwdLockItemNormal && ![self.itemSelectedArrMu containsObject:item]) {
            item.gestureLockType = LJGesturePwdLockItemSeleected;
            [self.itemSelectedArrMu addObject:item];
        }
    }

}
/** 恢复所有item初始化 */
- (void)lj_recoveryItems{
    for (LJGesturePwdLockItem *item in self.itemsArrMu) {
        item.gestureLockType = LJGesturePwdLockItemNormal;
    }
    [self.itemSelectedArrMu removeAllObjects];
    [self setNeedsDisplay];
}
/** 获取每个item的中心点 */
- (CGPoint)lj_itemCenterP:(LJGesturePwdLockItem *)item{
    return CGPointMake(item.frame.origin.x + item.frame.size.width * 0.5, item.frame.origin.y + item.frame.size.height * 0.5);
}

/** 获取当前输入的密码 */
- (NSString *)lj_getPwd{
    
    NSMutableString *pwd = [NSMutableString string];
    for (NSUInteger i = 0; i < self.itemSelectedArrMu.count; i++) {
        NSUInteger index = [self.itemsArrMu indexOfObject:self.itemSelectedArrMu[i]];
        [pwd appendString:[NSString stringWithFormat:@"%ld",index]];
    }
    return pwd;
    
}
#pragma mark - touch事件
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    CGPoint point = [self lj_currentPosition:touches];
    [self lj_scanItemWithPoint:point];
    
}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesMoved:touches withEvent:event];
    CGPoint point = [self lj_currentPosition:touches];
    [self lj_scanItemWithPoint:point];
    
    [self setNeedsDisplay];
    
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    if (self.pwdBlock) {
        self.pwdBlock([self lj_getPwd]);
    }
    [self lj_recoveryItems];
}
- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesCancelled:touches withEvent:event];
    [self lj_recoveryItems];
}

#pragma mark - 绘图
- (void)drawRect:(CGRect)rect {
    
    if(self.itemSelectedArrMu.count <= 0) return;
    
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    for (NSUInteger i = 0; i < self.itemSelectedArrMu.count; i++) {
        LJGesturePwdLockItem *item = self.itemSelectedArrMu[i];
        CGPoint point = [self lj_itemCenterP:item];
        if (i == 0) {
            [linePath moveToPoint:point];
        }else{
            [linePath addLineToPoint:point];
            LJGesturePwdLockItem *previousItem = self.itemSelectedArrMu[i - 1];
            [previousItem lj_adjustmentTriangleDirectionFromP:previousItem.center toP:item.center];
        }
    }
    [linePath addLineToPoint:self.currentP];
    linePath.lineWidth = self.frame.size.width / 80.0;
    linePath.lineJoinStyle = kCGLineJoinRound;
    linePath.lineCapStyle = kCGLineCapRound;
    [LJGesturePwdLockItemColorSelected setStroke];
    [linePath stroke];

}


@end
