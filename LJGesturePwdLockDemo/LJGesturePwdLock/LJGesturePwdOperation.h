//
//  LJGesturePwdOperation.h
//  LJRuntime_Prictise
//
//  Created by Apple on 2016/12/14.
//  Copyright © 2016年 LJ. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 设置密码的枚举 */
typedef enum : NSUInteger {
    LJPwdOperationSettingTypePwdMinNum = 0, // 密码设置最小位数不够
    LJPwdOperationSettingTypeFirstPwdSet,   // 设置的第一次密码
    LJPwdOperationSettingTypeValidataPwd    // 验证密码是否与上一次相同
}LJPwdOperationSettingType;

/** 重置密码的枚举 */
typedef enum : NSUInteger {
    LJPwdOperationResettingTypeExistPwd = 0,      // 是否设置过密码
    LJPwdOperationResettingTypeValidateFail,      // 验证失败
    LJPwdOperationResettingTypeValidateSuccess    // 验证成功
}LJPwdOperationResettingType;

/** 验证密码的枚举 */
typedef enum : NSUInteger {
    LJPwdOperationValidateTypeExistPwd = 0,      // 是否设置过密码
    LJPwdOperationValidateTypeValidateFail,      // 验证失败
    LJPwdOperationValidateTypeValidataSuccess    // 验证成功
}LJPwdOperationValidateType;

/** 设置密码回调 */
typedef void (^LJSettingPwdBlock)(BOOL isSuccess, LJPwdOperationSettingType state);
/** 重置密码回调 */
typedef void (^LJResettingPwdBlock)(BOOL isSuccess, LJPwdOperationResettingType state);
/** 验证密码回调 */
typedef void (^LJValidatePwdBlock)(BOOL isSuccess, LJPwdOperationValidateType state);


@interface LJGesturePwdOperation : NSObject

/** 是否是第一次 */
+ (BOOL)lj_isFirstInput;

/** 第一次进入设置密码 */
+ (void)lj_settingPwd:(NSString *)pwd block:(LJSettingPwdBlock)block;

/** 重置密码 */
+ (void)lj_resettingPwd:(NSString *)pwd block:(LJResettingPwdBlock)block;

/** 验证密码 */
+ (void)lj_validatePwd:(NSString *)pwd block:(LJValidatePwdBlock)block;

@end
