//
//  ACheckerMainController.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/24.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ACheckerMainController.h"
#import "PMainpageController.h"
#import "BaseNavigationController.h"

@interface ACheckerMainController()

@end

@implementation ACheckerMainController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initItem];
    [self initTabBar];
}

- (void)initItem
{
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"AChecker" bundle:nil];
    
    
    UIViewController *check = [board instantiateViewControllerWithIdentifier:@"acheck_controller"];
    UIViewController *site = [board instantiateViewControllerWithIdentifier:@"asite_check_controller"];
    UIViewController *history = [board instantiateViewControllerWithIdentifier:@"acheck_history_controller"];
    
    UIStoryboard *disBoard = [UIStoryboard storyboardWithName:@"Dispatcher" bundle:nil];
    
    UIViewController *order = [disBoard instantiateViewControllerWithIdentifier:@"d_order_controller"];
    
    UIViewController *more = [board instantiateViewControllerWithIdentifier:@"acheck_more_controller"];
    
    
    BaseNavigationController *nav1 = [[BaseNavigationController alloc] init];
    BaseNavigationController *nav2 = [[BaseNavigationController alloc] init];
    BaseNavigationController *nav3 = [[BaseNavigationController alloc] init];
    BaseNavigationController *nav4 = [[BaseNavigationController alloc] init];
    BaseNavigationController *nav5 = [[BaseNavigationController alloc] init];
    
    
    [nav1 pushViewController:check animated:YES];
    [nav2 pushViewController:site animated:YES];
    [nav3 pushViewController:history animated:YES];
    [nav4 pushViewController:order animated:YES];
    [nav5 pushViewController:more animated:YES];
    
    self.viewControllers = [NSArray arrayWithObjects:nav1, nav2, nav3, nav4, nav5, nil];
}

- (void)initTabBar
{
    UITabBar *tabBar = self.tabBar;
    [[tabBar.items objectAtIndex:0] setImage:[UIImage imageNamed:@"mainpage"]];
    [[tabBar.items objectAtIndex:0] setTitle:@"检验任务"];
    
    [[tabBar.items objectAtIndex:1] setImage:[UIImage imageNamed:@"icon_my_order"]];
    [[tabBar.items objectAtIndex:1] setTitle:@"现场检验"];
    
    [[tabBar.items objectAtIndex:2] setImage:[UIImage imageNamed:@"icon_other_order"]];
    [[tabBar.items objectAtIndex:2] setTitle:@"历史"];
    
    [[tabBar.items objectAtIndex:3] setImage:[UIImage imageNamed:@"icon_statistics"]];
    [[tabBar.items objectAtIndex:3] setTitle:@"混凝土订单"];
    
    [[tabBar.items objectAtIndex:4] setImage:[UIImage imageNamed:@"icon_more_normal"]];
    [[tabBar.items objectAtIndex:4] setTitle:@"更多"];
}

@end
