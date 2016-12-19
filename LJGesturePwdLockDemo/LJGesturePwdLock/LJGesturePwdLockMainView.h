//
//  LJGesturePwdLockMainView.h
//  LJRuntime_Prictise
//
//  Created by Apple on 2016/12/14.
//  Copyright © 2016年 LJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LJGesturePwdLockView.h"
typedef enum : NSUInteger{
    LJGesturePwdLockUseTypeSetting = 0, //设置
    LJGesturePwdLockUseTypeReset,       //重置
    LJGesturePwdLockUseTypeValidate,    //验证
    
    
}LJGesturePwdLockUseType;

// 密码操作完成回调
typedef void(^LJGesturePwdMainSuccessBlock)();

@interface LJGesturePwdLockMainView : UIView

/** 设置类别 */
@property (nonatomic, assign) LJGesturePwdLockUseType gesturePwdUseType;

- (instancetype)initWithFrame:(CGRect)frame successBlock:(LJGesturePwdMainSuccessBlock)block;

@end
