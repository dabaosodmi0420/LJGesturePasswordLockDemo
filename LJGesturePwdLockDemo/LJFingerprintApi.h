//
//  LJFingerprintApi.h
//  指纹Api
//
//  Created by Apple on 2017/2/15.
//  Copyright © 2017年 LJ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LJFingerprintApiBlock)(BOOL isSuccess);
@interface LJFingerprintApi : NSObject
//验证的方法
+ (void)lj_fingerprintValidateWithMessage:(NSString *)message block:(LJFingerprintApiBlock)block;

@end
