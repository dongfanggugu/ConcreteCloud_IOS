//
//  SupAdminMainController.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/14.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SupAdminMainController.h"
#import "PMainpageController.h"
#import "BaseNavigationController.h"
#import "SupplierDriverProcessController.h"
#import "SupDriverHistoryController.h"
#import "SupAdminMainPageController.h"
#import "SupOrderListController.h"
#import "SupAdminMoreController.h"

@interface SupAdminMainController()

@end

@implementation SupAdminMainController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initItem];
    [self initTabBar];
}

- (void)initItem
{
    UIViewController *mainpage = [[SupAdminMainPageController alloc] init];
    UIViewController *order = [[SupOrderListController alloc] init];
    UIViewController *process = [[SupplierDriverProcessController alloc] init];
    UIViewController *history = [[SupDriverHistoryController alloc] init];
    UIViewController *more = [[SupAdminMoreController alloc] init];
    
    
    BaseNavigationController *nav1 = [[BaseNavigationController alloc] init];
    BaseNavigationController *nav2 = [[BaseNavigationController alloc] init];
    BaseNavigationController *nav3 = [[BaseNavigationController alloc] init];
    BaseNavigationController *nav4 = [[BaseNavigationController alloc] init];
    BaseNavigationController *nav5 = [[BaseNavigationController alloc] init];
    
    
    [nav1 pushViewController:mainpage animated:YES];
    [nav2 pushViewController:order animated:YES];
    [nav3 pushViewController:process animated:YES];
    [nav4 pushViewController:history animated:YES];
    [nav5 pushViewController:more animated:YES];
    
    self.viewControllers = [NSArray arrayWithObjects:nav1, nav2, nav3, nav4, nav5, nil];
}

- (void)initTabBar
{
    UITabBar *tabBar = self.tabBar;
    [[tabBar.items objectAtIndex:0] setImage:[UIImage imageNamed:@"mainpage"]];
    [[tabBar.items objectAtIndex:0] setTitle:@"首页"];
    
    [[tabBar.items objectAtIndex:1] setImage:[UIImage imageNamed:@"icon_order"]];
    [[tabBar.items objectAtIndex:1] setTitle:@"订单"];
    
    [[tabBar.items objectAtIndex:2] setImage:[UIImage imageNamed:@"icon_task"]];
    [[tabBar.items objectAtIndex:2] setTitle:@"运输单"];
    
    [[tabBar.items objectAtIndex:3] setImage:[UIImage imageNamed:@"icon_history"]];
    [[tabBar.items objectAtIndex:3] setTitle:@"历史"];
    
    [[tabBar.items objectAtIndex:4] setImage:[UIImage imageNamed:@"icon_more_normal"]];
    [[tabBar.items objectAtIndex:4] setTitle:@"更多"];
}

@end
