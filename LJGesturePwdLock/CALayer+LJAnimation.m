//
//  CALayer+LJAnimation.m
//  LJRuntime_Prictise
//
//  Created by Apple on 2016/12/15.
//  Copyright © 2016年 LJ. All rights reserved.
//

#import "CALayer+LJAnimation.h"

@interface CALayer()


@end

LJAniCompleteBlock block = nil;

@implementation CALayer (LJAnimation)

/** 震动动画 */
- (void)lj_shakeComplete:(LJAniCompleteBlock)complete{
    
    block = complete;
    CAKeyframeAnimation *kfa = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
    kfa.delegate = self;
    CGFloat s = 16;
    
    kfa.values = @[@(-s),@(0),@(s),@(0),@(-s),@(0),@(s),@(0)];
    
    //时长
    kfa.duration = .1f;
    
    //重复
    kfa.repeatCount =2;
    
    //移除
    kfa.removedOnCompletion = YES;
    
    [self addAnimation:kfa forKey:@"shake"];
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if (block) {
        block();
    }
}
@end
