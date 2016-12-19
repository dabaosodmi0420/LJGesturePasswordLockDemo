//
//  CALayer+LJAnimation.h
//  LJRuntime_Prictise
//
//  Created by Apple on 2016/12/15.
//  Copyright © 2016年 LJ. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

typedef void(^LJAniCompleteBlock)();

@interface CALayer (LJAnimation) <CAAnimationDelegate>

/** 震动动画 */
- (void)lj_shakeComplete:(LJAniCompleteBlock)complete;


@end
