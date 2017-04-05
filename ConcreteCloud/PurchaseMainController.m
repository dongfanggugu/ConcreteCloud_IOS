//
//  PurchaseMainController.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2016/11/22.
//  Copyright © 2016年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PurchaseMainController.h"
#import "PMainpageController.h"
#import "BaseNavigationController.h"

@interface PurchaseMainController()

@end

@implementation PurchaseMainController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initItem];
    [self initTabBar];
}

- (void)initItem
{
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Purchaser" bundle:nil];
    UIViewController *mainpage = [board instantiateViewControllerWithIdentifier:@"p_main_page"];
    UIViewController *myOrder = [board instantiateViewControllerWithIdentifier:@"p_my_order"];
    UIViewController *otherOrder = [board instantiateViewControllerWithIdentifier:@"p_other_order"];
    UIViewController *statistics = [board instantiateViewControllerWithIdentifier:@"p_statistics"];
    UIViewController *more = [board instantiateViewControllerWithIdentifier:@"p_more"];
    
    
    BaseNavigationController *nav1 = [[BaseNavigationController alloc] init];
    BaseNavigationController *nav2 = [[BaseNavigationController alloc] init];
    BaseNavigationController *nav3 = [[BaseNavigationController alloc] init];
    BaseNavigationController *nav4 = [[BaseNavigationController alloc] init];
    BaseNavigationController *nav5 = [[BaseNavigationController alloc] init];
    

    [nav1 pushViewController:mainpage animated:YES];
    [nav2 pushViewController:myOrder animated:YES];
    [nav3 pushViewController:otherOrder animated:YES];
    [nav4 pushViewController:statistics animated:YES];
    [nav5 pushViewController:more animated:YES];
    
    self.viewControllers = [NSArray arrayWithObjects:nav1, nav2, nav3, nav4, nav5, nil];
}

- (void)initTabBar
{
    UITabBar *tabBar = self.tabBar;
    [[tabBar.items objectAtIndex:0] setImage:[UIImage imageNamed:@"mainpage"]];
    [[tabBar.items objectAtIndex:0] setTitle:@"首页"];
    
    [[tabBar.items objectAtIndex:1] setImage:[UIImage imageNamed:@"icon_my_order"]];
    [[tabBar.items objectAtIndex:1] setTitle:@"我的订单"];
    
    [[tabBar.items objectAtIndex:2] setImage:[UIImage imageNamed:@"icon_other_order"]];
    [[tabBar.items objectAtIndex:2] setTitle:@"其他订单"];
    
    [[tabBar.items objectAtIndex:3] setImage:[UIImage imageNamed:@"icon_statistics"]];
    [[tabBar.items objectAtIndex:3] setTitle:@"统计"];
    
    [[tabBar.items objectAtIndex:4] setImage:[UIImage imageNamed:@"icon_more_normal"]];
    [[tabBar.items objectAtIndex:4] setTitle:@"更多"];
}

@end
