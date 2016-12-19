//
//  LJGesturePwdLockShowItemsView.m
//  LJRuntime_Prictise
//
//  Created by Apple on 2016/12/16.
//  Copyright © 2016年 LJ. All rights reserved.
//

#import "LJGesturePwdLockShowItemsView.h"
#import "LJGesturePwdLockHeader.h"

@interface LJGesturePwdLockShowItemsView()

/** item数组 */
@property (nonatomic, strong) NSMutableArray *itemsArrMu;

@end

@implementation LJGesturePwdLockShowItemsView

- (instancetype)initWithFrame:(CGRect)frame{
    CGFloat WH = MIN(frame.size.width, frame.size.height);
    self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, WH, WH)];
    if (self) {
        [self initialize];
    }
    return self;
}
- (void)initialize{
    self.backgroundColor = [UIColor clearColor];
    self.clearsContextBeforeDrawing = YES;
    self.itemsArrMu = [NSMutableArray array];
    
    [self initView];
}
- (void)initView{
    CGFloat space = self.frame.size.width / 34.0 * 16 / 4;
    CGFloat itemWH = (self.frame.size.width - 4 * space) / 3.0;
    
    for (NSUInteger i = 0; i < 9; i++) {
        NSUInteger row = i / 3;
        NSUInteger colum = i % 3;
        CGFloat pointX = space * (colum + 1) + itemWH * colum;
        CGFloat pointY = space * (row + 1) + itemWH * row;
        CGRect itemF = CGRectMake(pointX, pointY, itemWH, itemWH);
        UIView *item = [[UIView alloc]initWithFrame:itemF];
        item.backgroundColor = [UIColor whiteColor];
        item.layer.cornerRadius = itemWH * 0.5;
        [self addSubview:item];
        
        [self.itemsArrMu addObject:item];
    }
}
- (void)lj_recoveryItems{
    for (UIView *item in self.itemsArrMu) {
        item.backgroundColor = [UIColor whiteColor];
    }
}
- (void)lj_showPwd:(NSString *)pwd{
    [self lj_recoveryItems];
    for (NSUInteger i = 0; i < pwd.length; i++) {
        NSUInteger index = [[pwd substringWithRange:NSMakeRange(i, 1)] integerValue];
        UIView *item = self.itemsArrMu[index];
        item.backgroundColor = item.backgroundColor = LJGesturePwdLockItemColorSelected;
    }
   }

@end
