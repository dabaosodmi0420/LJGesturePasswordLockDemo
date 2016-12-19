//
//  LJGesturePwdLockView.h
//  LJRuntime_Prictise
//
//  Created by Apple on 2016/12/13.
//  Copyright © 2016年 LJ. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef void(^LJPasswordBlock)(NSString *pwd);

@interface LJGesturePwdLockView : UIView

/** 回调 */
@property (nonatomic, strong) LJPasswordBlock pwdBlock;

/** 失败时的震动 */
- (void)lj_failShake;

@end
