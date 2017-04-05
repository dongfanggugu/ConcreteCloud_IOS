//
//  BaseViewController.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2016/11/22.
//  Copyright © 2016年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseViewController.h"

@interface BaseViewController()

@end

@implementation BaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _screenWidth = [UIScreen mainScreen].bounds.size.width;
    _screenHeight = [UIScreen mainScreen].bounds.size.height;
    self.view.backgroundColor = [UIColor whiteColor];
    if (self.navigationController)
    {
        self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    }
}


- (void)dealloc
{
    NSLog(@"%@ dealloc", [self class]);
}

#pragma mark -- 设置状态栏字体为白色
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
