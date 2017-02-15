//
//  LJFingerprintApi.m
//  指纹Api
//
//  Created by Apple on 2017/2/15.
//  Copyright © 2017年 LJ. All rights reserved.
//

#import "LJFingerprintApi.h"
#import <LocalAuthentication/LocalAuthentication.h>

@interface LJFingerprintApi(){
    
}

@end

LJFingerprintApiBlock _block;

@implementation LJFingerprintApi

//验证的方法
+ (void)lj_fingerprintValidateWithMessage:(NSString *)message block:(LJFingerprintApiBlock)block
{
    
    _block = block;
    //初始化上下文对象
    LAContext* context = [[LAContext alloc] init];
    //错误对象
    NSError* error = nil;
    NSString* result = message == nil ? @"通过Home键验证指纹解锁" : message;
    
    //首先使用canEvaluatePolicy 判断设备支持状态
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        //支持指纹验证
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:result reply:^(BOOL success, NSError *error) {
            if (success) {
                
                NSLog(@"验证成功");
                //验证成功，主线程处理UI
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    if (_block) {
                        _block(YES);
                    }
                }];
            }
            else
            {
                NSLog(@"%@",error.localizedDescription);
                switch (error.code) {
                    case LAErrorSystemCancel:
                    {
                        NSLog(@"系统取消了验证touch id");
                        //切换到其他APP，系统取消验证Touch ID
                        break;
                    }
                    case LAErrorUserCancel:
                    {
                        NSLog(@"用户取消了验证");
                        //用户取消验证Touch ID
                        break;
                    }
                    case LAErrorUserFallback:
                    {
                        NSLog(@"用户选择手动输入密码");
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            //用户选择其他验证方式，切换主线程处理
                            if (_block) {
                                _block(NO);
                            }
                        }];
                        break;
                    }
                    default:
                    {
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            
                            NSLog(@"其它情况");
                            if (_block) {
                                _block(NO);
                            }
                            //其他情况，切换主线程处理
                        }];
                        break;
                    }
                }
            }
        }];
    }
    else
    {
        //不支持指纹识别，LOG出错误详情
        
        switch (error.code) {
            case LAErrorTouchIDNotEnrolled:
            {
                NSLog(@"设备Touch ID不可用，用户未录入");
                break;
            }
            case LAErrorPasscodeNotSet:
            {
                NSLog(@"系统未设置密码");
                break;
            }
            default:
            {
                NSLog(@"TouchID 不可用");
                break;
            }
        }
        
    }
}


@end
