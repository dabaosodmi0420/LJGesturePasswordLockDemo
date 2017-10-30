//
//  ViewController.m
//  LJGesturePwdLockDemo
//
//  Created by Apple on 2016/12/19.
//  Copyright © 2016年 LJ. All rights reserved.
//

#import "ViewController.h"
#import "LJGesturePwdLockController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor];
    
}
- (IBAction)setting:(id)sender {
    LJGesturePwdLockController *gestureVC = [[LJGesturePwdLockController alloc]init];
    gestureVC.type = LJGesturePwdTypeSetting;
    [self presentViewController:gestureVC animated:YES completion:nil];
}
- (IBAction)reset:(id)sender {
    LJGesturePwdLockController *gestureVC = [[LJGesturePwdLockController alloc]init];
    gestureVC.type = LJGesturePwdTypeReset;
    [self presentViewController:gestureVC animated:YES completion:nil];
}
- (IBAction)validate:(id)sender {
    LJGesturePwdLockController *gestureVC = [[LJGesturePwdLockController alloc]init];
    gestureVC.type = LJGesturePwdTypeValidate;
    [self presentViewController:gestureVC animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
