//
//  RentTankerMainController.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/8.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RentTankerMainController.h"
#import "RentTankerProcessController.h"
#import "PumpTaskHistoryController.h"
#import "BaseNavigationController.h"
#import "RentTankerHistoryController.h"
#import "RentVehicleInfoController.h"


@implementation RentTankerMainController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initItem];
    [self initTabBar];
}

- (void)initItem
{
    //UIStoryboard *board = [UIStoryboard storyboardWithName:@"Tanker" bundle:nil];
    
    RentTankerProcessController *process = [[RentTankerProcessController alloc] init];
    
    UIViewController *history = [[RentTankerHistoryController alloc] init];
    
    RentVehicleInfoController *vehicle = [[RentVehicleInfoController alloc] init];
    
    UIStoryboard *comBoard = [UIStoryboard storyboardWithName:@"Common" bundle:nil];
    UIViewController *controller = [comBoard instantiateViewControllerWithIdentifier:@"hzs_person"];
    
    
    
    BaseNavigationController *nav1 = [[BaseNavigationController alloc] init];
    BaseNavigationController *nav2 = [[BaseNavigationController alloc] init];
    BaseNavigationController *nav3 = [[BaseNavigationController alloc] init];
    BaseNavigationController *nav4 = [[BaseNavigationController alloc] init];
    
    
    [nav1 pushViewController:process animated:YES];
    [nav2 pushViewController:history animated:YES];
    [nav3 pushViewController:vehicle animated:YES];
    [nav4 pushViewController:controller animated:YES];
    
    self.viewControllers = [NSArray arrayWithObjects:nav1, nav2, nav3, nav4, nil];
}

- (void)initTabBar
{
    UITabBar *tabBar = self.tabBar;
    [[tabBar.items objectAtIndex:0] setImage:[UIImage imageNamed:@"mainpage"]];
    [[tabBar.items objectAtIndex:0] setTitle:@"执行中"];
    
    [[tabBar.items objectAtIndex:1] setImage:[UIImage imageNamed:@"icon_my_order"]];
    [[tabBar.items objectAtIndex:1] setTitle:@"历史"];
    
    [[tabBar.items objectAtIndex:2] setImage:[UIImage imageNamed:@"icon_other_order"]];
    [[tabBar.items objectAtIndex:2] setTitle:@"车辆"];
    
    [[tabBar.items objectAtIndex:3] setImage:[UIImage imageNamed:@"icon_statistics"]];
    [[tabBar.items objectAtIndex:3] setTitle:@"我的"];
}


@end
