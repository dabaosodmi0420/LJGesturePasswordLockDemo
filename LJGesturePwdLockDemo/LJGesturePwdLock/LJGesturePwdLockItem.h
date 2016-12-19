//
//  LJGesturePwdLockItem.h
//  LJRuntime_Prictise
//
//  Created by Apple on 2016/12/13.
//  Copyright © 2016年 LJ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    LJGesturePwdLockItemNormal = 0,
    LJGesturePwdLockItemSeleected,
    LJGesturePwdLockItemWorry
} LJGesturePwdLockItemType;

@interface LJGesturePwdLockItem : UIView
/** 类型 */
@property (nonatomic, assign) LJGesturePwdLockItemType gestureLockType;

- (void)lj_adjustmentTriangleDirectionFromP:(CGPoint)fromeP toP:(CGPoint)toP;


@end
