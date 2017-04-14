//
//  OthersMainController.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/16.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OthersMainController.h"
#import "PMainpageController.h"
#import "BaseNavigationController.h"
#import "CheckController.h"
#import "MoreController.h"
#import "StatisticsController.h"
#import "DOrderController.h"

@interface OthersMainController()

@end

@implementation OthersMainController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initItem];
    [self initTabBar];
}

- (void)initItem
{
    UIStoryboard *boardP = [UIStoryboard storyboardWithName:@"Purchaser" bundle:nil];
    UIViewController *purchase = [boardP instantiateViewControllerWithIdentifier:@"p_other_order"];
    
    UIStoryboard *boardD = [UIStoryboard storyboardWithName:@"Dispatcher" bundle:nil];
    DOrderController *dispatch = [boardD instantiateViewControllerWithIdentifier:@"d_order_controller"];
    dispatch.role = Role_Hzs_Other;
    
    UIViewController *check = [[CheckController alloc] init];
    
    UIViewController *statistics = [[StatisticsController alloc] init];
    
    

    UIViewController *more = [[MoreController alloc] init];
    
    
    BaseNavigationController *nav1 = [[BaseNavigationController alloc] init];
    BaseNavigationController *nav2 = [[BaseNavigationController alloc] init];
    BaseNavigationController *nav3 = [[BaseNavigationController alloc] init];
    BaseNavigationController *nav4 = [[BaseNavigationController alloc] init];
    BaseNavigationController *nav5 = [[BaseNavigationController alloc] init];
    
    
    [nav1 pushViewController:purchase animated:YES];
    [nav2 pushViewController:dispatch animated:YES];
    [nav3 pushViewController:check animated:YES];
    [nav4 pushViewController:statistics animated:YES];
    [nav5 pushViewController:more animated:YES];
    
    self.viewControllers = [NSArray arrayWithObjects:nav1, nav2, nav3, nav4, nav5, nil];
}

- (void)initTabBar
{
    UITabBar *tabBar = self.tabBar;
    [[tabBar.items objectAtIndex:0] setImage:[UIImage imageNamed:@"icon_purchase_order"]];
    [[tabBar.items objectAtIndex:0] setTitle:@"采购订单"];
    
    [[tabBar.items objectAtIndex:1] setImage:[UIImage imageNamed:@"icon_concrete_order"]];
    [[tabBar.items objectAtIndex:1] setTitle:@"混凝土订单"];
    
    [[tabBar.items objectAtIndex:2] setImage:[UIImage imageNamed:@"icon_in_check"]];
    [[tabBar.items objectAtIndex:2] setTitle:@"检验"];
    
    [[tabBar.items objectAtIndex:3] setImage:[UIImage imageNamed:@"icon_statistics"]];
    [[tabBar.items objectAtIndex:3] setTitle:@"统计"];
    
    [[tabBar.items objectAtIndex:4] setImage:[UIImage imageNamed:@"icon_more_normal"]];
    [[tabBar.items objectAtIndex:4] setTitle:@"更多"];
}

@end
