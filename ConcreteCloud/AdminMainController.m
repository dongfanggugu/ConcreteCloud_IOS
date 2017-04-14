//
//  AdminMainController.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/10.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AdminMainController.h"
#import "BaseNavigationController.h"
#import "AdminProcessController.h"
#import "PumpTaskHistoryController.h"
#import "ChatController.h"
#import "VehicleController.h"
#import "RentDriverController.h"
#import "RenterTaskListController.h"
#import "RenterAdminMoreController.h"

@interface AdminMainController()

@end

@implementation AdminMainController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initItem];
    [self initTabBar];
}

- (void)initItem
{
    //UIStoryboard *board = [UIStoryboard storyboardWithName:@"Tanker" bundle:nil];
    
    VehicleController *vehicle = [[VehicleController alloc] init];
    
    UIViewController *staff = [[RentDriverController alloc] init];
    
    UIViewController *process = [[AdminProcessController alloc] init];
    
    UIViewController *taskList = [[RenterTaskListController alloc] init];
        
    UIViewController *more = [[RenterAdminMoreController alloc] init];
    
    
    
    BaseNavigationController *nav1 = [[BaseNavigationController alloc] init];
    BaseNavigationController *nav2 = [[BaseNavigationController alloc] init];
    BaseNavigationController *nav3 = [[BaseNavigationController alloc] init];
    BaseNavigationController *nav4 = [[BaseNavigationController alloc] init];
    BaseNavigationController *nav5 = [[BaseNavigationController alloc] init];
    
    
    [nav1 pushViewController:vehicle animated:YES];
    [nav2 pushViewController:staff animated:YES];
    [nav3 pushViewController:process animated:YES];
    [nav4 pushViewController:taskList animated:YES];
    [nav5 pushViewController:more animated:YES];
    
    self.viewControllers = [NSArray arrayWithObjects:nav1, nav2, nav3, nav4, nav5, nil];
}

- (void)initTabBar
{
    UITabBar *tabBar = self.tabBar;
    [[tabBar.items objectAtIndex:0] setImage:[UIImage imageNamed:@"icon_renter"]];
    [[tabBar.items objectAtIndex:0] setTitle:@"车辆"];
    
    [[tabBar.items objectAtIndex:1] setImage:[UIImage imageNamed:@"icon_driver"]];
    [[tabBar.items objectAtIndex:1] setTitle:@"司机"];
    
    [[tabBar.items objectAtIndex:2] setImage:[UIImage imageNamed:@"icon_process"]];
    [[tabBar.items objectAtIndex:2] setTitle:@"执行中"];
    
    [[tabBar.items objectAtIndex:3] setImage:[UIImage imageNamed:@"icon_task"]];
    [[tabBar.items objectAtIndex:3] setTitle:@"运输单"];
    
    [[tabBar.items objectAtIndex:4] setImage:[UIImage imageNamed:@"icon_more_normal"]];
    [[tabBar.items objectAtIndex:4] setTitle:@"更多"];
    
    self.selectedIndex = 2;
    
}


@end

