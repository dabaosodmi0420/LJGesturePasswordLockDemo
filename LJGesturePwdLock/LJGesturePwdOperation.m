//
//  LJGesturePwdOperation.m
//  LJRuntime_Prictise
//
//  Created by Apple on 2016/12/14.
//  Copyright © 2016年 LJ. All rights reserved.
//

#import "LJGesturePwdOperation.h"
#import "LJGesturePwdLockHeader.h"
#define LJGesturePwd @"LJGesturePwd"

@interface LJGesturePwdOperation()


@end

@implementation LJGesturePwdOperation

/** 上一次密码 */
NSString *_previousPwd = nil;

/** 密码的操作 */
/** 设置密码 */
+ (void)lj_settingPwd:(NSString *)pwd block:(LJSettingPwdBlock)block{
    
    // 设置的密码位数不能少于4 位
    if(pwd.length < LJGesturePwdLock_PwdMinNum && _previousPwd == nil){
        if (block) {
            block(NO, LJPwdOperationSettingTypePwdMinNum);
        }
        return ;
    }
    if (_previousPwd == nil) { // 第一次输入密码 
        _previousPwd = pwd;
        block(NO,LJPwdOperationSettingTypeFirstPwdSet);
    }else{
        // 第二次密码确认
        if ([_previousPwd isEqualToString:pwd]) {
            if (block) {
                _previousPwd = nil;
                block(YES,LJPwdOperationSettingTypeValidataPwd);
            }
            [LJGesturePwdOperation lj_savePwd:pwd];
        }else {
            if (block) {
                block(NO,LJPwdOperationSettingTypeValidataPwd);
            }
            
        }
    }
    
}
/** 重置密码 */
+ (void)lj_resettingPwd:(NSString *)pwd block:(LJResettingPwdBlock)block{
    // 检查是否没有设置过密码
    if([LJGesturePwdOperation lj_isFirstInput]){
        if (block) {
            block(NO, LJPwdOperationResettingTypeExistPwd);
        }
    }else{
        // 验证的密码是否正确
        if (![[LJGesturePwdOperation lj_getPwd] isEqualToString:pwd]) {
            if (block) {
                block(NO, LJPwdOperationResettingTypeValidateFail);
            }
        }else{
            if (block) {
                block(NO, LJPwdOperationResettingTypeValidateSuccess);
            }
            
        }
    }
}
/** 验证密码 */
+ (void)lj_validatePwd:(NSString *)pwd block:(LJValidatePwdBlock)block{
    // 检查是否没有设置过密码
    if([LJGesturePwdOperation lj_isFirstInput]){
        if (block) {
            block(NO, LJPwdOperationValidateTypeExistPwd);
        }
    }else{
        // 验证的密码是否正确
        if (![[LJGesturePwdOperation lj_getPwd] isEqualToString:pwd]) {
            if (block) {
                block(NO, LJPwdOperationValidateTypeValidateFail);
            }
        }else{
            if (block) {
                block(NO, LJPwdOperationValidateTypeValidataSuccess);
            }
            
        }
    }
}
/** 是否是第一次输入 */
+ (BOOL)lj_isFirstInput{
    if ([LJGesturePwdOperation lj_getPwd]) {
        return NO;
    }else{
        return YES;
    }
}
/** 获取密码 */
+ (NSString *)lj_getPwd{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *pwd = [user objectForKey:LJGesturePwd];
    return pwd;
}
/** 保存密码 */
+ (void)lj_savePwd:(NSString *)pwd{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setValue:pwd forKey:LJGesturePwd];
    [user synchronize];
}

@end
