//
//  SiteMainController.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/20.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SiteMainController.h"
#import "BaseNavigationController.h"

@implementation SiteMainController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initItem];
    [self initTabBar];
}

- (void)initItem
{
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Site" bundle:nil];
    UIViewController *mainpage = [board instantiateViewControllerWithIdentifier:@"s_main_page_controller"];
    UIViewController *hzs = [board instantiateViewControllerWithIdentifier:@"hzs_controller"];
    UIViewController *mOrder = [board instantiateViewControllerWithIdentifier:@"s_my_order_controller"];
    UIViewController *oOrder = [board instantiateViewControllerWithIdentifier:@"s_other_order_controller"];
    UIViewController *more = [board instantiateViewControllerWithIdentifier:@"s_more_controller"];
    
    
    BaseNavigationController *nav1 = [[BaseNavigationController alloc] init];
    BaseNavigationController *nav2 = [[BaseNavigationController alloc] init];
    BaseNavigationController *nav3 = [[BaseNavigationController alloc] init];
    BaseNavigationController *nav4 = [[BaseNavigationController alloc] init];
    BaseNavigationController *nav5 = [[BaseNavigationController alloc] init];
    
    
    [nav1 pushViewController:mainpage animated:YES];
    [nav2 pushViewController:hzs animated:YES];
    [nav3 pushViewController:mOrder animated:YES];
    [nav4 pushViewController:oOrder animated:YES];
    [nav5 pushViewController:more animated:YES];
    
    self.viewControllers = [NSArray arrayWithObjects:nav1, nav2, nav3, nav4, nav5, nil];
}

- (void)initTabBar
{
    UITabBar *tabBar = self.tabBar;
    [[tabBar.items objectAtIndex:0] setImage:[UIImage imageNamed:@"mainpage"]];
    [[tabBar.items objectAtIndex:0] setTitle:@"首页"];
    
    [[tabBar.items objectAtIndex:1] setImage:[UIImage imageNamed:@"icon_hzs"]];
    [[tabBar.items objectAtIndex:1] setTitle:@"搅拌站"];
    
    [[tabBar.items objectAtIndex:2] setImage:[UIImage imageNamed:@"icon_order"]];
    [[tabBar.items objectAtIndex:2] setTitle:@"我的订单"];
    
    [[tabBar.items objectAtIndex:3] setImage:[UIImage imageNamed:@"icon_other_order"]];
    [[tabBar.items objectAtIndex:3] setTitle:@"其他订单"];
    
    [[tabBar.items objectAtIndex:4] setImage:[UIImage imageNamed:@"icon_more_normal"]];
    [[tabBar.items objectAtIndex:4] setTitle:@"更多"];
}


@end
