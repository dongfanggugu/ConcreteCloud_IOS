//
//  ComViewController.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/21.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ComViewController.h"

@implementation ComViewController


- (void)setNavTitle:(NSString *)title
{
    if (!self.navigationController)
    {
        return;
    }
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
    label.text = title;
    label.font = [UIFont fontWithName:@"System" size:17];
    label.textColor = [UIColor whiteColor];
    [label setTextAlignment:NSTextAlignmentCenter];
    [self.navigationItem setTitleView:label];
}

/**
 使用文字初始化导航栏右侧按钮
 **/
-  (void)initNavRightWithText:(NSString *)text
{
    if (!self.navigationController)
    {
        return;
    }
    
    UIButton *btnRight = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 25)];
    [btnRight setTitle:text forState:UIControlStateNormal];
    [btnRight setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnRight.titleLabel.font = [UIFont systemFontOfSize:15];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:btnRight];
    
    self.navigationItem.rightBarButtonItem = rightButton;
    
    if ([self respondsToSelector:@selector(onClickNavRight)])
    {
        [btnRight addTarget:self action:@selector(onClickNavRight) forControlEvents:UIControlEventTouchUpInside];
    }
}

@end
