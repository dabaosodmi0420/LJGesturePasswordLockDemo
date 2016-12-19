//
//  LJGesturePwdLockMainView.m
//  LJRuntime_Prictise
//
//  Created by Apple on 2016/12/14.
//  Copyright © 2016年 LJ. All rights reserved.
//

#import "LJGesturePwdLockMainView.h"
#import "LJGesturePwdLockView.h"
#import "LJGesturePwdLockHeader.h"
#import "LJGesturePwdOperation.h"
#import "CALayer+LJAnimation.h"
#import <AudioToolbox/AudioToolbox.h>
#import "LJGesturePwdLockShowItemsView.h"
@interface LJGesturePwdLockMainView ()

/** 文字提示 */
@property (nonatomic, strong) UILabel *promptL;

/** 回调 */
@property (nonatomic, strong) LJGesturePwdMainSuccessBlock mainBlock;

@property (nonatomic, strong) LJGesturePwdLockView *lockView;

@property (nonatomic, strong) LJGesturePwdLockShowItemsView *showItemsView;

@end

@implementation LJGesturePwdLockMainView

- (instancetype)initWithFrame:(CGRect)frame successBlock:(LJGesturePwdMainSuccessBlock)block{
    self = [super initWithFrame:frame];
    if (self) {
        _mainBlock = block;
        [self initUI];
    }
    return self;
}
- (void)initUI{
    
    _showItemsView = [[LJGesturePwdLockShowItemsView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
    _showItemsView.center = CGPointMake(self.frame.size.width * 0.5, 80);
    [self addSubview:_showItemsView];
    
    self.promptL = [[UILabel alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(_showItemsView.frame) + 20, self.frame.size.width - 60, 30)];
    [self.promptL setAdjustsFontSizeToFitWidth:YES];
    self.promptL.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.promptL];
    
    CGFloat lockViewWH = self.frame.size.width - 50;
    _lockView = [[LJGesturePwdLockView alloc]initWithFrame:CGRectMake((self.frame.size.width - lockViewWH) * 0.5, CGRectGetMaxY(self.promptL.frame) + 30, lockViewWH, lockViewWH)];
    [self addSubview:_lockView];
    
    __weak typeof(self) wakSelf = self;
    _lockView.pwdBlock = ^(NSString *pwd){
        NSLog(@"%@",pwd);
        [wakSelf gestureLockUseType:pwd];
    };
    
    
    
}

/** 判断输入密码的三种状态 */
- (void)setGesturePwdUseType:(LJGesturePwdLockUseType)gesturePwdUseType{
    _gesturePwdUseType = gesturePwdUseType;
    switch (self.gesturePwdUseType) {
        case LJGesturePwdLockUseTypeSetting:
        {
            [self setPromptlTypeWithText:LJGesPromptMes_Setting_Trying isNormal:YES];
        }
            break;
        case LJGesturePwdLockUseTypeReset:
        {
            [self setPromptlTypeWithText:LJGesPromptMes_Reset_OldPwd isNormal:YES];
        }
            break;
        case LJGesturePwdLockUseTypeValidate:
        {
            [self setPromptlTypeWithText:LJGesPromptMes_Validate_Prompt isNormal:YES];
        }
            break;
        default:
            break;
    }
    
}
/** 设置提示Label状态 */
- (void)setPromptlTypeWithText:(NSString *)text isNormal:(BOOL)isNormal{
    self.promptL.text = text;
    if (isNormal) {
        self.promptL.textColor = LJGesturePwdLockColorPromptLabel;
    }else{
        self.promptL.textColor = LJGesturePwdLockColorWorry;
        [self.promptL.layer lj_shakeComplete:nil];
        /** 手势锁视图震动 */
//        [_lockView lj_failShake];
    }
    
}

/** 判断当前设置密码的状态及相关操作 */
- (void)gestureLockUseType:(NSString *)pwd{
    //    __weak typeof(self) weakSelf = self;
    switch (self.gesturePwdUseType) {
        
        case LJGesturePwdLockUseTypeSetting: // 设置密码
        {
            [LJGesturePwdOperation lj_settingPwd:pwd block:^(BOOL isSuccess, LJPwdOperationSettingType state) {
                if (state == LJPwdOperationSettingTypePwdMinNum){
                    [self setPromptlTypeWithText:LJGesPromptMes_Setting_MinNum isNormal:NO];
                    // 震动效果
                    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                }else if (state == LJPwdOperationSettingTypeFirstPwdSet) {
                    [self.showItemsView lj_showPwd:pwd];
                    [self setPromptlTypeWithText:LJGesPromptMes_Setting_AgainValidate isNormal:YES];
                }else if(state == LJPwdOperationSettingTypeValidataPwd){
                    if (isSuccess) {
                        [self setPromptlTypeWithText:LJGesPromptMes_Setting_Success isNormal:YES];
                        [self.showItemsView lj_showPwd:pwd];
                        if (_mainBlock) {
                            _mainBlock();
                        }
                    }else{
                        [self setPromptlTypeWithText:LJGesPromptMes_Setting_ValidateFail isNormal:NO];
                        // 震动效果
                        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                    }
                }
                
            }];
        }
            break;
        
        case LJGesturePwdLockUseTypeReset: // 重置密码
        {
            [LJGesturePwdOperation lj_resettingPwd:pwd block:^(BOOL isSuccess, LJPwdOperationResettingType state) {
                if(state == LJPwdOperationResettingTypeExistPwd){
                    [self setPromptlTypeWithText:LJGesPromptMes_Re_Va_NoSettingPwd isNormal:NO];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        self.gesturePwdUseType = LJGesturePwdLockUseTypeSetting;
                    });
                    // 震动效果
                    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                }else if (state == LJPwdOperationResettingTypeValidateFail){
                    [self setPromptlTypeWithText:LJGesPromptMes_Re_Va_ValidateFail isNormal:NO];
                    // 震动效果
                    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                }else if (state == LJPwdOperationResettingTypeValidateSuccess){
                    self.gesturePwdUseType = LJGesturePwdLockUseTypeSetting;
                }
            }];
        }
            break;
        
        case LJGesturePwdLockUseTypeValidate: // 验证密码
        {
            [LJGesturePwdOperation lj_validatePwd:pwd block:^(BOOL isSuccess, LJPwdOperationValidateType state) {
                if(state == LJPwdOperationValidateTypeExistPwd){
                    [self setPromptlTypeWithText:LJGesPromptMes_Re_Va_NoSettingPwd isNormal:NO];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        self.gesturePwdUseType = LJGesturePwdLockUseTypeSetting;
                    });
                    // 震动效果
                    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                }else if (state == LJPwdOperationValidateTypeValidateFail){
                    [self setPromptlTypeWithText:LJGesPromptMes_Re_Va_ValidateFail isNormal:NO];
                    // 震动效果
                    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                }else if (state == LJPwdOperationValidateTypeValidataSuccess){
                    [self setPromptlTypeWithText:LJGesPromptMes_Validate_PwdSuccess isNormal:YES];
                    [self.showItemsView lj_showPwd:pwd];
                    if (_mainBlock) {
                        _mainBlock();
                    }
                }
            }];
        }
            break;
        default:
            break;
    }
}

@end
