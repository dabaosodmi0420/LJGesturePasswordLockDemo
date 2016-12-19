//
//  LJGesturePwdLockHeader.h
//  LJRuntime_Prictise
//
//  Created by Apple on 2016/12/14.
//  Copyright © 2016年 LJ. All rights reserved.
//

#define LJGestureColor(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#define LJGesturePwdLockBackColor LJGestureColor(11,36,72,1)
// 提示文字颜色
#define LJGesturePwdLockColorPromptLabel [UIColor whiteColor]
// 错误时颜色
#define LJGesturePwdLockColorWorry [UIColor redColor]
// 每个item正常状态下的颜色
#define LJGesturePwdLockItemColorNormal LJGestureColor(30,108,226,0.5)
// 每个item选中状态下的颜色
#define LJGesturePwdLockItemColorSelected LJGestureColor(36,160,246,1)

// 屏幕宽高
#define LJGesturePwdLockUseIphoneWidth [UIScreen mainScreen].bounds.size.width
#define LJGesturePwdLockUseIphoneHeight [UIScreen mainScreen].bounds.size.height

// 设置密码最小的位数
#define LJGesturePwdLock_PwdMinNum 4

// 文字提示
#define LJGesPromptMes_Setting_Trying           @"请滑动设置密码"
#define LJGesPromptMes_Setting_MinNum           @"请至少设置4个点"
#define LJGesPromptMes_Setting_AgainValidate    @"请再次确认密码"
#define LJGesPromptMes_Setting_Success          @"设置密码成功"
#define LJGesPromptMes_Setting_ValidateFail     @"两次输入密码不正确"
#define LJGesPromptMes_Reset_OldPwd             @"请输入旧密码"
#define LJGesPromptMes_Re_Va_NoSettingPwd       @"您还没有设置过密码，请先设置密码"
#define LJGesPromptMes_Re_Va_ValidateFail       @"密码验证失败，请重新验证"
#define LJGesPromptMes_Validate_Validate        @"验证密码"
#define LJGesPromptMes_Validate_Prompt          @"请正确输入密码"
#define LJGesPromptMes_Validate_PwdSuccess      @"密码正确"

#define LJGesTitle_Setting      @"设置密码"
#define LJGesTitle_Reset        @"重置密码"
#define LJGesTitle_Validate     @"验证密码"
