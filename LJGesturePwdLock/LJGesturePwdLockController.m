//
//  LJGesturePwdLockController.m
//  LJRuntime_Prictise
//
//  Created by Apple on 2016/12/14.
//  Copyright © 2016年 LJ. All rights reserved.
//

#import "LJGesturePwdLockController.h"
#include "LJGesturePwdLockMainView.h"
#import "LJGesturePwdLockHeader.h"
#import "LJFingerprintApi.h"
@interface LJGesturePwdLockController ()

@property (nonatomic, strong) LJGesturePwdLockMainView *gestureMainView;

@property (nonatomic, strong) UILabel *titleLabel;

/**  */
@property (nonatomic, strong) UIButton *fingerprintBtn;

@end

@implementation LJGesturePwdLockController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = LJGesturePwdLockBackColor;
    
    
}
- (void)initUI{
    
    [self.view addSubview:self.gestureMainView];
    
    UIView *navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    navView.backgroundColor = LJGesturePwdLockItemColorSelected;
//    [self.view addSubview:navView];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(15, 30, 40, 30);
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn setTitleColor:LJGesturePwdLockColorPromptLabel forState:UIControlStateNormal];
    backBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [backBtn addTarget:self action:@selector(backClickDown) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont systemFontOfSize:17];
    _titleLabel.textColor = LJGesturePwdLockColorPromptLabel;
    _titleLabel.center = CGPointMake(LJGesturePwdLockUseIphoneWidth * 0.5, backBtn.frame.size.height * 0.5 + backBtn.frame.origin.y);
    [self.view addSubview:_titleLabel];
    
    
}
- (void)backClickDown{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (LJGesturePwdLockMainView *)gestureMainView{
    if (!_gestureMainView) {
        _gestureMainView = [[LJGesturePwdLockMainView alloc]initWithFrame:CGRectMake(0, 64, LJGesturePwdLockUseIphoneWidth, LJGesturePwdLockUseIphoneHeight - 64) successBlock:^{
            NSLog(@"---------");
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self dismissViewControllerAnimated:YES completion:nil];
            });
        }];
    }
    return _gestureMainView;
}


- (void)setType:(LJGesturePwdType)type{
    _type = type;
    
    [self initUI];
    
    switch (type) {
        case LJGesturePwdTypeSetting:
        {
            self.titleLabel.text = LJGesTitle_Setting;
            _gestureMainView.gesturePwdUseType = LJGesturePwdLockUseTypeSetting;
        }
            break;
        case LJGesturePwdTypeReset:
        {
            self.titleLabel.text = LJGesTitle_Reset;
            _gestureMainView.gesturePwdUseType = LJGesturePwdLockUseTypeReset;
        }
            break;
        case LJGesturePwdTypeValidate:
        {
            self.titleLabel.text = LJGesTitle_Validate;
            _gestureMainView.gesturePwdUseType = LJGesturePwdLockUseTypeValidate;
            
            /** 当为验证信息的时候添加指纹验证功能 */
            [self.view addSubview:self.fingerprintBtn];
            [self fingerprintClick];
        }
            break;
        default:
            break;
    }
}

- (void)fingerprintClick{
    [LJFingerprintApi lj_fingerprintValidateWithMessage:nil block:^(BOOL isSuccess) {
        if (isSuccess) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

- (UIButton *)fingerprintBtn{
    if (!_fingerprintBtn) {
        _fingerprintBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _fingerprintBtn.frame =  CGRectMake( LJGesturePwdLockUseIphoneWidth - 80, 30, 60, 30);
        [_fingerprintBtn setTitle:@"指纹验证" forState:UIControlStateNormal];
        [_fingerprintBtn setTitleColor:LJGesturePwdLockColorPromptLabel forState:UIControlStateNormal];
        _fingerprintBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_fingerprintBtn addTarget:self action:@selector(fingerprintClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fingerprintBtn;
}

@end
