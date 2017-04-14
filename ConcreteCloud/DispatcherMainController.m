//
//  DispatcherMainController.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/16.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DispatcherMainController.h"
#import "BaseNavigationController.h"
#import "DispatchMoreController.h"
#import "DOrderController.h"

@implementation DispatcherMainController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initItem];
    [self initTabBar];
}

- (void)initItem
{
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Dispatcher" bundle:nil];
    
    UIViewController *mainpage = [board instantiateViewControllerWithIdentifier:@"d_main_page_controller"];
    
    UIViewController *project = [board instantiateViewControllerWithIdentifier:@"project_controller"];
    
    DOrderController *order = [board instantiateViewControllerWithIdentifier:@"d_order_controller"];
    order.role = Role_Dispather;
    
    UIViewController *rent = [board instantiateViewControllerWithIdentifier:@"rent_controller"];
    
    UIViewController *more = [[DispatchMoreController alloc] init];
    
    
    BaseNavigationController *nav1 = [[BaseNavigationController alloc] init];
    BaseNavigationController *nav2 = [[BaseNavigationController alloc] init];
    BaseNavigationController *nav3 = [[BaseNavigationController alloc] init];
    BaseNavigationController *nav4 = [[BaseNavigationController alloc] init];
    BaseNavigationController *nav5 = [[BaseNavigationController alloc] init];
    
    
    [nav1 pushViewController:mainpage animated:YES];
    [nav2 pushViewController:project animated:YES];
    [nav3 pushViewController:order animated:YES];
    [nav4 pushViewController:rent animated:YES];
    [nav5 pushViewController:more animated:YES];
    
    self.viewControllers = [NSArray arrayWithObjects:nav1, nav2, nav3, nav4, nav5, nil];
}

- (void)initTabBar
{
    UITabBar *tabBar = self.tabBar;
    [[tabBar.items objectAtIndex:0] setImage:[UIImage imageNamed:@"mainpage"]];
    [[tabBar.items objectAtIndex:0] setTitle:@"首页"];
    
    [[tabBar.items objectAtIndex:1] setImage:[UIImage imageNamed:@"icon_project"]];
    [[tabBar.items objectAtIndex:1] setTitle:@"工程"];
    
    [[tabBar.items objectAtIndex:2] setImage:[UIImage imageNamed:@"icon_order"]];
    [[tabBar.items objectAtIndex:2] setTitle:@"订单"];
    
    [[tabBar.items objectAtIndex:3] setImage:[UIImage imageNamed:@"icon_renter"]];
    [[tabBar.items objectAtIndex:3] setTitle:@"租赁"];
    
    [[tabBar.items objectAtIndex:4] setImage:[UIImage imageNamed:@"icon_more_normal"]];
    [[tabBar.items objectAtIndex:4] setTitle:@"更多"];
}


@end
