//
//  LJGesturePwdLockController.h
//  LJRuntime_Prictise
//
//  Created by Apple on 2016/12/14.
//  Copyright © 2016年 LJ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    LJGesturePwdTypeSetting = 0, // 设置密码
    LJGesturePwdTypeReset,       // 重置密码
    LJGesturePwdTypeValidate     // 验证密码
}LJGesturePwdType;

@interface LJGesturePwdLockController : UIViewController

/** 手势控件的类别 */
@property (nonatomic, assign) LJGesturePwdType type;


@end
